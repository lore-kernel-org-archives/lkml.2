Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1EPSb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:31:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1EPSb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:31:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Remove CONFIG_PM_VERBOSE
Date: Mon, 16 May 2011 20:32:33 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201105140042.04064.rjw@sisk.pl>
In-Reply-To: <201105140042.04064.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105162032.33480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 14, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Now that we have CONFIG_DYNAMIC_DEBUG there is no need for yet
> another flag causing dev_dbg() and pr_debug() statements in the
> core PM code to produce output.  Moreover, CONFIG_PM_VERBOSE
> causes so much output to be generated that it's not really useful
> and almost no one sets it.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=23182
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

There are no comments, so my understanding is that no one has any objections to
this patch.  If that really is the case, I'm going to put it into
suspend-2.6/linux-next for 2.6.40.

Thanks,
Rafael


> ---
>  arch/sh/configs/apsh4ad0a_defconfig |    1 -
>  arch/sh/configs/sdk7786_defconfig   |    1 -
>  drivers/base/power/Makefile         |    3 +--
>  kernel/power/Kconfig                |    6 ------
>  4 files changed, 1 insertion(+), 10 deletions(-)
> 
> Index: linux-2.6/arch/sh/configs/apsh4ad0a_defconfig
> ===================================================================
> --- linux-2.6.orig/arch/sh/configs/apsh4ad0a_defconfig
> +++ linux-2.6/arch/sh/configs/apsh4ad0a_defconfig
> @@ -48,7 +48,6 @@ CONFIG_PREEMPT=y
>  CONFIG_BINFMT_MISC=y
>  CONFIG_PM=y
>  CONFIG_PM_DEBUG=y
> -CONFIG_PM_VERBOSE=y
>  CONFIG_PM_RUNTIME=y
>  CONFIG_CPU_IDLE=y
>  CONFIG_NET=y
> Index: linux-2.6/arch/sh/configs/sdk7786_defconfig
> ===================================================================
> --- linux-2.6.orig/arch/sh/configs/sdk7786_defconfig
> +++ linux-2.6/arch/sh/configs/sdk7786_defconfig
> @@ -83,7 +83,6 @@ CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
>  CONFIG_BINFMT_MISC=y
>  CONFIG_PM=y
>  CONFIG_PM_DEBUG=y
> -CONFIG_PM_VERBOSE=y
>  CONFIG_PM_RUNTIME=y
>  CONFIG_CPU_IDLE=y
>  CONFIG_NET=y
> Index: linux-2.6/drivers/base/power/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/Makefile
> +++ linux-2.6/drivers/base/power/Makefile
> @@ -5,5 +5,4 @@ obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
>  obj-$(CONFIG_PM_OPP)	+= opp.o
>  obj-$(CONFIG_HAVE_CLK)	+= clock_ops.o
>  
> -ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
> -ccflags-$(CONFIG_PM_VERBOSE)   += -DDEBUG
> +ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
> \ No newline at end of file
> Index: linux-2.6/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/power/Kconfig
> +++ linux-2.6/kernel/power/Kconfig
> @@ -125,12 +125,6 @@ config PM_DEBUG
>  	code. This is helpful when debugging and reporting PM bugs, like
>  	suspend support.
>  
> -config PM_VERBOSE
> -	bool "Verbose Power Management debugging"
> -	depends on PM_DEBUG
> -	---help---
> -	This option enables verbose messages from the Power Management code.
> -
>  config PM_ADVANCED_DEBUG
>  	bool "Extra PM attributes in sysfs for low-level debugging/testing"
>  	depends on PM_DEBUG
> --
