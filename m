Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0LIJL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:11:56 -0500
Received: from spamfilter.jmicron.com ([220.130.51.235]:24078 "EHLO
	jmsspam.jmicron.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543Ab0LIJLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:11:53 -0500
X-Greylist: delayed 705 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 04:11:53 EST
X-IronPort-AV: E=Sophos;i="4.59,319,1288540800"; 
   d="scan'208";a="1143849"
Message-Id: <201012090859.oB98xp2P015861@jmr105.jmicron.com>
From: "Aries Lee" <arieslee@jmicron.com>
To: "'Takashi Iwai'" <tiwai@suse.de>,
        "'zhangfei gao'" <zhangfei.gao@gmail.com>
Cc: "'Chris Ball'" <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Wolfram Sang'" <w.sang@pengutronix.de>
Subject: RE: [PATCH v2] mmc: Add support for JMicron 388 SD/MMC controller
Date: Thu, 9 Dec 2010 16:59:51 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: AcuXeUEl1U+4x1tQToWaLJI05keZ5gAAfGIg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
In-Reply-To: <s5hwrnjz7j4.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All

JMicron 388 support the new generation SD card with Ultra-High speed
feature.
it have to run under 1.8V in this feature, that mean the capability of host
is claimed to support both 1.8V and 3.3V, but the 1.8V and 3.3V is only for
SD part, it is always 3.3V for MMC part.

In MMC-mobile card, the capability of the card is claimed as supporting both
1.8V and 3.3V, so in card initialization, the driver will choose 1.8V
because both host and card are claimed to support. Then lead to wrong
situation because acturally the 1.8V of host is claimed for UHS SD card, it
MUST be 3.3V for MMC card.

This patch rectified the error case of JMicron 388 host.

Thanks
-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Thursday, December 09, 2010 4:15 PM
To: zhangfei gao
Cc: Chris Ball; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org;
Aries Lee; Wolfram Sang
Subject: Re: [PATCH v2] mmc: Add support for JMicron 388 SD/MMC controller

At Wed, 8 Dec 2010 21:18:38 -0500,
zhangfei gao wrote:
> 
> On Wed, Dec 8, 2010 at 4:04 AM, Takashi Iwai <tiwai@suse.de> wrote:
> > JMicron 388 SD/MMC combo controller supports the 1.8V low-voltage for
> > SD, but MMC doesn't work with the low-voltage, resulting in an error
> > at probing.
> >
> > This patch adds the support for multiple voltage mask per device type,
> > so that SD works with 1.8V while MMC forces 3.3V. ?Here new ocr_avail_*
> > fields for each device are introduced, so that the actual OCR mask is
> > switched dynamically.
> 
> It is great that you also have 1.8v requirement, could you help share some
info?
> What's the card you are using, mmc or sd, if sd, does cmd11 is required?
> Which component will provide voltage in your platform, external pmic
> or controller?
> What's the init voltage, 3.3v? and then switch to 1.8v, does some time
> required to wait voltage to be stable?

I guess Aries can answer to these at best :)
1.8V case was tested mainly by him.


thanks,

Takashi

