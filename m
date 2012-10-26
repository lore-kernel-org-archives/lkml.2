Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966573Ab2JZVML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:12:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab2JZVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:12:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Chris Brand" <chris.brand@broadcom.com>
Subject: Re: [PATCH v4] pwm: vt8500: Update vt8500 PWM driver support
Date: Fri, 26 Oct 2012 21:11:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Tony Prisk" <linux@prisktech.co.nz>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1351100330-26072-1-git-send-email-linux@prisktech.co.nz> <4EE5B48738DDED408878C97C8E050A8B1BD17DD2@SJEXCHMB05.corp.ad.broadcom.com>
In-Reply-To: <4EE5B48738DDED408878C97C8E050A8B1BD17DD2@SJEXCHMB05.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210262111.56608.arnd@arndb.de>
X-Provags-ID: V02:K0:hQrfhctLXDaik7WtyBv8t96vibQhAKI4HIrJMPBjnxZ
 F0he1b1XVcJHvBXg5a9kLnPuyfDRDJuZMiRic8judl3WrXCkIl
 8JNhN0P/Pecx848eiCypOzErpu+OZIPc2DSCq/Zxxk2COR39el
 J/e9aRkfc+wa+zN54gXmLPHev4KbtXO7mPtgM2JrB4dPCoM+fr
 d66MVmSvblEFX5K4+u3685xMWSWadB3tnm3t8EOoaQM6fC09E+
 NiT3x/pis/8n+M8EhD/i1w71i1xE3jIayUHP9kkcxpTRR9crKB
 C/UT3aiIZq/KSqCuEa3ZzFxJeQK8pTNAg9yWfLDI+y+NFjwiBo
 t+ZKlnqayljcuCnLhhnc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012, Chris Brand wrote:
> > @@ -124,6 +156,12 @@ static int __devinit pwm_probe(struct
> > platform_device *pdev)
> >       chip->chip.base = -1;
> >       chip->chip.npwm = VT8500_NR_PWMS;
> > 
> > +     chip->clk = devm_clk_get(&pdev->dev, NULL);
> > +     if (IS_ERR_OR_NULL(chip->clk)) {
> > +             dev_err(&pdev->dev, "clock source not specified\n");
> > +             return PTR_ERR(chip->clk);
> > +     }
> > +
> 
> Do you want IS_ERR() rather than IS_ERR_OR_NULL() here ?
> Otherwise you may return PTR_ERR(NULL).
> 

Right. devm_clk_get() never returns NULL, but as Russell pointed out
recently, this usage of IS_ERR_OR_NULL() is completely bogus.

	Arnd
