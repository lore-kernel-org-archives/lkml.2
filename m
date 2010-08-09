Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0HIIDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:03:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52028 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0HIIDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=v1INXHbCJcysI+ZDgT9DzxKZlbiS9SUV8ShOrbEdbQZcEeV/t3d6BuCE4rQX/JB0C+
         qiFrZHCHrC2KzUwzWwPhDJRc6/LS3pLB6uXkbk7q76ht2wuovqGfX6XMI+luuMYKLuG1
         ymBQJb8W59k2Cph04k6cmRpZhuT3ITWgroz8k=
Date: Mon, 9 Aug 2010 16:03:50 +0800
From: "hacklu" <embedway.linux@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: how to transplant a driver from 2.4 to 2.6?
Message-ID: <201008091603464245121@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I have a driver project programmed under the 2.4 kernel.
but now ,I want to transplant it to 2.6.
the driver has some directions;
like 1/1.c  2/2.c  3/3_1.c 3_2.c
in this case ,how can I imtate the   template Makefile   of 2.6's driver

I only kown this:
------------------------------------------
ifneq ($(KERNELRELEASE),)
# call from kernel build system
scull-objs := demo1.o demo2.o
obj-m := demo.o

else
CROSS_COMPILE ?=powerpc
KERNELLIBDIR=/lib
KERNELDIR ?= /linux-2.6.25_minifo
PWD       := $(shell pwd)

all:
        $(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=powerpc -C $(KERNELDIR) M=$(PWD) modules
clean:
        rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions
endif
depend .depend dep:
        $(CC) $(CFLAGS) -M *.c > .depend
 ifeq (.depend,$(wildcard .depend))
include .depend
endif
 -----------------------------------------


thanks so much
 				
--------------
hacklu
2010-08-09

