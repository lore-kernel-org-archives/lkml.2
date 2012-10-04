Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2JDMlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:41:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16827 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2JDMlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:41:01 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-1e-506d83db30a8
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Will Newton'" <will.newton@gmail.com>, "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-mmc@vger.kernel.org
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
 <1348868177-21205-4-git-send-email-arnd@arndb.de>
 <CAFbHwiRGnhEf-3XJJJPrHwmQRj_YE2kCZaGURHDQcu=cj0zSHw@mail.gmail.com>
In-reply-to: <CAFbHwiRGnhEf-3XJJJPrHwmQRj_YE2kCZaGURHDQcu=cj0zSHw@mail.gmail.com>
Subject: RE: [PATCH 03/12] mmc: dw_mmc: fix building exynos driver as a module
Date: Thu, 04 Oct 2012 21:40:59 +0900
Message-id: <001d01cda22d$81a3b4f0$84eb1ed0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2fxLv92xmz6GQwQky9jErZTDrg9QCYFZsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd3bzbkBBv/mmVtc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLOPlvFXvCKt+JO5xyWBsYW7i5GTg4JAROJiS0vGSFs
	MYkL99azdTFycQgJLGKU+LfjPjuE84dRYt2Ly6wgVWwCWhJ/37xhBrFFBLwkjvY8YAUpYhY4
	ziRxYM0JZoiOHYwSB+5OBevgFAiWOLvtCNBcDg5hAT+J9mkmIGEWAVWJo83bwFbzCthKrFk1
	jxXCFpT4MfkeC4jNLKAn8fHPbUYIW15i85q3zCBjJATUJR791YW4wUji2O11bBAlIhL7Xrxj
	nMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKD+pn0DsZV
	DRaHGAU4GJV4eC0m5QQIsSaWFVfmHmKU4GBWEuH1zs0NEOJNSaysSi3Kjy8qzUktPsQozcGi
	JM7b7JESICSQnliSmp2aWpBaBJNl4uCUamBku6SksG2N21S7Vy1O67dud8j6dH/755aej65X
	6ri/f9AKL1gq17lTb0l9MNvST9K79nVZNU5UPdtXL2t6wO+S6+Yb3gkFW/7Njua/2jtVvnfn
	1ITsGb9PXLL7uH7CvNMS5zZfCp67ZXnoS7t1xxxmtbL36kma/DV5mGw+u25+XLLZFpM7L/ZP
	UGIpzkg01GIuKk4EAGZ60iRmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday, October 01, 2012, Will Newton <will.newton@gmail.com> wrote:
> On Fri, Sep 28, 2012 at 10:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The MODULE_DEVICE_TABLE() entry in the dw_mmc_exynos driver
> > points to the wrong symbol which results in a link error
> > when building as a loadable module.
> >
> > Further, we get a warning about the driver_data being
> > marked constant, which requires annotating a few pointers
> > as const.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Chris Ball <cjb@laptop.org>
> > Cc: Thomas Abraham <thomas.abraham@linaro.org>
> > Cc: Will Newton <will.newton@imgtec.com>
> > Cc: Jaehoon Chung <jh80.chung@samsung.com>
> > Cc: Seungwon Jeon <tgih.jun@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: linux-mmc@vger.kernel.org
> > ---
> >  drivers/mmc/host/dw_mmc-exynos.c |    4 ++--
> >  drivers/mmc/host/dw_mmc-pltfm.c  |    2 +-
> >  drivers/mmc/host/dw_mmc-pltfm.h  |    2 +-
> >  drivers/mmc/host/dw_mmc.c        |    2 +-
> >  include/linux/mmc/dw_mmc.h       |    2 +-
> >  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> This looks ok to me, but I'll let one of the Exynos guys ack those
> specific changes as I don't have the hardware.
> 
> There's already a patch for the dev_info warning in dw_mmc.c frm
> Seungwon Jeon, and it seems to me like a separate change but I don't
> really mind how it gets merged.

Looks good to me.
I don't mind it about including 'dev_info warning'.

Acked-by: Seungwon Jeon<tgih.jun@samsung.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

