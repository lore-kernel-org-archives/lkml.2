Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1DPIUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:20:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65017 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1DPIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t0XCrhVR53I5voNwzGTNdc/fqxvqt4nJCawWIEq9gUN2L88ewcsE2J3t1njMcwfctc
         lb+0xqk6TMJ2QMapAhv6jgwl54yCWN06mD5iYps8cjQJSma0y7ReC12oAlnGVAdR7vwe
         6DEXtw7zXYgz7nCGxwWB11RT2vDaqqRbY0PwQ=
Subject: Re: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Murali Nalajala <mnalajal@codeaurora.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <4DA85B24.50807@codeaurora.org>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
	 <1302861097.3220.12.camel@localhost>  <4DA85B24.50807@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 11:20:29 +0300
Message-ID: <1302942029.2308.1.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 20:20 +0530, Murali Nalajala wrote:
> On 4/15/2011 3:21 PM, Artem Bityutskiy wrote:
> > On Tue, 2011-03-01 at 06:17 +0530, Murali Nalajala wrote:
> >> +#define pr_fmt(fmt) "%s:" fmt, __func__
> >> +
> >> +#include<linux/kernel.h>
> >> +#include<linux/mtd/mtd.h>
> >> +#include<linux/mtd/nand.h>
> >> +#include<linux/mtd/partitions.h>
> >> +#include<linux/platform_device.h>
> >> +#include<linux/sched.h>
> >> +#include<linux/slab.h>
> >> +#include<linux/dma-mapping.h>
> >> +#include<asm/mach/flash.h>
> >> +#include<mach/dma.h>
> >> +
> >> +#include "msm_nand.h"
> >> +
> >> +unsigned long msm_nand_phys;
> >
> > No global variables like this please. Here is how you use them:
> >
> > +extern unsigned long msm_nand_phys;
> 
> extern declaration in the 'C' file causing warning. We are in plan to 
> upload the OneNAND changes soon which makes use of the same .h file.

So you say that OneNAND (an independent driver) is going to use this
variable? Are you also going to export it?

> > +#define MSM_NAND_REG(off) (msm_nand_phys + (off))
> > +
> > +#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
> > +#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)
> >
> > Could you please make the macros to take the "struct msm_nand_chip
> > *chip" argument instead, and store the pase address there. Do not hide
> > the fact that those macros are actually functions, not constant - this
> > is error prone.
> >
> > Besides, I'm do not know your HW, but if you have several controllers
> > with various base addresses - your driver won't work.
> 
> you are correct, we have multiple controllers, which breaks this logic 
> in future.

So then make your macros to accept the base address as an argument
instead please.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

