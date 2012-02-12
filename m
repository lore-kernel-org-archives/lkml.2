Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2BLOtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:49:47 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42309 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2BLOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:49:44 -0500
Message-ID: <4F37D176.7080807@linux.vnet.ibm.com>
Date: Sun, 12 Feb 2012 20:19:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] PM / Sleep: Unify kerneldoc comments in kernel/power/suspend.c
References: <201202120003.20879.rjw@sisk.pl> <201202120004.07605.rjw@sisk.pl>
In-Reply-To: <201202120004.07605.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021204-1396-0000-0000-000000A9BFD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 04:34 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The kerneldoc comments in kernel/power/suspend.c are not formatted
> in the same way and the quality of some of them is questionable.
> Unify the formatting and improve the contents.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  kernel/power/suspend.c |   56 +++++++++++++++++++++++--------------------------
>  1 file changed, 27 insertions(+), 29 deletions(-)
> 
> Index: linux/kernel/power/suspend.c
> ===================================================================
> --- linux.orig/kernel/power/suspend.c
> +++ linux/kernel/power/suspend.c
> @@ -37,8 +37,8 @@ const char *const pm_states[PM_SUSPEND_M
>  static const struct platform_suspend_ops *suspend_ops;
> 
>  /**
> - *	suspend_set_ops - Set the global suspend method table.
> - *	@ops:	Pointer to ops structure.
> + * suspend_set_ops - Set the global suspend method table.
> + * @ops: Suspend operations to use.
>   */
>  void suspend_set_ops(const struct platform_suspend_ops *ops)
>  {
> @@ -58,11 +58,11 @@ bool valid_state(suspend_state_t state)
>  }
> 
>  /**
> - * suspend_valid_only_mem - generic memory-only valid callback
> + * suspend_valid_only_mem - Generic memory-only valid callback.
>   *
> - * Platform drivers that implement mem suspend only and only need
> - * to check for that in their .valid callback can use this instead
> - * of rolling their own .valid callback.
> + * Platform drivers that implement mem suspend only and only need to check for
> + * that in their .valid() callback can use this instead of rolling their own
> + * .valid() callback.
>   */
>  int suspend_valid_only_mem(suspend_state_t state)
>  {
> @@ -83,10 +83,11 @@ static int suspend_test(int level)
>  }
> 
>  /**
> - *	suspend_prepare - Do prep work before entering low-power state.
> + * suspend_prepare - Prepare for entering system sleep state.
>   *
> - *	This is common code that is called for each state that we're entering.
> - *	Run suspend notifiers, allocate a console and stop all processes.
> + * Common code run for every system sleep state that can be entered (except for
> + * hibernation).  Run suspend notifiers, allocate the "suspend" console and
> + * freeze processes.
>   */
>  static int suspend_prepare(void)
>  {
> @@ -131,9 +132,9 @@ void __attribute__ ((weak)) arch_suspend
>  }
> 
>  /**
> - * suspend_enter - enter the desired system sleep state.
> - * @state: State to enter
> - * @wakeup: Returns information that suspend should not be entered again.
> + * suspend_enter - Make the system enter the given sleep state.
> + * @state: System sleep state to enter.
> + * @wakeup: Returns information that the sleep state should not be re-entered.
>   *
>   * This function should be called after devices have been suspended.
>   */
> @@ -199,9 +200,8 @@ static int suspend_enter(suspend_state_t
>  }
> 
>  /**
> - *	suspend_devices_and_enter - suspend devices and enter the desired system
> - *				    sleep state.
> - *	@state:		  state to enter
> + * suspend_devices_and_enter - Suspend devices and enter system sleep state.
> + * @state: System sleep state to enter.
>   */
>  int suspend_devices_and_enter(suspend_state_t state)
>  {
> @@ -251,10 +251,10 @@ int suspend_devices_and_enter(suspend_st
>  }
> 
>  /**
> - *	suspend_finish - Do final work before exiting suspend sequence.
> + * suspend_finish - Clean up before finishing the suspend sequence.
>   *
> - *	Call platform code to clean up, restart processes, and free the
> - *	console that we've allocated. This is not called for suspend-to-disk.
> + * Call platform code to clean up, restart processes, and free the console that
> + * we've allocated. This routine is not called for hibernation.
>   */
>  static void suspend_finish(void)
>  {
> @@ -265,14 +265,12 @@ static void suspend_finish(void)
>  }
> 
>  /**
> - *	enter_state - Do common work of entering low-power state.
> - *	@state:		pm_state structure for state we're entering.
> + * enter_state - Do common work needed to enter system sleep state.
> + * @state: System sleep state to enter.
>   *
> - *	Make sure we're the only ones trying to enter a sleep state. Fail
> - *	if someone has beat us to it, since we don't want anything weird to
> - *	happen when we wake up.
> - *	Then, do the setup for suspend, enter the state, and cleaup (after
> - *	we've woken up).
> + * Make sure that no one else is trying to put the system into a sleep state.
> + * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
> + * system enter the given sleep state and clean up after wakeup.
>   */
>  int enter_state(suspend_state_t state)
>  {
> @@ -310,11 +308,11 @@ int enter_state(suspend_state_t state)
>  }
> 
>  /**
> - *	pm_suspend - Externally visible function for suspending system.
> - *	@state:		Enumerated value of state to enter.
> + * pm_suspend - Externally visible function for suspending the system.
> + * @state: System sleep state to enter.
>   *
> - *	Determine whether or not value is within range, get state
> - *	structure, and enter (above).
> + * Check if the value of @state represents one of the supported states,
> + * execute enter_state() and update system suspend statistics.
>   */
>  int pm_suspend(suspend_state_t state)
>  {
> 

