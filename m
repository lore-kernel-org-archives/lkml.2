Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1AURaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:30:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46080 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1AURaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:30:03 -0500
Date: Fri, 21 Jan 2011 15:29:37 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: peterz@infradead.org, mingo@elte.hu, tony.luck@intel.com,
        rostedt@goodmis.org, fweisbec@gmail.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 08/12] perf: Carve out mmap helpers for general use
Message-ID: <20110121172937.GC15066@ghostprotocols.net>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-9-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295622575-18607-9-git-send-email-bp@amd64.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 21, 2011 at 04:09:31PM +0100, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Export the mmap_read* helpers into tools/lib/perf/mmap.[ch]

Borislav, can you take a look at:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/core

More specifically take a look at the function test__basic_mmap in:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=blob;f=tools/perf/builtin-test.c;h=f03798a298b00b328a11f06ce20cc352d123ec28;hb=refs/heads/perf/core

434 /*
435  * This test will generate random numbers of calls to some getpid syscalls,
436  * then establish an mmap for a group of events that are created to monitor
437  * the syscalls.
438  *
439  * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
440  * sample.id field to map back to its respective perf_evsel instance.
441  *
442  * Then it checks if the number of syscalls reported as perf events by
443  * the kernel corresponds to the number of syscalls made.
444  */

I'll read the rest of your patchset to see if there are more things like
this.

- Arnaldo
