Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1KNXOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:14:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39357 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1KNXOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:14:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH] PM / devfreq: correct Kconfig dependency
Date: Tue, 15 Nov 2011 00:16:51 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Hilman, Kevin" <khilman@ti.com>,
        "Turquette, Mike" <mturquette@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <CAJ0PZbSO7n7P0r_i+tOWmxtzxx0T9kTRgnC2eLXn9m69k5HsKw@mail.gmail.com>
In-Reply-To: <CAJ0PZbSO7n7P0r_i+tOWmxtzxx0T9kTRgnC2eLXn9m69k5HsKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150016.51389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 14, 2011, MyungJoo Ham wrote:
> Devfreq does not depend on OPP. The dependency is removed.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied to linux-pm/pm-fixes.

Thanks,
Rafael


> ---
>  drivers/devfreq/Kconfig |   41 +++++++++++++++++------------------------
>  1 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index 8fd34e7..87a742f 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -1,36 +1,29 @@
> -config ARCH_HAS_DEVFREQ
> -	bool
> -	depends on ARCH_HAS_OPP
> -	help
> -	  Denotes that the architecture supports DEVFREQ. If the architecture
> -	  supports multiple OPP entries per device and the frequency of the
> -	  devices with OPPs may be altered dynamically, the architecture
> -	  supports DEVFREQ.
> -
>  menuconfig PM_DEVFREQ
>  	bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) support"
> -	depends on PM_OPP && ARCH_HAS_DEVFREQ
>  	help
> -	  With OPP support, a device may have a list of frequencies and
> -	  voltages available. DEVFREQ, a generic DVFS framework can be
> -	  registered for a device with OPP support in order to let the
> -	  governor provided to DEVFREQ choose an operating frequency
> -	  based on the OPP's list and the policy given with DEVFREQ.
> +	  A device may have a list of frequencies and voltages available.
> +	  devfreq, a generic DVFS framework can be registered for a device
> +	  in order to let the governor provided to devfreq choose an
> +	  operating frequency based on the device driver's policy.
> 
> -	  Each device may have its own governor and policy. DEVFREQ can
> +	  Each device may have its own governor and policy. Devfreq can
>  	  reevaluate the device state periodically and/or based on the
> -	  OPP list changes (each frequency/voltage pair in OPP may be
> -	  disabled or enabled).
> +	  notification to "nb", a notifier block, of devfreq.
> 
> -	  Like some CPUs with CPUFREQ, a device may have multiple clocks.
> +	  Like some CPUs with CPUfreq, a device may have multiple clocks.
>  	  However, because the clock frequencies of a single device are
> -	  determined by the single device's state, an instance of DEVFREQ
> +	  determined by the single device's state, an instance of devfreq
>  	  is attached to a single device and returns a "representative"
> -	  clock frequency from the OPP of the device, which is also attached
> -	  to a device by 1-to-1. The device registering DEVFREQ takes the
> -	  responsiblity to "interpret" the frequency listed in OPP and
> +	  clock frequency of the device, which is also attached
> +	  to a device by 1-to-1. The device registering devfreq takes the
> +	  responsiblity to "interpret" the representative frequency and
>  	  to set its every clock accordingly with the "target" callback
> -	  given to DEVFREQ.
> +	  given to devfreq.
> +
> +	  When OPP is used with the devfreq device, it is recommended to
> +	  register devfreq's nb to the OPP's notifier head.  If OPP is
> +	  used with the devfreq device, you may use OPP helper
> +	  functions defined in devfreq.h.
> 
>  if PM_DEVFREQ
> 
> 

