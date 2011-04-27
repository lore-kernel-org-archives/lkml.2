Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab1D0NSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:18:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41057 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1D0NSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:18:16 -0400
Message-ID: <5BAE2D6F9E6047C19B6BE8FF26F7270B@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de> <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg> <4DB7C5F7.3080103@pengutronix.de> <20110427091252.GP17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427091252.GP17290@n2100.arm.linux.org.uk>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 27 Apr 2011 18:48:54 +0530
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

My problem is, I am doing something like this:

s32 pruss_writel_multi(struct device *dev, u32 offset,
                u32 *pdatatowrite, u16 wordstowrite)
{
        struct pruss_priv *pruss = dev_get_drvdata(dev->parent);
        u32 __iomem *paddresstowrite;
        u16 i;

        paddresstowrite = pruss->ioaddr + offset;

        for (i = 0; i < wordstowrite; i++)
                iowrite32(*pdatatowrite++, paddresstowrite++);

        return 0;
}

So, if I make paddresstowrite as void, it will not work. 
The above implementation does not generate any sparse errors though.


> On Wed, Apr 27, 2011 at 09:29:59AM +0200, Marc Kleine-Budde wrote:
>> On 04/27/2011 08:39 AM, Subhasish Ghosh wrote:
>> > - Is it ok to have u32 etc for __iomem cookie ?
>> 
>> no - "void __iomem *" is "void __iomem *"
> 
> Actually, it is _provided_ you don't directly dereference it.  You can
> then do pointer arithmetic on it in the usual way - which is about the
> only valid thing to do with an __iomem pointer.  The voidness just acts
> as an additional check against direct dereferences of this.
> 
> The important thing though is that the code passes sparse checks. 
