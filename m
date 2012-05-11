Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab2EKPBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:01:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36960 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab2EKPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:01:17 -0400
Date: Fri, 11 May 2012 12:01:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
Message-ID: <20120511150111.GA2485@infradead.org>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
 <1336242167.2463.138.camel@laptop>
 <20120505235319.GB2150@infradead.org>
 <1336271107.1534.12.camel@leonhard>
 <20120506183212.GB2485@infradead.org>
 <878vh4srmh.fsf@sejong.aot.lge.com>
 <87vck3ii18.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vck3ii18.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 11, 2012 at 11:10:59AM +0900, Namhyung Kim escreveu:
> On Mon, 07 May 2012 10:32:22 +0900, Namhyung Kim wrote:
> > I thought about it before, but it still cannot protect it from accessing
> > a hists by multiple concurrent threads. IOW if two threads call the
> > function to a same hists at the same time, ->callchain_collapse_cursor
> > would still get the race problem - so crashed.
> >
> > I guess callchain_cursor should be thread-local, eventually. No need to
> > make it hist-local IMHO.
> 
> So, any thoughts?

Can you try writing a patch using TLS?

- Arnaldo
