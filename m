Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2HDIwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 04:52:45 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23600 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2HDIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 04:52:43 -0400
Date: Sat, 4 Aug 2012 10:52:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Silas Boyd-Wickizer <sbw@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: Re: [PATCH 4/4 V2] Use get_online_cpus to avoid races involving CPU
  hotplug
Message-ID: <20120804105236.4e9c8e88@endymion.delvare>
In-Reply-To: <20120803193638.GE4227@mit.edu>
References: <20120803193638.GE4227@mit.edu>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012 12:36:39 -0700, Silas Boyd-Wickizer wrote:
> coretemp_init in drivers/hwmon/coretemp.c loops with
> for_each_online_cpu, adding platform_devices and sysfs interfaces,
> then calls register_hotcpu_notifier.  There is a race if a CPU is
> offlined or onlined after the loop, but before
> register_hotcpu_notifier.  The race might result in the absence of a
> platform_device+sysfs interface for an online CPU, or the presence of
> a platform_device+sysfs interface for an offline CPU.  A similar race
> occurs during coretemp_exit, after the module calls
> unregister_hotcpu_notifier, but before it unregisters all devices, a
> CPU might offline and a device for an offline CPU will exist for a
> short while.
> 
> This fix surrounds for_each_online_cpu and register_hotcpu_notifier
> with get_online_cpus+put_online_cpus; and surrounds
> unregister_hotcpu_notifier and device unregistering with
> get_online_cpus+put_online_cpus.
> 
> Build tested.
> 
> Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
> ---
>  drivers/hwmon/coretemp.c |    5 +++++
>  1 file changed, 5 insertions(+)
> (...)

Applied, thanks.

-- 
Jean Delvare
