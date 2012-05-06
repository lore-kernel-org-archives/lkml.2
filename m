Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2EFCZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 22:25:16 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:39069 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2EFCZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 22:25:14 -0400
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20120505235319.GB2150@infradead.org>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
	 <1336242167.2463.138.camel@laptop>  <20120505235319.GB2150@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 May 2012 11:25:07 +0900
Message-ID: <1336271107.1534.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-05-05 (토), 20:53 -0300, Arnaldo Carvalho de Melo:
> Em Sat, May 05, 2012 at 08:22:47PM +0200, Peter Zijlstra escreveu:
> > On Sun, 2012-05-06 at 00:23 +0900, Namhyung Kim wrote:
> > > +       static struct callchain_cursor cursor;
> > 
> > This just begs to become another concurrency problem. If anybody manages
> > to call multiple hists__collapse_insert_entry() concurrently you're
> > again up some creek without no paddle.
> > 
> > Adding global state is never a good option when dealing with
> > concurrency.
> 
> But it seems to fix the current issue, so thanks to Namhyung for
> following up on the report and David Ahern for reporting that it was a
> cross thread corruption (Namhyung, was your work based on that report?).
> 

No, I didn't see the David's report since I posted it using my company
email - I don't have an access to the mail outside of the company now.
It seems I have to subscribe the perf-users mailing list though :).


> I'm looking how to get that fixed with Peter concerns addressed.
> 

I guess it's gonna be a non-trivial job. As far as I can see, the hists
code can handle up to two concurrent threads regardless of the callchain
cursor problem. And also guess that other areas of libperf also doesn't
support the true concurrency, right?


> First testing Namhyung patch with -F 100000 tho :-)
> 

Thanks,
Namhyung


