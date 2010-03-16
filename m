Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937560Ab0CPJEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:04:14 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37417 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0CPJEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:04:12 -0400
Message-ID: <4B9F4988.20809@monstr.eu>
Date: Tue, 16 Mar 2010 10:04:08 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arun Bhanu <arun@bhanu.net>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org
Subject: Re: [PATCH v2] microblaze: Fix Makefile to delete build generated
 files
References: <1268727395-7770-1-git-send-email-arun@bhanu.net>
In-Reply-To: <1268727395-7770-1-git-send-email-arun@bhanu.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Bhanu wrote:
> 'make clean' does not to delete the following build generated file:
> 	arch/microblaze/boot/linux.bin.ub
> 
> 'make mrproper' does not to delete the following build generated files:
> 	arch/microblaze/boot/simpleImage.*
> 
> Fix the Makefile to delete these build generated files.
> 
> See [1] for a discussion on why simpleImage.* files are deleted with 'make
> mrproper' and not with 'make clean'.
> 	[1] http://lkml.org/lkml/2010/3/12/96
> 
> Signed-off-by: Arun Bhanu <arun@bhanu.net>
> ---
>  arch/microblaze/Makefile      |    2 ++
>  arch/microblaze/boot/Makefile |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
> index d2d6cfc..36926b9 100644
> --- a/arch/microblaze/Makefile
> +++ b/arch/microblaze/Makefile
> @@ -93,3 +93,5 @@ define archhelp
>    echo '  name of a dts file from the arch/microblaze/boot/dts/ directory'
>    echo '  (minus the .dts extension).'
>  endef
> +
> +MRPROPER_FILES += $(boot)/simpleImage.*

I personally don't like that this line is in main arch Makefile but I 
saw that other archs have it too. Will be better to have it only in boot 
folder but I don't know if is possible to do that.
Sam: What do you think?


> diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
> index 902cf98..a1fc324 100644
> --- a/arch/microblaze/boot/Makefile
> +++ b/arch/microblaze/boot/Makefile
> @@ -64,4 +64,4 @@ $(obj)/%.dtb: $(dtstree)/%.dts FORCE
>  
>  clean-kernel += linux.bin linux.bin.gz simpleImage.*
>  
> -clean-files += *.dtb simpleImage.*.unstrip
> +clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub

Could you please take a look at clean-kernel option too?
I think we can simple remove it. It should be any ancient code from powerpc.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
