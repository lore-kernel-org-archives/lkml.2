Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab0I0O6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:58:54 -0400
Received: from imr4.ericy.com ([198.24.6.8]:36710 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab0I0O6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:58:53 -0400
Date: Mon, 27 Sep 2010 07:58:14 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: lm-sensors@lm-sensors.org, JBeulich@novell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [2/2] hwmon: cleanup some hotplug related macro definition
Message-ID: <20100927145814.GA2666@ericsson.com>
References: <1285480800-14558-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285480800-14558-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 06:00:00AM -0000, Chen Gong wrote:
> CONFIG_HOTPLUG_CPU is used too much in some drivers.
> This patch clean them up and add some proper __cpuinit definitons.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
I am ok with the changes. However, they interfer with other changes 
made by Jan earlier, which I already applied. 

It would be great if you can rebase this patch to 
	git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-next

That would help me a lot.

Thanks,
Guenter

> ---
> drivers/hwmon/coretemp.c    |    5 ++---
>  drivers/hwmon/pkgtemp.c     |    7 ++-----
>  drivers/hwmon/via-cputemp.c |    9 ++-------
>  3 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index baa842a..887ab93 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -489,7 +489,7 @@ exit:
>  	return err;
>  }
>  
> -static void coretemp_device_remove(unsigned int cpu)
> +static void __cpuinit coretemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p;
>  	unsigned int i;
> @@ -568,9 +568,8 @@ exit:
>  static void __exit coretemp_exit(void)
>  {
>  	struct pdev_entry *p, *n;
> -#ifdef CONFIG_HOTPLUG_CPU
> +
>  	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
> -#endif
>  	mutex_lock(&pdev_list_mutex);
>  	list_for_each_entry_safe(p, n, &pdev_list, list) {
>  		platform_device_unregister(p->pdev);
> diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
> index 6186041..0516d52 100644
> --- a/drivers/hwmon/pkgtemp.c
> +++ b/drivers/hwmon/pkgtemp.c
> @@ -339,8 +339,7 @@ exit:
>  	return err;
>  }
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -static void pkgtemp_device_remove(unsigned int cpu)
> +static void __cpuinit pkgtemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p;
>  	unsigned int i;
> @@ -387,7 +386,6 @@ static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
>  static struct notifier_block pkgtemp_cpu_notifier __refdata = {
>  	.notifier_call = pkgtemp_cpu_callback,
>  };
> -#endif				/* !CONFIG_HOTPLUG_CPU */
>  
>  static int __init pkgtemp_init(void)
>  {
> @@ -425,9 +423,8 @@ exit:
>  static void __exit pkgtemp_exit(void)
>  {
>  	struct pdev_entry *p, *n;
> -#ifdef CONFIG_HOTPLUG_CPU
> +
>  	unregister_hotcpu_notifier(&pkgtemp_cpu_notifier);
> -#endif
>  	mutex_lock(&pdev_list_mutex);
>  	list_for_each_entry_safe(p, n, &pdev_list, list) {
>  		platform_device_unregister(p->pdev);
> diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
> index ffb793a..ebbdc25 100644
> --- a/drivers/hwmon/via-cputemp.c
> +++ b/drivers/hwmon/via-cputemp.c
> @@ -237,8 +237,7 @@ exit:
>  	return err;
>  }
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -static void via_cputemp_device_remove(unsigned int cpu)
> +static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p, *n;
>  	mutex_lock(&pdev_list_mutex);
> @@ -272,7 +271,6 @@ static int __cpuinit via_cputemp_cpu_callback(struct notifier_block *nfb,
>  static struct notifier_block via_cputemp_cpu_notifier __refdata = {
>  	.notifier_call = via_cputemp_cpu_callback,
>  };
> -#endif				/* !CONFIG_HOTPLUG_CPU */
>  
>  static int __init via_cputemp_init(void)
>  {
> @@ -313,9 +311,7 @@ static int __init via_cputemp_init(void)
>  		goto exit_driver_unreg;
>  	}
>  
> -#ifdef CONFIG_HOTPLUG_CPU
>  	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
> -#endif
>  	return 0;
>  
>  exit_devices_unreg:
> @@ -335,9 +331,8 @@ exit:
>  static void __exit via_cputemp_exit(void)
>  {
>  	struct pdev_entry *p, *n;
> -#ifdef CONFIG_HOTPLUG_CPU
> +
>  	unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
> -#endif
>  	mutex_lock(&pdev_list_mutex);
>  	list_for_each_entry_safe(p, n, &pdev_list, list) {
>  		platform_device_unregister(p->pdev);
