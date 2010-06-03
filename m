Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0FCNnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:43:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46979 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0FCNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:42:56 -0400
Date: Thu, 3 Jun 2010 15:43:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100603134301.GA30880@kryptos.osrc.amd.com>
References: <20100523183353.GB1408@liondog.tnic>
 <1274640047.1674.1731.camel@laptop>
 <20100523185411.GA5608@liondog.tnic>
 <1274642601.1674.1755.camel@laptop>
 <20100525073246.GA6085@liondog.tnic>
 <1274799588.5882.1572.camel@twins>
 <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275070030.1645.362.camel@laptop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, May 28, 2010 at 08:07:10PM +0200

> They can be found at:
> 
> http://programming.kicks-ass.net/sekrit/patches.tar.bz2
> 
> ignore the last 5 patches, those are random hackery.
> 
> In particular, look at:
> 
> patches/perf-fix-buffer-redirect.patch
> patches/perf-buffer.patch
> patches/perf-buffer-init.patch
> 
> (they won't apply separately in that order, simply push the full queue
> until the last one or further)
> 
> After that you should be able to add:
> 
>   buffer = perf_buffer_alloc(nr_pages, watermark, cpu, flags);
>   rcu_assign_pointer(event->buffer, buffer);
> 
> to allocate and attach a buffer to your event (do so for each cpu's MCE
> event).
> 
> After that we still need a way to expose all that to userspace, but at
> least the events will be complete and able to record bits ;-)

Yep, so far so good, the kernel side is almost done - this was the
easy part :). So recently I started looking into how the userspace
part could be done most efficiently so that, initially, the RAS daemon
doesn't suck in all of tools/perf when building and depend unnecessary
on libelf etc, and, at the same time, doesn't duplicate functionality
like util/debugfs, get_debugfs_mntpt(), parse_events() maybe later etc.

So, the best way to do this, IMHO, is if I start carving out common and
generic functionality into tools/lib/ or tools/util/ or similar so that
perf and ras can share those. And maybe later even other tools. This
could be where we host all the kernel headers stuff which are good for
userspace, i.e. those which are in tools/perf/util/include/linux/

Opinions, comments?

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
