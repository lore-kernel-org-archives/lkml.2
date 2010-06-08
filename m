Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0FHIJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:09:54 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35396 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab0FHIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:09:51 -0400
Message-ID: <002401cb06e1$f7b58db0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Yong Wang" <yong.y.wang@linux.intel.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C0DCE87.1090802@dsn.okisemi.com> <20100608072049.GA12940@ywang-moblin2.bj.intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 8 Jun 2010 17:09:43 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yong Wang

Thank you for your comment.

> Why is 50MHz so special, btw?
This code is work around for previous HW bug.
(CAN worked only 50MHz with previous HW)

Since the HW bug has been already fixed for the latest HW,
this code is unnecessary for the latest HW.

> Note that 'a' is supposed to be surrounded by brackets, too.
>
> #define PCH_WRITE_REG(a, b) iowrite32((a), pcb_phub_base_address + (b))
Thank you for your indication. We have updated.

Best Regards,
----- Original Message ----- 
From: "Yong Wang" <yong.y.wang@linux.intel.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML" <linux-kernel@vger.kernel.org>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>
Sent: Tuesday, June 08, 2010 4:20 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Tue, Jun 08, 2010 at 02:00:55PM +0900, Masayuki Ohtak wrote:
> > Hi Alan
> >
> > We are now updating our Phub driver.
> >
> > I have a questions for your comment.
> >
> > (1)
> > >> +#ifdef PCH_CAN_PCLK_50MHZ
> > >> + /* save clk cfg register */
> > >> + g_pch_phub_reg.clkcfg_reg = PCH_READ_REG(CLKCFG_REG_OFFSET);
> > >> +#endif
> > >
> > > This makes it hard to build one kernel for everything
> > We couldn't understand your intention.
> > Does the above mean we must not use "#ifdef PCH_CAN_PCLK_50MHZ" in source code ?
> >
>
> I think what Alan means is that you will have to build two kernel images
> for two possible configurations of how your hardware is going to be used
> if you write code this way. One is the case when CAN clock runs at 50MHz
> and you will build a kernel image with PCH_CAN_PCLK_50MHZ defined. The
> other is when CAN clock runs at other speed and you need to build
> another kernel image with PCH_CAN_PCLK_50MHZ undefined. It would be much
> better if one kernel image could run on all configurations.
>
> Why is 50MHz so special, btw? Don't you need to save and restore the
> clock config register when CAN clock runs at other speed?
>
> >
> > >> +#define PCH_READ_REG(a) ioread32((pch_phub_base_address + a))
> >
> > >> +
> >
> > >> +#define PCH_WRITE_REG(a, b) iowrite32(a, (pch_phub_base_address + b))
> >
> > >
> >
> > > These on the other hand do - but not where they are now
> >
> > >
> >
> > > iowrite32((a), pcb_phub_base_address + (b))
> >
> > >
> >
> > > (so that if a or b are expressions they are evaluated first)
> >
> > Modify like below.
> >
> > #define PCH_READ_REG(a) ioread32(pch_phub_base_address + (a))
> >
> > #define PCH_WRITE_REG(a, b) iowrite32(a, pch_phub_base_address + (b))
> >
>
> Note that 'a' is supposed to be surrounded by brackets, too.
>
> #define PCH_WRITE_REG(a, b) iowrite32((a), pcb_phub_base_address + (b))
>
> Thanks
> -Yong
>


