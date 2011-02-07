Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1BGIXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:23:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57668 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab1BGIXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:23:45 -0500
Subject: Re: [patch v2 0/3] OProfile support for System z's hardware
 sampling
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        oprofile-list@lists.sf.net, schwidefsky@de.ibm.com
In-Reply-To: <20110121100651.821690659@linux.vnet.ibm.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 09:23:41 +0100
Message-ID: <1297067021.3263.3.camel@BR8HFPP0.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

when do you have a chance do look at my patches?

Looking forward to a positive reply.

Heinz

On Fri, 2011-01-21 at 11:06 +0100, Heinz Graalfs wrote:
> Hello Robert,
> 
> I'm resending yesterday's mail because I missed to specify the correct sender information.
> 
> This is a re-posting of the patch series originally posted last month:
> 
> http://marc.info/?l=linux-s390&m=129285043619973&w=2
> 
> Heinz
> 
> Changes in
> 
> v2:
>    - kernel module hwsampler removed, everything is now in oprofile kernel module
>    - functions from hwsampler-main.c and smpctl.c merged into arch/s390/oprofile/hwsampler.c
>      - functions made static
>    - arch/s390/include/asm/hwsampler.h moved to arch/s390/oprofile/hwsampler.h
>      - structs have now hws_ prefix
>    - config variables changed, HAVE_HWSAMPLER used only
>    - original patch 4 (handle_munmap.patch) removed
> 
> Description:
> 
> So far, OProfile takes samples by using a software interrupt.
> The purpose of this series of patches is to add support for System z hardware sampling to OProfile.
> 
> Hardware (HW) sampling is a feature provided by System z processors (z10 and follow ons).
> When sampling, the processor takes samples containing the instruction address, PID, and other information.
> The samples are taken at a programmable rate and stored into a buffer provided by the operating system.
> The sampling process is implemented in hardware and millicode and thus does not affect the operating system
> being oberved, apart from requiring buffer memory that the Linux kernel must provide.
> 
> Hardware sampling is available in LPAR mode on 64 BIT processors only.
> 
> The overall approach is to replace the software-based sample generation by hardware sampling.
> All required functionality to control the HW sampling mechanism is added to the oprofile kernel module.
> The functions provide support for
>  - controlling the sampling hardware,
>  - setting up appropriate buffer structures (HW buffers),
>  - retrieving sample entries from these buffers.
> Multiple CPUs can be handled.
> 
> The samples contain the instruction address, a bit distinguishing between kernel and user space,
> and for user space samples also the PID.
> Instead of taking samples from its own per-CPU buffers, OProfile would rather take samples from the
> HW buffers.
> 
> When hardware sampling can be enabled on the current System z processor it will be the new default.
> Switching back to timer based sampling can be established by using
> 
>    echo 0 > /dev/oprofile/hwsampling/hwsampler
> 
> The user space drivers of OProfile also need an extension to control hw sampling by appropriate options.
> 
> 
> ------------------------------------------------------------------------------
> Special Offer-- Download ArcSight Logger for FREE (a $49 USD value)!
> Finally, a world-class log management solution at an even better price-free!
> Download using promo code Free_Logger_4_Dev2Dev. Offer expires 
> February 28th, so secure your free ArcSight Logger TODAY! 
> http://p.sf.net/sfu/arcsight-sfd2d
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list


