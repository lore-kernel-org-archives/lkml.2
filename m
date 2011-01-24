Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1AXJB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:01:26 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44833 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1AXJBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:01:25 -0500
Date: Mon, 24 Jan 2011 10:04:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] perf: Carve out mmap helpers for general use
Message-ID: <20110124090410.GA8924@aftab>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-9-git-send-email-bp@amd64.org>
 <20110121172937.GC15066@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121172937.GC15066@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:29:37PM -0500, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 21, 2011 at 04:09:31PM +0100, Borislav Petkov escreveu:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Export the mmap_read* helpers into tools/lib/perf/mmap.[ch]
> 
> Borislav, can you take a look at:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/core
> 
> More specifically take a look at the function test__basic_mmap in:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=blob;f=tools/perf/builtin-test.c;h=f03798a298b00b328a11f06ce20cc352d123ec28;hb=refs/heads/perf/core
> 
> 434 /*
> 435  * This test will generate random numbers of calls to some getpid syscalls,
> 436  * then establish an mmap for a group of events that are created to monitor
> 437  * the syscalls.
> 438  *
> 439  * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
> 440  * sample.id field to map back to its respective perf_evsel instance.
> 441  *
> 442  * Then it checks if the number of syscalls reported as perf events by
> 443  * the kernel corresponds to the number of syscalls made.
> 444  */

Ok, I see at least one problem with my patch - you've reworked the
mmaping functionality in evlist.c/evsel.c and I should use it too, I
guess. For that, I think you'd want me to apply my stuff ontop of your
perf/core branch, right?

Am I missing something else?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
