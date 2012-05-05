Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2EEXxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 19:53:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59019 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2EEXxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 19:53:24 -0400
Date: Sat, 5 May 2012 20:53:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
Message-ID: <20120505235319.GB2150@infradead.org>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
 <1336242167.2463.138.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336242167.2463.138.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 05, 2012 at 08:22:47PM +0200, Peter Zijlstra escreveu:
> On Sun, 2012-05-06 at 00:23 +0900, Namhyung Kim wrote:
> > +       static struct callchain_cursor cursor;
> 
> This just begs to become another concurrency problem. If anybody manages
> to call multiple hists__collapse_insert_entry() concurrently you're
> again up some creek without no paddle.
> 
> Adding global state is never a good option when dealing with
> concurrency.

But it seems to fix the current issue, so thanks to Namhyung for
following up on the report and David Ahern for reporting that it was a
cross thread corruption (Namhyung, was your work based on that report?).

I'm looking how to get that fixed with Peter concerns addressed.

First testing Namhyung patch with -F 100000 tho :-)

- Arnaldo
