Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1ABJsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:48:15 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:58006 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1ABJsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:48:14 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'john stultz'" <johnstul@us.ibm.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <00d601cba465$27154a70$753fdf50$@mprc.pku.edu.cn> <AANLkTinjzzMz4WFRYmjZiM=P6c1wtSxpY2bzOuUe0Vrd@mail.gmail.com>
In-Reply-To: <AANLkTinjzzMz4WFRYmjZiM=P6c1wtSxpY2bzOuUe0Vrd@mail.gmail.com>
Subject: RE: [PATCHv1 09/12] unicore32 core architecture: timer and time
Date: Sun, 2 Jan 2011 17:47:52 +0800
Message-ID: <008f01cbaa62$2001fff0$6005ffd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGO9latPfH2ndA/PgMgM9dOsVwpxAHTluFSlCg1qYA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: johnstul.lkml@gmail.com [mailto:johnstul.lkml@gmail.com] On Behalf Of john stultz
> Sent: Tuesday, December 28, 2010 5:27 AM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 09/12] unicore32 core architecture: timer and time
> 
> 2010/12/25 Guan Xuetao <guanxuetao@mprc.pku.edu.cn>:
> > From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> >
> > Patch 9 implements timer and time. RTC and PWM device drivers are also here.
> >
> > Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> Just a small request:
> 
> > +static struct clocksource cksrc_puv3_oscr = {
> > +       .name           = "oscr",
> > +       .rating         = 200,
> > +       .read           = puv3_read_oscr,
> > +       .mask           = CLOCKSOURCE_MASK(32),
> > +       .shift          = 18,
> 
> Drop the shift assignment here.
> 
> > +       cksrc_puv3_oscr.mult =
> > +               clocksource_hz2mult(CLOCK_TICK_RATE, cksrc_puv3_oscr.shift);
> > +
> Drop the mult assignment here.
> 
> 
> > +       clocksource_register(&cksrc_puv3_oscr);
> 
> Use "clocksource_register_hz(&cksrc_puv3_oscr, CLOCK_TICK_RATE );" and
> the kernel will fill in mult/shift appropriately.
> 
> If you have any troubles after doing so, let me know.

When using clocksource_register_hz(&cksrc_puv3_oscr, CLOCK_TICK_RATE ),
 the shift value become 0, and mult value become 0x838a91a7, and the system will be broken
after printing "Switching to clocksource oscr".

When using clocksource_register_khz(&cksrc_puv3_oscr, CLOCK_TICK_RATE ),
the shift value become 0, and mult value become  0x4359611, and the system will run smoothly,
but timer interrupt seems too frequently. Perhaps it is 4 times faster.

For comparison, originally, when shift value is set to 0x12, the mult value become 1175e5e.

Which one is better?

> 
> thanks
> -john

Thanks john.

Guan Xuetao


