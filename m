Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2KGOl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:41:27 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47154 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2KGOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:41:25 -0500
Date: Wed, 7 Nov 2012 15:41:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de, andre.przywara@amd.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: Re: [RFC PATCH 1/3] sched: add sched_policy and it's sysfs interface
Message-ID: <20121107144137.GD14146@kroah.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
 <1352207399-29497-2-git-send-email-alex.shi@intel.com>
 <20121106134831.GA969@kroah.com>
 <509A53A5.5090909@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509A53A5.5090909@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 08:27:17PM +0800, Alex Shi wrote:
> >> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> >> index 6345294..5f6a573 100644
> >> --- a/drivers/base/cpu.c
> >> +++ b/drivers/base/cpu.c
> >> @@ -330,4 +330,6 @@ void __init cpu_dev_init(void)
> >>  		panic("Failed to register CPU subsystem");
> >>  
> >>  	cpu_dev_register_generic();
> >> +
> >> +	create_sysfs_sched_policy_group(cpu_subsys.dev_root);
> > 
> > Are you sure you didn't just race with userspace, creating the sysfs
> > files after the device was created and announced to userspace?
> 
> Sorry for don't fully get you. Is the sysfs announced to userspace
> just in 'mount -t sysfs sysfs /sys'?

No, when the struct device is registered with the driver core.

> The old powersaving interface: sched_smt_power_savings also
> created here. and cpu_dev_init was called early before do_initcalls
> which cpuidle/cpufreq sysfs were initialized.
> 
> Do you mean this line need to init as core_initcall?

No, you need to make this as an attribute group for the device, so the
driver core will create it automatically before it tells userspace that
the device is now present.

Use the default attribute groups and you should be fine.

Hope this helps,

greg k-h
