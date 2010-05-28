Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab0E1P5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:57:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52994 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0E1P5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:57:17 -0400
Date: Fri, 28 May 2010 17:57:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100528155719.GA10141@kryptos.osrc.amd.com>
References: <1274554806-28216-2-git-send-email-bp@alien8.de>
 <1274638513.1674.1727.camel@laptop>
 <20100523183353.GB1408@liondog.tnic>
 <1274640047.1674.1731.camel@laptop>
 <20100523185411.GA5608@liondog.tnic>
 <1274642601.1674.1755.camel@laptop>
 <20100525073246.GA6085@liondog.tnic>
 <1274799588.5882.1572.camel@twins>
 <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275059860.27810.9635.camel@twins>
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
Date: Fri, May 28, 2010 at 05:17:40PM +0200

> On Fri, 2010-05-28 at 16:33 +0200, Ingo Molnar wrote:
> 
> > >  2) get these things a buffer, perf_events as created don't actually
> > >     have an output buffer, normally that is created at mmap() time, but
> > >     since you cannot mmap() a kernel side event, it doesn't get to have
> > >     a buffer. This could be done by extracting perf_mmap_data_alloc()
> > >     into a sensible interface.
> > 
> > #2 could be a new syscall: sys_create_ring_buffer or so?
> 
> No, they need a buffer in-kernel, syscalls aren't the ideal tool for
> that :-)

Yeah, I need a per-cpu buffer ready at event registration/enable time,
maybe even have perf_event_create_kernel_counter() take care of that
buffer allocation with a flag or similar prior to enabling the event...

> I've got patches refactoring the whole buffer stuff to make it more a
> self-contained entity.

Can I see those when you're done so that I can base my stuff on top?

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
