Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2LERrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:47:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57636 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2LERro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:47:44 -0500
Date: Wed, 5 Dec 2012 11:45:27 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Cc: Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
 KERNEL 3.x.x
Message-ID: <20121205174527.GF21050@ennui.austin.ibm.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
 <35286B1AE75A7C47BFF0870081A31B4B3A9B501757@SAFEX1MAIL4.st.com>
 <201211290104.53049.PeterHuewe@gmx.de>
 <35286B1AE75A7C47BFF0870081A31B4B3A9B64E89C@SAFEX1MAIL4.st.com>
 <20121205171350.GD21050@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121205171350.GD21050@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120517-7606-0000-0000-00000628E028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 11:13:51AM -0600, Kent Yoder wrote:
> On Wed, Dec 05, 2012 at 05:11:40PM +0100, Mathias LEBLANC wrote:
> > Hi Peter,
> > 
> > Thanks for your contribution.
> > I have modified the driver files name and descriptions.
> > Regarding the warnings, it's strange. 
> > 
> > @Kent, could you confirm that you have the same?
> 
>   Yep, I see these too. They're a side effect of storing the i2c_client
> pointer in vendor->iobase, which is __iomem.  The i2c_client struct
> isn't __iomem at all though, writes in the i2c subsystem are done
> through client->addr.  So i2c_client should really be stored somewhere
> else, no?
> 
>   vendor->data seems like the right place.  I'm on the hook to update
> the other drivers with a macro for accessing vendor->data in tpm.h.
> I'll make these updates and send out a patch.

  Mathias, one other thing, MODULE_LICENSE(): GPL?

Kent

> Kent
> 
> > Regards,
> > 
> > Mathias Leblanc
> > 
> > -----Original Message-----
> > From: Peter Hüwe [mailto:PeterHuewe@gmx.de] 
> > Sent: 29 November, 2012 01:05
> > To: Mathias LEBLANC
> > Cc: Kent Yoder; Kent Yoder; Jean-Luc BLANC; linux-kernel@vger.kernel.org; Rajiv Andrade; tpmdd-devel@lists.sourceforge.net; Sirrix@jasper.es
> > Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
> > 
> > Hi Mathias,
> > 
> > please note: 
> > I'm writing this email on behalf of myself only and nobody else, especially not my employer - and I'm doing this in my spare time.
> > I'm working for a direct competitor of yours, but I'm not using any knowledge that I've picked up at work or that is considered secret in any way.
> > I have a personal interest in the TPM subsystem and want to keep it as clean as possible.
> > So please don't see my review as something negative, but rather something positive.
> > 
> > 
> > Am Mittwoch, 28. November 2012, 18:48:57 schrieb Mathias LEBLANC:
> > > Ok, so i have patch the ST33 I2C driver on this branch and correct 
> > > some errors. I send you the patch for the kernel 3.x I have no error 
> > > on compilation, tell me if you have problems.
> > > I have implemented the tpm_do_selftest function to get the tpm ready, 
> > > but it can be removed ________________________________________
> > 
> > Unfortunately you attached the patch instead of sending it in plaintext which is the usual practice -> care to resend in plain text? 
> > Makes the review far easier.
> > 
> > (btw.: Please also have a look at
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches;hb=HEAD
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmitChecklist;hb=HEAD
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingDrivers;hb=HEAD
> > which describes the process in detail)
> > 
> > When you resend the patch, can you please include the "metadata" as well - i.e. your modifications to the Kconfig / Makefile etc.
> > I do not see a reason why to keep it in a seperate patch.
> > 
> > 
> > 
> > 
> > I tried the patch you've posted and it applies cleanly and now (finally) compiles as well - so now I can start with my review:
> > 
> > = The name =
> > There's already one i2c tpm driver in the tree, so maybe it would be a good idea to keep the naming scheme consistent? 
> > -> How about tpm_i2c_stm_st33.c ?
> > Eventually this is something Kent as a maintainer has to decice - but I would really like to see the name change.
> > I hope we can eventually consolidate all the 'tis' based drivers.
> > 
> > 
> > = Compiling / License =
> > When compiling the driver I get the following warning
> >    WARNING: modpost: missing MODULE_LICENSE() in /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
> > Please include the appropriate MODULE_LICENSE as my kernel otherwise gets tainted by your driver.
> > 
> > Also this:
> > + * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
> > + * Copyright (C) 2009, 2010  STMicroelectronics
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > 
> > is not possible afaik - kernel code must be under GPL v2 _only_ without the "or (at your option) any later version." addition.
> > 
> > 
> > 
> > = sparse warnings =
> > When running sparse against your code I get the following warnings:
> >  make -C /data/data-old/linux-2.6/ M=`pwd`  modules C=1
> > make: Entering directory `/data/data-old/linux-2.6'
> >   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:167:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:187:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:180:5: warning: symbol 'wait_for_serirq_timeout' was not declared. Should it be static?
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:210:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:227:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:245:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:269:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:307:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:324:38: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:394:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:424:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:456:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:531:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29: warning: incorrect type in assignment (different address spaces)
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29:    expected void [noderef] <asn:2>*iobase
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:672:29:    got struct i2c_client *client
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:781:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:818:19: warning: cast removes address space of expression
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:841:19: warning: cast removes address space of expression
> >   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
> >   Building modules, stage 2.
> >   MODPOST 8 modules
> > 
> > 
> > Please fix these if applicable - otherwise you'll probably get a friendly reminder to do so by fengguang's build test ;)
> > 
> > 
> > = smatch =
> > Same applies to smatch
> > make -C /data/data-old/linux-2.6/ M=`pwd`  modules C=1 CHECK=smatch
> > make: Entering directory `/data/data-old/linux-2.6'
> >   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:535 tpm_stm_i2c_recv() warn: variable dereferenced before check 'chip' (see line 531)
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:748 tpm_st33_i2c_probe() warn: variable dereferenced before check 'platform_data' (see line 659)
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
> > /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
> >   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
> > 
> > Please fix these if applicable - otherwise you'll probably get a friendly reminder to do so by fengguang's build test ;)
> > 
> > = checkpatch =
> > Also please run .../scripts/checkpatch.pl -strict before submission - not everything that is reported might be applicable, but quite often it is.
> > 
> > 
> > 
> > Looking forward to your v2 so I can give a more detailed code review of your code.
> > 
> > 
> > Thanks,
> > Peter
> > 
> > 
> 
> 
> ------------------------------------------------------------------------------
> LogMeIn Rescue: Anywhere, Anytime Remote support for IT. Free Trial
> Remotely access PCs and mobile devices and provide instant support
> Improve your efficiency, and focus on delivering more value-add services
> Discover what IT Professionals Know. Rescue delivers
> http://p.sf.net/sfu/logmein_12329d2d
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> 

