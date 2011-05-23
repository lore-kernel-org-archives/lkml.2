Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1EWDJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 23:09:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38864 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1EWDJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 23:09:26 -0400
Message-ID: <4DD9CF9E.6000103@oracle.com>
Date: Sun, 22 May 2011 20:08:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/3] PM / Hibernate: Update kerneldoc comments in hibernate.c
References: <201105211408.28671.rjw@sisk.pl> <201105211412.11782.rjw@sisk.pl>
In-Reply-To: <201105211412.11782.rjw@sisk.pl>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DD9CFB0.005A:SCFSTAT5015188,ss=1,pt=DBB_65838,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/11 05:12, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Some of the kerneldoc comments in kernel/power/hibernate.c are
> outdated and some of them don't adhere to the kernel's standards.
> Update them and make them look in a consistent way.

Hi Rafael,

Several of the functions are missing function parameter notations, as
noted below.

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/hibernate.c |  184 ++++++++++++++++++++++++-----------------------
>  1 file changed, 94 insertions(+), 90 deletions(-)
> 
> Index: linux-2.6/kernel/power/hibernate.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/hibernate.c
> +++ linux-2.6/kernel/power/hibernate.c
> @@ -55,10 +55,9 @@ static int hibernation_mode = HIBERNATIO
>  static const struct platform_hibernation_ops *hibernation_ops;
>  
>  /**
> - * hibernation_set_ops - set the global hibernate operations
> - * @ops: the hibernation operations to use in subsequent hibernation transitions
> + * hibernation_set_ops - Set the global hibernate operations.
> + * @ops: Hibernation operations to use in subsequent hibernation transitions.
>   */
> -
>  void hibernation_set_ops(const struct platform_hibernation_ops *ops)
>  {
>  	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
> @@ -115,10 +114,8 @@ static int hibernation_test(int level) {
>  #endif /* !CONFIG_PM_DEBUG */
>  
>  /**
> - *	platform_begin - tell the platform driver that we're starting
> - *	hibernation
> + * platform_begin - Use platform driver to start hibernation.

 * @platform_mode: <description>

>   */
> -
>  static int platform_begin(int platform_mode)
>  {
>  	return (platform_mode && hibernation_ops) ?
> @@ -126,10 +123,8 @@ static int platform_begin(int platform_m
>  }
>  
>  /**
> - *	platform_end - tell the platform driver that we've entered the
> - *	working state
> + * platform_end - Use platform driver to finish transition to the working state.

 * @platform_mode: <description>

>   */
> -
>  static void platform_end(int platform_mode)
>  {
>  	if (platform_mode && hibernation_ops)
> @@ -137,8 +132,10 @@ static void platform_end(int platform_mo
>  }
>  
>  /**
> - *	platform_pre_snapshot - prepare the machine for hibernation using the
> - *	platform driver if so configured and return an error code if it fails
> + * platform_pre_snapshot - Call platform to prepare the machine for hibernation.

 * @platform_mode: <description>

> + *
> + * Use the platform driver to prepare the system for creating a hibernate image,
> + * if so configured, and return an error code if that fails.
>   */
>  
>  static int platform_pre_snapshot(int platform_mode)
> @@ -148,10 +145,13 @@ static int platform_pre_snapshot(int pla
>  }
>  
>  /**
> - *	platform_leave - prepare the machine for switching to the normal mode
> - *	of operation using the platform driver (called with interrupts disabled)
> + * platform_leave - Use platform to prepare a transition to the working state.

 * @platform_mode: <description>

> + *
> + * Use the platform driver prepare to prepare the machine for switching to the
> + * normal mode of operation.
> + *
> + * This routine is called on one CPU with interrupts disabled.
>   */
> -
>  static void platform_leave(int platform_mode)
>  {
>  	if (platform_mode && hibernation_ops)
> @@ -159,10 +159,13 @@ static void platform_leave(int platform_
>  }
>  
>  /**
> - *	platform_finish - switch the machine to the normal mode of operation
> - *	using the platform driver (must be called after platform_prepare())
> + * platform_finish - Use platform to switch the system to the working state.

 * @platform_mode: <description>

> + *
> + * Use the platform driver to switch the machine to the normal mode of
> + * operation.
> + *
> + * This routine must be called after platform_prepare().
>   */
> -
>  static void platform_finish(int platform_mode)
>  {
>  	if (platform_mode && hibernation_ops)
> @@ -170,11 +173,14 @@ static void platform_finish(int platform
>  }
>  
>  /**
> - *	platform_pre_restore - prepare the platform for the restoration from a
> - *	hibernation image.  If the restore fails after this function has been
> - *	called, platform_restore_cleanup() must be called.
> + * platform_pre_restore - Prepare for hibernate image restoration.

 * @platform_mode: <description>

> + *
> + * Use the platform driver to prepare the system for resume from a hibernation
> + * image.
> + *
> + * If the restore fails after this function has been called,
> + * platform_restore_cleanup() must be called.
>   */
> -
>  static int platform_pre_restore(int platform_mode)
>  {
>  	return (platform_mode && hibernation_ops) ?
> @@ -182,12 +188,15 @@ static int platform_pre_restore(int plat
>  }
>  
>  /**
> - *	platform_restore_cleanup - switch the platform to the normal mode of
> - *	operation after a failing restore.  If platform_pre_restore() has been
> - *	called before the failing restore, this function must be called too,
> - *	regardless of the result of platform_pre_restore().
> + * platform_restore_cleanup - Switch to the working state after failing restore.

 * @platform_mode: <description>

> + *
> + * Use the platform driver to switch the system to the normal mode of operation
> + * after a failing restore.
> + *
> + * If platform_pre_restore() has been called before the failing restore, this
> + * function must be called too, regardless of the result of
> + * platform_pre_restore().
>   */
> -
>  static void platform_restore_cleanup(int platform_mode)
>  {
>  	if (platform_mode && hibernation_ops)
> @@ -195,10 +204,8 @@ static void platform_restore_cleanup(int
>  }
>  
>  /**
> - *	platform_recover - recover the platform from a failure to suspend
> - *	devices.
> + * platform_recover - Recover the platform from a failure to suspend devices.

 * @platform_mode: <description>

>   */
> -
>  static void platform_recover(int platform_mode)
>  {
>  	if (platform_mode && hibernation_ops && hibernation_ops->recover)
> @@ -206,13 +213,12 @@ static void platform_recover(int platfor
>  }
>  
>  /**
> - *	swsusp_show_speed - print the time elapsed between two events.
> - *	@start: Starting event.
> - *	@stop: Final event.
> - *	@nr_pages -	number of pages processed between @start and @stop
> - *	@msg -		introductory message to print
> + * swsusp_show_speed - Print time elapsed between two events during hibernation.
> + * @start: Starting event.
> + * @stop: Final event.
> + * @nr_pages: Number of memory pages processed between @start and @stop.
> + * @msg: Additional diagnostic message to print.
>   */
> -
>  void swsusp_show_speed(struct timeval *start, struct timeval *stop,
>  			unsigned nr_pages, char *msg)
>  {
> @@ -235,11 +241,13 @@ void swsusp_show_speed(struct timeval *s
>  }
>  
>  /**
> - *	create_image - freeze devices that need to be frozen with interrupts
> - *	off, create the hibernation image and thaw those devices.  Control
> - *	reappears in this routine after a restore.
> + * create_image - Create a hibernation image.

 * @platform_mode: <description>

> + *
> + * Execute device drivers' .freeze_noirq() callbacks, create a hibernation image
> + * and execute the drivers' .thaw_noirq() callbacks.
> + *
> + * Control reappears in this routine after the subsequent restore.
>   */
> -
>  static int create_image(int platform_mode)
>  {
>  	int error;
> @@ -304,14 +312,11 @@ static int create_image(int platform_mod
>  }
>  
>  /**
> - *	hibernation_snapshot - quiesce devices and create the hibernation
> - *	snapshot image.
> - *	@platform_mode - if set, use the platform driver, if available, to
> - *			 prepare the platform firmware for the power transition.
> + * hibernation_snapshot - Quiesce devices and create a hibernation image.
> + * @platform_mode: If set, use platform driver to prepare for the transition.
>   *
> - *	Must be called with pm_mutex held
> + * This routine must be called with pm_mutex held.
>   */
> -
>  int hibernation_snapshot(int platform_mode)
>  {
>  	pm_message_t msg = PMSG_RECOVER;
> @@ -371,13 +376,13 @@ int hibernation_snapshot(int platform_mo
>  }
>  
>  /**
> - *	resume_target_kernel - prepare devices that need to be suspended with
> - *	interrupts off, restore the contents of highmem that have not been
> - *	restored yet from the image and run the low level code that will restore
> - *	the remaining contents of memory and switch to the just restored target
> - *	kernel.
> + * resume_target_kernel - Restore system state from a hibernation image.

 * @platform_mode: <description>

> + *
> + * Execute device drivers' .freeze_noirq() callbacks, restore the contents of
> + * highmem that have not been restored yet from the image and run the low-level
> + * code that will restore the remaining contents of memory and switch to the
> + * just restored target kernel.
>   */
> -
>  static int resume_target_kernel(bool platform_mode)
>  {
>  	int error;
> @@ -445,14 +450,12 @@ static int resume_target_kernel(bool pla
>  }
>  
>  /**
> - *	hibernation_restore - quiesce devices and restore the hibernation
> - *	snapshot image.  If successful, control returns in hibernation_snaphot()
> - *	@platform_mode - if set, use the platform driver, if available, to
> - *			 prepare the platform firmware for the transition.
> + * hibernation_restore - Quiesce devices and restore from a hibernation image.
> + * @platform_mode: If set, use platform driver to prepare for the transition.
>   *
> - *	Must be called with pm_mutex held
> + * This routine must be called with pm_mutex held.  If it is successful, control
> + * reappears in the restored target kernel in hibernation_snaphot().
>   */
> -
>  int hibernation_restore(int platform_mode)
>  {
>  	int error;
> @@ -472,10 +475,8 @@ int hibernation_restore(int platform_mod
>  }
>  
>  /**
> - *	hibernation_platform_enter - enter the hibernation state using the
> - *	platform driver (if available)
> + * hibernation_platform_enter - Power off the system using the platform driver.
>   */
> -
>  int hibernation_platform_enter(void)
>  {
>  	int error;
> @@ -546,12 +547,12 @@ int hibernation_platform_enter(void)
>  }
>  
>  /**
> - *	power_down - Shut the machine down for hibernation.
> + * power_down - Shut the machine down for hibernation.
>   *
> - *	Use the platform driver, if configured so; otherwise try
> - *	to power off or reboot.
> + * Use the platform driver, if configured, to put the system into the sleep
> + * state corresponding to hibernation, or try to power it off or reboot,
> + * depending on the value of hibernation_mode.
>   */
> -
>  static void power_down(void)
>  {
>  	switch (hibernation_mode) {
> @@ -588,9 +589,8 @@ static int prepare_processes(void)
>  }
>  
>  /**
> - *	hibernate - The granpappy of the built-in hibernation management
> + * hibernate - Carry out system hibernation, including saving the image.
>   */
> -
>  int hibernate(void)
>  {
>  	int error;
> @@ -668,17 +668,20 @@ int hibernate(void)
>  
>  
>  /**
> - *	software_resume - Resume from a saved image.
> + * software_resume - Resume from a saved hibernation image.
> + *
> + * This routine is called as a late initcall, when all devices have been
> + * discovered and initialized already.
>   *
> - *	Called as a late_initcall (so all devices are discovered and
> - *	initialized), we call swsusp to see if we have a saved image or not.
> - *	If so, we quiesce devices, the restore the saved image. We will
> - *	return above (in hibernate() ) if everything goes well.
> - *	Otherwise, we fail gracefully and return to the normally
> - *	scheduled program.
> + * The image reading code is called to see if there is a hibernation image
> + * available for reading.  If that is the case, devices are quiesced and the
> + * contents of memory is restored from the saved image.
>   *
> + * If this is successful, control reappears in the restored target kernel in
> + * hibernation_snaphot() which returns to hibernate().  Otherwise, the routine
> + * attempts to recover gracefully and make the kernel return to the normal mode
> + * of operation.
>   */
> -
>  static int software_resume(void)
>  {
>  	int error;
> @@ -808,21 +811,17 @@ static const char * const hibernation_mo
>  	[HIBERNATION_TESTPROC]	= "testproc",
>  };
>  
> -/**
> - *	disk - Control hibernation mode
> +/*
> + * /sys/power/disk - Control hibernation mode.
>   *
> - *	Suspend-to-disk can be handled in several ways. We have a few options
> - *	for putting the system to sleep - using the platform driver (e.g. ACPI
> - *	or other hibernation_ops), powering off the system or rebooting the
> - *	system (for testing) as well as the two test modes.
> - *
> - *	The system can support 'platform', and that is known a priori (and
> - *	encoded by the presence of hibernation_ops). However, the user may
> - *	choose 'shutdown' or 'reboot' as alternatives, as well as one fo the
> - *	test modes, 'test' or 'testproc'.
> + * Hibernation can be handled in several ways.  There are a few different ways
> + * to put the system into the sleep state: using the platform driver (e.g. ACPI
> + * or other hibernation_ops), powering it off or rebooting it (for testing
> + * mostly), or using one of the two available test modes.
>   *
> - *	show() will display what the mode is currently set to.
> - *	store() will accept one of
> + * The sysfs file /sys/power/disk provides an interface for selecting the
> + * hibernation mode to use.  Reading from this file causes the available modes
> + * to be printed.  There are 5 modes that can be supported:
>   *
>   *	'platform'
>   *	'shutdown'
> @@ -830,8 +829,14 @@ static const char * const hibernation_mo
>   *	'test'
>   *	'testproc'
>   *
> - *	It will only change to 'platform' if the system
> - *	supports it (as determined by having hibernation_ops).
> + * If a platform hibernation driver is in use, 'platform' will be supported
> + * and will be used by default.  Otherwise, 'shutdown' will be used by default.
> + * The selected option (i.e. the one corresponding to the current value of
> + * hibernation_mode) is enclosed by a square bracket.
> + *
> + * To select a given hibernation mode it is necessary to write the mode's
> + * string representation (as returned by reading from /sys/power/disk) back
> + * into /sys/power/disk.
>   */
>  
>  static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
> @@ -864,7 +869,6 @@ static ssize_t disk_show(struct kobject
>  	return buf-start;
>  }
>  
> -
>  static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			  const char *buf, size_t n)
>  {
> 


Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
