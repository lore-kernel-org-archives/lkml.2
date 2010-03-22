Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0CVVsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:48:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab0CVVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:48:13 -0400
Date: Mon, 22 Mar 2010 14:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] add CPU notifier error injection module
Message-Id: <20100322144809.4d54bc7e.akpm@linux-foundation.org>
In-Reply-To: <1268903124-10237-12-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
	<1268903124-10237-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 18:05:24 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> I used this module to test the series of modification to the
> cpu notifiers code.
> 
> Example1: inject CPU offline error (-1 == -EPERM)
> 
> 	# modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
> 	# echo 0 > /sys/devices/system/cpu/cpu1/online0
> 	bash: echo: write error: Operation not permitted
> 
> Example2: inject CPU online error (-2 == -ENOENT)
> 
> 	# modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
> 	# echo 1 > /sys/devices/system/cpu/cpu1/online0
> 	bash: echo: write error: No such file or directory
> 
> ...
>
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -885,6 +885,18 @@ config LKDTM
>  	Documentation on how to use the module can be found in
>  	Documentation/fault-injection/provoke-crashes.txt
>  
> +config CPU_NOTIFIER_ERROR_INJECT
> +	tristate "CPU notifier error injection module"
> +	depends on HOTPLUG_CPU && DEBUG_KERNEL
> +	help
> +	  This option provides a kernel module that can be used to test
> +	  the error handling of the cpu notifiers
> +
> +	  To compile this code as a module, choose M here: the module will
> +	  be called cpu-notify-inject.

Should be "cpu-notifier-error-inject", yes?

> +	  If unsure, say N.
> +
>  config FAULT_INJECTION
>  	bool "Fault-injection framework"
>  	depends on DEBUG_KERNEL

