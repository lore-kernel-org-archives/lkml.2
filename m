Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0GNVFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab0GNVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:05:52 -0400
Date: Wed, 14 Jul 2010 17:05:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
Message-ID: <20100714210519.GT5381@redhat.com>
References: <4C3BD6AA.3070908@kernel.org>
 <4C3CE210.2030902@zytor.com>
 <4C3CF650.30905@kernel.org>
 <4C3E1FA0.9000107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E1FA0.9000107@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 01:35:44PM -0700, Yinghai Lu wrote:
> On 07/13/2010 04:27 PM, Yinghai Lu wrote:
> > On 07/13/2010 03:00 PM, H. Peter Anvin wrote:
> >> On 07/12/2010 07:59 PM, Yinghai Lu wrote:
> >>> tip/master: 
> >>> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
> >>>
> >>> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
> >>>
> >>> linus' tree is ok.
> >>>
> >>> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
> >>>
> >>> the problem looks start in recent two or three weeks.
> >>>
> >>> Any idea?
> >>>
> >>> bisecting will take a while, because the system post take a while everytime.
> >>>
> >>> Thanks
> >>>
> >>> Yinghai Lu
> >>
> >> OK, I found the bug... if you could test out the patch which will be
> >> sent out shortly I would very much appreciate it.
> > 
> > not sure if your patch is the offending one now.
> > 
> > kL: kernel from linus tree
> > kT1: kernel from tip
> > kT2: kernel from tip with reverting your patch
> > 
> > BIOS-->kL ---> kL ---> kL....always working
> > BIOS-->kT1 ---> kT1 --->  kT1 : between second one and third one system reset instant...
> > BIOS-->kT2 ---> kT2 --->  kT2 : between second one and third one system reset instant...
> > 
> > BIOS-->kL ---> kL ---> kL ---> then kT1 ---> kT1 .... always working
> > BIOS-->kL ---> kL ---> kL ---> then kT2 ---> kT2 .... always working
> > 
> 
> bisecting said:
> 
> > git bisect good
> 58687acba59266735adb8ccd9b5b9aa2c7cd205b is the first bad commit
> commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
> Author: Don Zickus <dzickus@redhat.com>
> Date:   Fri May 7 17:11:44 2010 -0400

What do you mean by instant reboot?  This code isn't really exercised
until the cpus come online.

I'll dig through the history of this thread to see if there is a boot log
or something to look at.

Cheers,
Don
