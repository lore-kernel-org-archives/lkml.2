Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1IEMNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:13:25 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39805 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1IEMNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:13:17 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p85CD90t020442
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1314956953-1568-1-git-send-email-hayeswang@realtek.com> <1314956953-1568-4-git-send-email-hayeswang@realtek.com <20110902162831.GA25544@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next v4 4/4] r8169: support new chips of RTL8111F
Date: Mon, 5 Sep 2011 20:13:07 +0800
X-BOX-Message-Id: p85CD90t020442
Message-ID: <954269F52E114A0ABE17F326C1E2D74B@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acxpj/YZISN8QjkATsGoDwI0tSY9HQCMoEgg
In-Reply-To: <20110902162831.GA25544@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Saturday, September 03, 2011 12:29 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v4 4/4] r8169: support new chips 
> of RTL8111F
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Support new chips of RTL8111F.
> 
> Amongst other things :o)
> 
> > diff --git a/drivers/net/ethernet/realtek/r8169.c 
> > b/drivers/net/ethernet/realtek/r8169.c
> > index 175c769..8e6a200 100644
> > --- a/drivers/net/ethernet/realtek/r8169.c
> > +++ b/drivers/net/ethernet/realtek/r8169.c
> [...]
> > @@ -711,7 +719,10 @@ MODULE_FIRMWARE(FIRMWARE_8168D_1);
> >  MODULE_FIRMWARE(FIRMWARE_8168D_2);
> >  MODULE_FIRMWARE(FIRMWARE_8168E_1);
> >  MODULE_FIRMWARE(FIRMWARE_8168E_2);
> > +MODULE_FIRMWARE(FIRMWARE_8168E_3);
> 
> This one is relevant for Linus's tree.
> 
> Don't worry about submitting again, I'll send it separately.
> 

OK. I would adjust it again.

> No opinion regarding the jumbo fixes patches I sent on 2011/07/17 ?
> 

It seems fine except that you don't need to disable rx checksum when using jumbo
frame. The chips don't support tx checksum when using jumbo frame because of the
feature of early tx. The early tx means that the hw would start to send the
packet without loading the all data into fifo, so the software checksum is
necessary. However, there is no influence for rx, so you could still enable rx
checksum.
 
Best Regards,
Hayes

