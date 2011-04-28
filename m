Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1D1HWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:22:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51042 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1D1HWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:22:10 -0400
Message-ID: <8430D2C750334C98B8E8D1469F2023C7@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de> <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg> <4DB7C5F7.3080103@pengutronix.de> <20110427091252.GP17290@n2100.arm.linux.org.uk> <5BAE2D6F9E6047C19B6BE8FF26F7270B@subhasishg> <4DB81B9E.3000401@pengutronix.de>
In-Reply-To: <4DB81B9E.3000401@pengutronix.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Thu, 28 Apr 2011 12:52:49 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/27/2011 03:18 PM, Subhasish Ghosh wrote:
> My problem is, I am doing something like this:
>
> s32 pruss_writel_multi(struct device *dev, u32 offset,
>                u32 *pdatatowrite, u16 wordstowrite)
> {
>        struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
>        u32 __iomem *paddresstowrite;
>        u16 i;
>
>        paddresstowrite = pruss->ioaddr + offset;
>
>        for (i = 0; i < wordstowrite; i++)
>                iowrite32(*pdatatowrite++, paddresstowrite++);
>
>        return 0;
> }
>
> So, if I make paddresstowrite as void, it will not work. The above
> implementation does not generate any sparse errors though.

Yes, that why I can work with readb_multi even if I have void __iomen *.

But, how do I solve this problem. In the above function, I must use u32 
__iomem * 

