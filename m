Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0IABuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:50:14 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9594 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IABuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:50:11 -0400
Message-ID: <003f01cb4978$02e8b760$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        <margie.foster@intel.com>, <alan@linux.intel.com>, <gregkh@suse.de>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <meego-dev@meego.com>
References: <4C5B9094.5090205@dsn.okisemi.com> <4C5B9229.1040403@linux.intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Wed, 1 Sep 2010 10:50:04 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Sorry, for late response.
----- Original Message ----- 
From: "Arjan van de Ven" <arjan@linux.intel.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; <yong.y.wang@intel.com>; <qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
<gregkh@suse.de>; <alan@linux.intel.com>; <margie.foster@intel.com>
Sent: Friday, August 06, 2010 1:40 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35


> On 8/5/2010 9:33 PM, Masayuki Ohtak wrote:
> >
> > +config PCH_I2C
> > + tristate "PCH I2C"
> >
>
> this is really not very descriptive. Can you make it "OKI Semi PCH I2C
> controller" or something

We will modify.

>
> if you has human get asked "PCH I2C"... almost nobody will know what
> that means.+static irqreturn_t pch_handler_ch0(int irq, void *pData);
>
>
> > +static irqreturn_t(*pch_handler_list[PCH_MAX_CHN]) (int irq, void *pData) = {
> > + pch_handler_ch0,
> > +};
> >
>
> hummmmmm what is this for??

This is callback function list for mulit-cahnnel I2C device.

>
>
> > +
> > +static inline void pch_setbit(void __iomem *addr, u32 offset, u32 bitmask)
> > +{
> > + iowrite32(((ioread32(addr + offset)) | (bitmask)), (addr + offset));
> > +}
> >
>
> this might be more readble if it's made 3 lines with a local variable...
> + "Cleared the registers PCH_I2CCTL,PCH_I2CMOD,PCH_I2CBUFFOR\n,"
>
>
> > + "PCH_I2CBUFSLV,PCH_I2CBUFSUB,PCH_I2CBUFMSK,\n"
> >

I will divide to 3 lines.

>
> what's that weird character ?diff --git a/drivers/i2c/i2c-dev.c
> b/drivers/i2c/i2c-dev.c
> + case I2C_MODE_SEL:
>
>
> > + pch_mode = arg;
> > +
> > + if (pch_mode <= 4) {
> > + msgbuf[0] = pch_mode;
> > + msg.buf = msgbuf;
> > + msg.len = 1;
> > + msg.flags = 0;
> > + ret = i2c_transfer(client->adapter, &msg, 1);
> >
>
> in generic code??
>
>

I will revert i2c-dev.c.


I will submit modified patch soon.

Thanks, Ohtake(OKISemi)


