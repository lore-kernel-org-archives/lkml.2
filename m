Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0DOWfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 18:35:17 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24860 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0DOWfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 18:35:06 -0400
Date: Thu, 15 Apr 2010 15:32:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-Id: <20100415153251.590c91ca.randy.dunlap@oracle.com>
In-Reply-To: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC7947D.002B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 17:25:10 -0400 Don Zickus wrote:

>  arch/x86/kernel/apic/hw_nmi.c |    2 +-
>  include/linux/sched.h         |    6 +
>  init/Kconfig                  |    1 +
>  kernel/Makefile               |    4 +-
>  kernel/sysctl.c               |    9 +
>  kernel/watchdog.c             |  570 +++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug             |   21 +-
>  7 files changed, 605 insertions(+), 8 deletions(-)
>  create mode 100644 kernel/watchdog.c

Updates to Documentation/kernel-parameters.txt ??


> +static int __init no_watchdog_setup(char *str)
> +{
> +	no_watchdog = 1;
> +	return 1;
> +}
> +__setup("no_watchdog", no_watchdog_setup);

New, please document.

> +/* deprecated */
> +static int __init nosoftlockup_setup(char *str)
> +{
> +	no_watchdog = 1;
> +	return 1;
> +}

That's not marked as deprecated anywhere?

> +__setup("nosoftlockup", nosoftlockup_setup);
> +static int __init nonmi_watchdog_setup(char *str)
> +{
> +	no_watchdog = 1;
> +	return 1;
> +}
> +__setup("nonmi_watchdog", nonmi_watchdog_setup);

New, please document.


> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index e2e73cc..280794a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -171,15 +171,24 @@ config DETECT_SOFTLOCKUP
>  	   support it.)
>  
>  config NMI_WATCHDOG
> -	bool "Detect Hard Lockups with an NMI Watchdog"
> -	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
> +	bool "Detect Hard and Soft Lockups"
> +	depends on DEBUG_KERNEL
> +	default DETECT_SOFTLOCKUP
>  	help
>  	  Say Y here to enable the kernel to use the NMI as a watchdog
> -	  to detect hard lockups.  This is useful when a cpu hangs for no

	                                  preferably:    CPU

> -	  reason but can still respond to NMIs.  A backtrace is displayed
> -	  for reviewing and reporting.
> +	  to detect hard and soft lockups.
> +
> +	  Softlockups are bugs that cause the kernel to loop in kernel
> +	  mode for more than 60 seconds, without giving other tasks a
> +	  chance to run.  The current stack trace is displayed upon
> +	  detection and the system will stay locked up.
> +
> +	  Hardlockups are bugs that cause the cpu to loop in kernel mode

ditto

> +	  for more than 60 seconds, without letting other interrupts a

	                                                             have a

> +	  chance to run.  The current stack trace is displayed upon detection
> +	  and the system will stay locked up.
>  
> -	  The overhead should be minimal, just an extra NMI every few
> +	  The overhead should me minimal, just an extra NMI every few

	                      be

>  	  seconds.
>  
>  config BOOTPARAM_SOFTLOCKUP_PANIC


---
~Randy
