Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1LSQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:29:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:44070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1LSQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:29:24 -0500
Date: Mon, 19 Dec 2011 14:29:16 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Nelson Elhage <nelhage@nelhage.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: __perf_evlist__mmap: Fix errno value on failed
 map.
Message-ID: <20111219162916.GA28058@infradead.org>
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
 <1324301972-22740-2-git-send-email-nelhage@nelhage.com>
 <87k45sr2yd.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k45sr2yd.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 20, 2011 at 12:33:30AM +0900, Namhyung Kim escreveu:
> Nelson Elhage <nelhage@nelhage.com> writes:
> > On failure, perf_evlist__mmap_per_{cpu,thread} will try to munmap()
> > every map that doesn't have a NULL base. This will fail with EINVAL if
> > one of them has base == MAP_FAILED, clobbering errno, so that
> > perf_evlist__map will return EINVAL on any failure regardless of the
> > root cause.
> >
> > Fix this by resetting failed maps to a NULL base.
> >
> > Signed-off-by: Nelson Elhage <nelhage@nelhage.com>

> Thanks for fixing this. I posted a basically same patch for this [1]
> last week, but it seems my patch doesn't get included yet (right?),
> and your patch looks bit simpler. So Arnaldo, I'm totally fine if you
> decide to take this instead of mine.

Ok, and thank you both for the fixes, I was out on a business trip so a
bit backlogged right now, will get to your patches as soon as possible,

Thanks!

- Arnaldo
 
> Thanks.
> Namhyung Kim
> 
> 
> [1] https://lkml.org/lkml/2011/12/12/275
