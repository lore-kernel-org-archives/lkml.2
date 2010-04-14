Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0DNPZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:25:21 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:40153 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0DNPZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:25:20 -0400
Message-ID: <4BC5DE54.2010305@monstr.eu>
Date: Wed, 14 Apr 2010 17:25:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] microblaze: allow developer selection of STACKTRACE
References: <1271220938-3526-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1271220938-3526-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Allow the developer to configure STACKTRACE to enable userland access to backtraces in /proc/NN/stack.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> --- a/arch/microblaze/Kconfig	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/Kconfig	2010-04-12 22:16:01.000000000 -0500
> @@ -136,6 +136,14 @@ config PROC_DEVICETREE
>  	  an image of the device tree that the kernel copies from Open
>  	  Firmware or other boot firmware. If unsure, say Y here.
>  
> +config PROC_BACKTRACE
> +	bool "Support for kernel backtraces in /proc/NN/stack"
> +	default n
> +	select STACKTRACE
> +	help
> +	  This option adds a backtrace of the kernel stack to /proc/NN/stack.
> +	  If unsure, say N here.
> +

Why did you create new Kconfig option? /proc/NN/stack is there when you 
enable stacktrace support. There is not necessary to enable any new option.

Or is there any other point which I am missing?

Thanks,
Michal


>  endmenu
>  
>  menu "Advanced setup"
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
