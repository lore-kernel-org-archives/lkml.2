Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0D1Sn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:43:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:51701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab0D1Sn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,289,1270450800"; 
   d="scan'208";a="793683426"
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "clalance@redhat.com" <clalance@redhat.com>,
       "drjones@redhat.com" <drjones@redhat.com>
In-Reply-To: <4BD87E72.4050609@redhat.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
	 <20100428112658.4cf11292.akpm@linux-foundation.org>
	 <4BD87E72.4050609@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 28 Apr 2010 11:42:52 -0700
Message-Id: <1272480172.2826.13.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 11:29 -0700, Prarit Bhargava wrote:
> 
> On 04/28/2010 02:26 PM, Andrew Morton wrote:
> > On Tue, 27 Apr 2010 11:24:42 -0400
> > Prarit Bhargava<prarit@redhat.com>  wrote:
> >
> >    
> >> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
> >> xen guests have irq_desc->chip_data = NULL.
> >>
> >> Test for NULL chip_data pointer before attempting to complete an irq move.
> >>
> >> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
> >> Acked-by: Suresh Siddha<suresh.b.siddha@intel.com>
> >>
> >> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> >> index 127b871..eb2789c 100644
> >> --- a/arch/x86/kernel/apic/io_apic.c
> >> +++ b/arch/x86/kernel/apic/io_apic.c
> >> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
> >>   	struct irq_desc *desc = irq_to_desc(irq);
> >>   	struct irq_cfg *cfg = desc->chip_data;
> >>
> >> +	if (!cfg)
> >> +		return;
> >> +
> >>   	__irq_complete_move(&desc, cfg->vector);
> >>   }
> >>   #else
> >>      
> > I assume this is needed for 2.6.34?
> >
> > What about 2.6.33.x and earlier?
> >    
> 
> Hey Andrew,
> 
> I actually pinged Chris Wright to see about including this in the 
> -stable branches.  I haven't heard anything back so I'll reping him.

It will be applicable for 2.6.33 and beyond.

thanks,
suresh

