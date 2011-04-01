Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1DAEg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:36:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33935 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590Ab1DAEgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:36:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+lrMZzqNKlzFOW6N10I4WyzgoPHH0S+g4kHSEdxW
	9ceT7udI3YzuoO
Subject: Re: Linux 2.6.33.8
From: Mike Galbraith <efault@gmx.de>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D94C666.3060206@osadl.org>
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 06:35:55 +0200
Message-ID: <1301632555.4766.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 20:22 +0200, Carsten Emde wrote:
> Greg,
> 
> > I'm announcing the release of the 2.6.33.8 kernel.
> >
> > This is primarily for the use of those people who are stuck using the
> > .33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
> > is welcome to use this one as well.
> Thanks a lot for your work. It's highly appreciated.
> 
> While preparing 2.6.33.8/9 plus PREEMPT_RT patches for quality
> assurance in our farm, I found that the "halt" command no longer
> powers down the pretest machine (i7/Gulftown); this misbehavior occurs
> with and without the PREEMPT_RT patches.
> 
> 2.6.33.7:
> # halt
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> sd 2:0:0:0: [sdb] Stopping disk
> The machine is powered down.
> 
> 2.6.33.8:
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> sd 2:0:0:0: [sdb] Stopping disk
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> The machine is NOT powered down. Can be powered down only by pulling
> the power plug or holding the on/off button for 5 seconds.

(FWIW, my x3550 M3 (E5620) and Q6600 power down fine with 2.6.33.9-rt30)

> Bisecting from 2.6.33.7 to 2.6.33.8 revealed:
> 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c is the first bad commit
> commit 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Dec 10 23:57:04 2010 -0500
> 
>      x86, hotplug: Use mwait to offline a processor, fix the legacy case
> 
>      upstream ea53069231f9317062910d6e772cca4ce93de8c8
>      x86, hotplug: Use mwait to offline a processor, fix the legacy case

The question would appear to be does mainline beyond this point exhibit
the same symptom?

	-Mike


