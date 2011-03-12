Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1CLNGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 08:06:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1CLNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 08:06:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ni8K7+9tdQoRyVqZcSyQsxe5YzdQDJZj/Gz64bH/CtU9+b+9rZKfb7LvvwwjVGWccI
         LyBiGiV7JfxPgClfCv8hgvRZpsvSiIgPPJQtlmmEmI9vzTX9ZcFGvVhapHUNaiaPsuCq
         6HH78PdE67+NbToPQxezNbtwtFAbjNfUxgs1s=
MIME-Version: 1.0
Date: Sat, 12 Mar 2011 18:36:01 +0530
Message-ID: <AANLkTimU64tZ-ABAyhDTtzC1La2vGuk+fcGftguFrYLD@mail.gmail.com>
Subject: error: #error Unknown data abort handler type from glue.h file
From: Madhavi Manchala <madhavi.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

When I looked into the linux-2.6.36/arch/arm directory, I did not find
the mach-s3c2510/s3c2510a directory for Samsung s3c2510a MCU. When I
asked the same in the ARM forum, they told me that this MCU is a
NO-MMU based MCU and in the current kernel there was no much support
for it. For complete details, please look at the following link.
http://comments.gmane.org/gmane.linux.ports.arm.kernel/108351

So, I started developing the architecture files for my MCU i.e.
Samsung S3C2510A. However, when I am trying to build the kernel after
adding the support for S3C2510A processor, I am getting the following
error.

 CC      init/main.o
In file included from
/home/madhavi/linux-2.6.36/arch/arm/include/asm/cacheflush.h:15:0,
                from include/linux/highmem.h:9,
                from include/linux/pagemap.h:10,
                from include/linux/mempolicy.h:70,
                from init/main.c:50:
/home/madhavi/linux-2.6.36/arch/arm/include/asm/glue.h:119:2: error:
#error Unknown data abort handler type
make[6]: *** [init/main.o] Error 1
make[5]: *** [init] Error 2
make[5]: Leaving directory `/home/madhavi/linux-2.6.36'
make[4]: *** [/home/madhavi/linux-2.6.36/.image] Error 2

When I looked into the sources of the /arch/arm/include/asm/glue.h
file, none of the macro defines the CPU_DABORT_HANDLER. From the
arch/arm/Makefile the abort handler for no-mmu based CPUs is as
follows.

obj-$(CONFIG_CPU_ABRT_NOMMU)    += abort-nommu.o

In my case, the CONFIG_CPU_ABRT_NOMMU is defined in .config file to y.
My question is, why again it is trying to check the abort handler from
glue.h file? Shall I add a new macro in the glue.h file for defining
the CPU_DABORT_HANDLER based on this new MCU (Samsung S3C2510A)?

OR

Is there any sources / links which supports the architecture of the
Samasung S3C2510A MCU under any Linux kernel version?

Any ideas / hits would be appreciated.

Thanks for your help.

Regards,
Madhavi M.
