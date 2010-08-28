Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0H1P14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:27:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0H1P1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=cIY7EbFH/lc4Z+kXbTtUZ2faYxyaYmAzCzk8uI7Q+NyVz6XRbk/DNU5sxmuhnT9HG5
         4y8ULJLOZ/MyigqFOcuT9tL5Nj5Gn27Mw4bGCzBeqFqFKZYpX3Kms8zJpTtDPp993Pr4
         9+utmX9fKv8Bh5kXxStqiXv/ACl8t1+gagSiU=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Date: Sat, 28 Aug 2010 17:27:10 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <20100823174852.GB26928@pengutronix.de> <AANLkTimmEKfErV17RWNBO-pVCfFtFw=yJL2v92UBN0=2@mail.gmail.com>
In-Reply-To: <AANLkTimmEKfErV17RWNBO-pVCfFtFw=yJL2v92UBN0=2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008281727.10913.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 28. srpna 2010 17:18:17 Linus Walleij napsal(a):
> 2010/8/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> >> +     evt = readl(SDMA_H_EVTOVR);
> >> +     mcu = readl(SDMA_H_HOSTOVR);
> >> +     dsp = readl(SDMA_H_DSPOVR);
> > 
> > __raw_readl?
> 
> Sorry I never understood this __raw_[read|write][b|w|l] vs.
> plain read[b|w|l] proliferation in some drivers and code.
> 
> What's the reason for?

Hey,

this trick is, if you create the VA<->PA mapping at the kernel start (eg. see 
how pxa_map_io() is replacedon some devices for instance), you then use the VA 
address you specified and use __raw_{read,write}[b,w,l](). So use 
__raw_{read,write}[b,w,l]() on drivers specific for certain device and use 
{read,write}[b,w,l]() on ioremap()ed memory areas, aka. in common drivers.

Cheers

> 
> Yours,
> Linus Walleij
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
