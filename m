Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2FFMw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:52:57 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42321 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FFMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:52:56 -0400
Date: Wed, 6 Jun 2012 14:53:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v29] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120606125320.GC1644@aftab.osrc.amd.com>
References: <1338563258-13322-1-git-send-email-mchehab@redhat.com>
 <20120601152151.GC28216@aftab.osrc.amd.com>
 <4FC8E5C4.4080008@redhat.com>
 <20120605130752.GE13495@aftab.osrc.amd.com>
 <4FCF31EF.1090405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FCF31EF.1090405@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 07:33:19AM -0300, Mauro Carvalho Chehab wrote:
> RAS: Add a tracepoint for reporting memory controller events
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>

[ … ]

> The tracepoint printk will be displayed like:
> 
> mc_event: [quant] (Corrected|Uncorrected|Fatal) error:[error msg] on memory stick [label] ([location] [edac_mc detail] [driver_d$
> 
> Where:
>        	[quant] is the quantity of errors
> 	[error msg] is the driver-specific error message
> 		    (e. g. "memory read", "bus error", ...);
> 	[location] is the location in terms of memory controller and
> 		   branch/channel/slot, channel/slot or csrow/channel;
> 	[label] is the memory stick label;
> 	[edac_mc detail] describes the address location of the error
> 			 and the syndrome;
> 	[driver detail] is driver-specifig error message details,
> 			when needed/provided (e. g. "area:DMA", ...)
> 
> For example:
> 
> mc_event: 1 Corrected error:memory read on memory stick DIMM_1A (mc:0 location:0:0:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)
> 
> Of course, any userspace tools meant to handle errors should not parse
> the above data. They should, instead, use the binary fields provided by
> the tracepoint, mapping them directly into their Management Information
> Base.
> 
> NOTE: The original patch was providing an additional mechanism for
> MCA-based trace events that also contained MCA error register data.
> However, as no agreement was reached so far for the MCA-based trace
> events, for now, let's add events only for memory errors.
> A latter patch is planned to change the tracepoint, for those types
> of event.
> 
> Cc: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Ok, this is starting to shape up, here's the output on my box here:

       mcegen.py-3009  [008] .N..   144.149649: mc_event: 1 Corrected error: amd64_edac on unknown memory (mc:0 location:3:1:-1 address:0x000007ba grain:2 syndrome:0x0000ac71)

Tony, any objections?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
