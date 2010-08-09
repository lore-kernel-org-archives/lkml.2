Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0HIJKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:10:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:53613 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0HIJKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:10:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: how to transplant a driver from 2.4 to 2.6?
Date: Mon, 9 Aug 2010 09:28:01 +0100
Message-ID: <hpq4j7-0tp.ln1@chipmunk.wormnet.eu>
References: <201008091603464245121@gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hacklu <embedway.linux@gmail.com> wrote:
>
> I have a driver project programmed under the 2.4 kernel.
> but now ,I want to transplant it to 2.6.
> the driver has some directions;
> like 1/1.c  2/2.c  3/3_1.c 3_2.c
> in this case ,how can I imtate the   template Makefile   of 2.6's driver
> 
I use the following 2.6 Makefile template for an out of kernel drive I 
am forced to use:
----
alex@berk:~$ cat /usr/src/wag54g/sangam-atm/Makefile 
ifneq ($(KERNELRELEASE),)
include Kbuild
else
        KERNELDIR      := /usr/src/wag54g/linux/
all::
        $(MAKE) -C $(KERNELDIR) M=`pwd` tiatm.ko
endif
alex@berk:~$ cat /usr/src/wag54g/sangam-atm/Kbuild 
obj-m                   := tiatm.o
tiatm-y                 := cpsar.o aal5sar.o tn7sar.o tn7atm.o tn7dsl.o dsl_hal_api.o dsl_hal_support.o dsl_hal_advcfg.o

ccflags-y               += -I$(PWD) -DPOST_SILICON -DCOMMON_NSP -D__NO__VOICE_PATCH__ -DEL -DCPATM_TASKLET_MODE
#ccflags-$(DEBUG)       += -D....
---- 

It's not great, but it works.

Cheers

-- 
Alexander Clouter
.sigmonster says: Never eat more than you can lift.
                  		-- Miss Piggy

