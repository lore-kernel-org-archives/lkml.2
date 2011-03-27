Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1C0RoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 13:44:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1C0RoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 13:44:12 -0400
Date: Sun, 27 Mar 2011 10:43:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] initcall: add config option for compiling
 initcall_debug
Message-Id: <20110327104332.6703de4c.randy.dunlap@oracle.com>
In-Reply-To: <20110327115506.14008.17733.stgit@localhost6>
References: <20110327115506.14008.17733.stgit@localhost6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D8F7749.0001,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011 15:55:06 +0400 Konstantin Khlebnikov wrote:

> Add bool config option CONFIG_INITCALL_DEBUG for compiling initcalls debuging,
> make it on by default to keep current behaviour.

Typo fixes only:


> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  Documentation/kernel-parameters.txt |    2 +-
>  include/linux/init.h                |    4 ++++
>  init/main.c                         |    2 ++
>  kernel/async.c                      |    4 +---
>  lib/Kconfig.debug                   |    7 +++++++
>  5 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c357a31..ea3843a 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -970,7 +970,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
>  			for working out where the kernel is dying during
> -			startup.
> +			startup. This depend on CONFIG_INITCALL_DEBUG option.

			              depends on the CONFIG_INITCALL_DEBUG option.

>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk


> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index df9234c..ebc1357 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -807,6 +807,13 @@ config DEBUG_CREDENTIALS
>  
>  	  If unsure, say N.
>  
> +config INITCALL_DEBUG
> +	bool "Debug kernel initcalls"
> +	default y
> +	help
> +	  This build option allow you trace initcalls after

	                    allows you to trace initcalls by

> +	  adding "initcall_debug" to kernel command line.

	                          to the kernel command line.

> +
>  #
>  # Select this config option from the architecture Kconfig, if it
>  # it is preferred to always offer frame pointers as a config


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
