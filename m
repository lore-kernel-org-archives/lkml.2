Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab2ERHMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:12:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54472 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2ERHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:12:49 -0400
Date: Fri, 18 May 2012 09:12:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120518071244.GE429@gmail.com>
References: <1337287277-523-1-git-send-email-mchehab@redhat.com>
 <20120517214859.GA16777@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517214859.GA16777@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, May 17, 2012 at 05:41:17PM -0300, Mauro Carvalho Chehab wrote:
> > Add a new tracepoint-based hardware events report method for
> > reporting Memory Controller events.
> > 
> > Part of the description bellow is shamelessly copied from Tony
> > Luck's notes about the Hardware Error BoF during LPC 2010 [1].
> > Tony, thanks for your notes and discussions to generate the
> > h/w error reporting requirements.
> > 
> > [1] http://lwn.net/Articles/416669/
> > 
> >     We have several subsystems & methods for reporting hardware errors:
> > 
> >     1) EDAC ("Error Detection and Correction").  In its original form
> >     this consisted of a platform specific driver that read topology
> >     information and error counts from chipset registers and reported
> >     the results via a sysfs interface.
> > 
> >     2) mcelog - x86 specific decoding of machine check bank registers
> >     reporting in binary form via /dev/mcelog. Recent additions make use
> >     of the APEI extensions that were documented in version 4.0a of the
> >     ACPI specification to acquire more information about errors without
> >     having to rely reading chipset registers directly. A user level
> >     programs decodes into somewhat human readable format.
> > 
> >     3) drivers/edac/mce_amd.c - this driver hooks into the mcelog path and
> >     decodes errors reported via machine check bank registers in AMD
> >     processors to the console log using printk();
> > 
> >     Each of these mechanisms has a band of followers ... and none
> >     of them appear to meet all the needs of all users.
> > 
> > As part of a RAS subsystem, let's encapsulate the memory error hardware
> > events into a trace facility.
> > 
> > The tracepoint printk will be displayed like:
> > 
> > mc_event: (Corrected|Uncorrected|Fatal) error:[error msg] on memory stick "[label]" ([location] [edac_mc detail] [driver_detail])
> > 
> > Where:
> > 	[error msg] is the driver-specific error message
> > 		    (e. g. "memory read", "bus error", ...);
> > 	[location] is the location in terms of memory controller and
> > 		   branch/channel/slot, channel/slot or csrow/channel;
> > 	[label] is the memory stick label;
> > 	[edac_mc detail] describes the address location of the error
> > 			 and the syndrome;
> > 	[driver detail] is driver-specifig error message details,
> > 			when needed/provided (e. g. "area:DMA", ...)
> > 
> > For example:
> > 
> > mc_event: Corrected error:memory read on memory stick "DIMM_1A" (mc:0 channel:0 slot:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)
> > 
> > Of course, any userspace tools meant to handle errors should not parse
> > the above data. They should, instead, use the binary fields provided by
> > the tracepoint, mapping them directly into their MIBs.
> 
> Nacked-by: Borislav Petkov <borislav.petkov@amd.com>

Just wondering why this got nacked, and what the 
suggestions/plans are to improve the situation: I assume Mauro 
is working on these things to solve problems, or to add 
features, Mauro could you please give a higher level list of 
those problems or features? There must be more to it than just a 
new tracepoint! :-)

Thanks,

	Ingo
