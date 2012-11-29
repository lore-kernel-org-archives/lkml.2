Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961Ab2K2AEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:04:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41764 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1945946Ab2K2AEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:04:47 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18saWFv4EAstc1jDaq9bRYOkvaYUm6zHy317Mgfmc
	MlfD7R3w3ol286
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Date: Thu, 29 Nov 2012 01:04:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.7; KDE/4.8.5; x86_64; ; )
Cc: Kent Yoder <shpedoikal@gmail.com>, Kent Yoder <key@linux.vnet.ibm.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Sirrix@jasper.es
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com> <35286B1AE75A7C47 <35286B1AE75A7C47BFF0870081A31B4B3A9B501757@SAFEX1MAIL4.st.com>
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B3A9B501757@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211290104.53049.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

please note: 
I'm writing this email on behalf of myself only and nobody else, especially not my employer - and I'm doing this in my spare time.
I'm working for a direct competitor of yours, but I'm not using any knowledge that I've picked up at work or that is considered secret in any way.
I have a personal interest in the TPM subsystem and want to keep it as clean as possible.
So please don't see my review as something negative, but rather something positive.


Am Mittwoch, 28. November 2012, 18:48:57 schrieb Mathias LEBLANC:
> Ok, so i have patch the ST33 I2C driver on this branch and correct some
> errors. I send you the patch for the kernel 3.x
> I have no error on compilation, tell me if you have problems.
> I have implemented the tpm_do_selftest function to get the tpm ready, but
> it can be removed ________________________________________

Unfortunately you attached the patch instead of sending it in plaintext which is the usual practice -> care to resend in plain text? 
Makes the review far easier.

(btw.: Please also have a look at
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches;hb=HEAD
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmitChecklist;hb=HEAD
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingDrivers;hb=HEAD
which describes the process in detail)

When you resend the patch, can you please include the "metadata" as well - i.e. your modifications to the Kconfig / Makefile etc.
I do not see a reason why to keep it in a seperate patch.




I tried the patch you've posted and it applies cleanly and now (finally) compiles as well - so now I can start with my review:

= The name =
There's already one i2c tpm driver in the tree, so maybe it would be a good idea to keep the naming scheme consistent? 
-> How about tpm_i2c_stm_st33.c ?
Eventually this is something Kent as a maintainer has to decice - but I would really like to see the name change.
I hope we can eventually consolidate all the 'tis' based drivers.


= Compiling / License = 
When compiling the driver I get the following warning
   WARNING: modpost: missing MODULE_LICENSE() in /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
Please include the appropriate MODULE_LICENSE as my kernel otherwise gets tainted by your driver.

Also this:
+ * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.

is not possible afaik - kernel code must be under GPL v2 _only_ without the "or (at your option) any later version." addition.



= sparse warnings =
When running sparse against your code I get the following warnings:
 make -C /data/data-old/linux-2.6/ M=`pwd`  modules C=1
make: Entering directory `/data/data-old/linux-2.6'
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:167:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:187:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:180:5: warning: symbol 'wait_for_serirq_timeout' was not declared. Should it be static?
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:210:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:227:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:245:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:269:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:307:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:324:38: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:394:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:424:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:456:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:531:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29: warning: incorrect type in assignment (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29:    expected void [noderef] <asn:2>*iobase
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29:    got struct i2c_client *client
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:781:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:818:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:841:19: warning: cast removes address space of expression
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
  Building modules, stage 2.
  MODPOST 8 modules


Please fix these if applicable - otherwise you'll probably get a friendly reminder to do so by fengguang's build test ;)


= smatch =
Same applies to smatch
make -C /data/data-old/linux-2.6/ M=`pwd`  modules C=1 CHECK=smatch
make: Entering directory `/data/data-old/linux-2.6'
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:535 tpm_stm_i2c_recv() warn: variable dereferenced before check 'chip' (see line 531)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:748 tpm_st33_i2c_probe() warn: variable dereferenced before check 'platform_data' (see line 659)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
/data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o

Please fix these if applicable - otherwise you'll probably get a friendly reminder to do so by fengguang's build test ;)

= checkpatch =
Also please run .../scripts/checkpatch.pl -strict before submission - not everything that is reported might be applicable, but quite often it is.



Looking forward to your v2 so I can give a more detailed code review of your code.


Thanks,
Peter


