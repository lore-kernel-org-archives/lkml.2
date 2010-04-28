Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0D1Sv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:51:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394Ab0D1Sv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:51:26 -0400
Date: Wed, 28 Apr 2010 11:50:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com, stable@kernel.org
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
Message-Id: <20100428115039.c276594a.akpm@linux-foundation.org>
In-Reply-To: <4BD87E72.4050609@redhat.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
	<20100428112658.4cf11292.akpm@linux-foundation.org>
	<4BD87E72.4050609@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 14:29:06 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
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
> 

Well.  Pinging people offlist isn't very reliable.  Put

Cc: <stable@kernel.org>

at the end of the changelog and cc stable@kernel.org on the original
patch and then the patch will reliably receive consideration for
backporting.

I have added Cc:<stable@kernel.org> to my copy of the patch, so the
-stable guys will at least see it when I drop it after it is merged. 
But if the x86 maintainers were to merge your patch as you sent it, it
would have no Cc: <stable@kernel.org> when it goes into Linus's tree.

I worry that if the -stable maintainer see me drop a patch, but the
patch in Linus's tree doesn't have the stable tag, they might not merge
the fix into -stable.  I bugged them about this scenario recently and
the reply was a bit waffly ;)

By far the safest thing to do is to include the stable tag in your
changelog right at the outset.
