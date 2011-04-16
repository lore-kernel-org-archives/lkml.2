Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1DPIb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:31:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49523 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1DPIb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w+jrYP+Kl5Qn3Yt8EcHRZTtmcI4TUeW46skxKgOlx/nexrLhYkT5mgivXaVfwkHwfo
         e6WDxnEaKEvE0OoelSHd0li6VcOhu0x/eFlzAwHrEHlKbuhaVowSXRiXjvCdEbShzU3d
         ZfBoMvjGNwwpeYtvIvxl5OGS+0u0+zkdVLCRA=
Subject: Re: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Murali Nalajala <mnalajal@codeaurora.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1302942029.2308.1.camel@koala>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
	 <1302861097.3220.12.camel@localhost>  <4DA85B24.50807@codeaurora.org>
	 <1302942029.2308.1.camel@koala>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 11:31:52 +0300
Message-ID: <1302942712.2308.3.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 11:20 +0300, Artem Bityutskiy wrote:
> > > +#define MSM_NAND_REG(off) (msm_nand_phys + (off))
> > > +
> > > +#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
> > > +#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)
> > >
> > > Could you please make the macros to take the "struct msm_nand_chip
> > > *chip" argument instead, and store the pase address there. Do not hide
> > > the fact that those macros are actually functions, not constant - this
> > > is error prone.
> > >
> > > Besides, I'm do not know your HW, but if you have several controllers
> > > with various base addresses - your driver won't work.
> > 
> > you are correct, we have multiple controllers, which breaks this logic 
> > in future.
> 
> So then make your macros to accept the base address as an argument
> instead please.

Or better make macros to be constants, and always use something like
base + MSM_NAND_FLASH_CMD - this is the standard approach.
-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

