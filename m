Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2DEIUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:20:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64062 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab2DEIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:20:27 -0400
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 16:20:25 +0800
Message-ID: <CAD+1EGNGM4edMEJUgZTKtQ00BBXgBimUhgQBkpc=6wi=ciBn2A@mail.gmail.com>
Subject: [RFC]Module problem
From: harryxiyou <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

When i write an easy module for testing, it happens to me a problem, which
is like this "Building modules, stage 2.  MODPOST 0 modules". I can not
find the *.ko file.

My Module file is like this:

hello.c

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

static int __init hello_init(void) {
printk("<1> Hello World\n");
return 0;  }

static void __exit hello_exit(void) {
printk("<1> Goodbey\n");
return ;  }

MODULE_LICENSE("GPL");
module_init(hello_init);
module_exit(hello_exit);

Makefile is like this:

obj-m += hello.o

all:
                make -C /usr/src/linux-headers-3.0.0-12-generic
M=/home/sel/homeworl modules

clean:
               make -C /usr/src/linux-headers-3.0.0-12-generic
M=/home/sel/homeworl clean


   When i compile my modules as up Makefile, i cannot get my hello.ko
file. However, when
i change the Makefile like following it is ok for me.

obj-m :=hello.o
ifneq ($( KERNELRELEASE),)

else

KERNELDIR ?= /lib/modules/$(shell uname -r)/build

PWD :=$(shell pwd)
default:

             $(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif

     I cannot understand this well Makefile clearly. Cloud anyone give
me a help ;-)

My kernel version is 2.6. Ubuntu 10.04. x86 32bits.

-- 
Thanks
Harry Wei
