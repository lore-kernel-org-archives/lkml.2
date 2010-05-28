Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0E1BoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:44:22 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:48334 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0E1BoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:44:20 -0400
Date: Thu, 27 May 2010 21:44:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle driver
 for select intel processors
In-reply-to: <201005271053.31087.trenn@suse.de>
Message-id: <alpine.LFD.2.00.1005272131400.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
 <201005271053.31087.trenn@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Thomas Renninger wrote:

> On Thursday 27 May 2010 04:42:31 Len Brown wrote:
> > From: Len Brown <len.brown@intel.com>
> ... 
> > CONFIG_INTEL_IDLE=m is not recommended unless the system
> > has a method to guarantee intel_idle loads before ACPI's
> > processor_idle.

> Then it should better be declared bool instead of tristate until it
> works.

intel_idle as a module works fine, and tristate should be retained.

If user-space chooses to load intel_idle before acpi processor,
then it correctly handlees idle states and acpi
correctly yields.  If user space gets them in the other order,
then user-space gets what it asked for.

The fact that a typical desktop distro load acpi-cpufreq first,
and that depends on the acpi processor driver should not prohibit
intel_idle from being modular.

Indeed, intel_idle has every right to be moduler on a system
where CONFIG_ACPI=n...

> > This driver does not yet know about cpu online/offline
> > and thus will not yet play well with cpu-hotplug.

> What means does not play well yet, suspend or manually offlining a core 
> will eventually (for sure?) hang the machine?

It means less power savings savings than optimal
for processors not present at module load time.

> If this is known broken, should this already be spread through
> linux-next?

If you know somebody with a system that supports CPU hot-add
on one of the processors supported by intel_idle, and they
are willing to test linux-next, please have them contact me.

thanks,
-Len Brown, Intel Open Source Technology Center
