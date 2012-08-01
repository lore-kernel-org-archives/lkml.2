Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2HAE57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:57:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23959 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2HAE55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:57:57 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-d9-5018b753a985
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Damien Cassou'" <damien.cassou@lifl.fr>, kernel-janitors@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
 <1343752762-16861-6-git-send-email-damien.cassou@lifl.fr>
 <002c01cd6f73$4252b090$c6f811b0$%han@samsung.com>
 <CAK9yfHzje6NLqi5ixxA3J4aT1a9p6wJNJePzTi4xG9LN6AeLVw@mail.gmail.com>
 <003e01cd6f9e$5a1146d0$0e33d470$%han@samsung.com>
 <CAK9yfHyvHEPQRFvuX6q5CZEEN_6xeTqWvitdtayib6W8t0qCWw@mail.gmail.com>
In-reply-to: <CAK9yfHyvHEPQRFvuX6q5CZEEN_6xeTqWvitdtayib6W8t0qCWw@mail.gmail.com>
Subject: RE: [PATCH 5/5] drivers/video/exynos/exynos_dp_core.c: use devm_
 functions
Date: Wed, 01 Aug 2012 13:57:54 +0900
Message-id: <003f01cd6fa2$36463bd0$a2d2b370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1vn4EZegDDLyMwTIyVc4w3pvz1lwAAMyYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd3g7RIBBv+XcltsvSVtcaLvA6vF
	5V1z2ByYPT5vkgtgjOKySUnNySxLLdK3S+DK+HComaWgybji2HWTBsbfyl2MnBwSAiYSi/7M
	ZoawxSQu3FvP1sXIxSEkMJ1R4nfbMRYI5xejxPWr15lAqtgE1CS+fDnMDmKLCOhIrNi1lgmk
	iFngJaPEto5pUO3fmSQO7F/LAlLFKRAs8X7rIlYQW1ggVGLanKlg+1gEVCV2H74KVMPBwStg
	K/HzuQVImFdAUOLH5HtgrcwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uxA1GEn/uHmOFKBGR
	2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNrP
	pHcwrmqwOMQowMGoxMP7wkwiQIg1say4MvcQowQHs5IIr1oEUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjivifdXfyGB9MSS1OzU1ILUIpgsEwenVANjplDoCQ2LiUsfhwRYaIQYxv0XSu91juQO
	5f89Ze+03TOzEjvDivefe5LoaLPVfecf3ustzvVLlD8dfRoSw6EY9CskbYlH8Jzo4CdZIbtW
	P270amPeE6GTJrDM7LrBV9d/K5/137638/v+TRZPbqRLWnz7LLQuOmWx1t76n981/W02Ovfo
	pO1RYinOSDTUYi4qTgQAKhE5NWkCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 01, 2012 1:38 PM Sachin Kamat wrote:
> 
> On 1 August 2012 10:00, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Wednesday, August 01, 2012 1:00 PMSachin Kamat wrote:
> >>
> >> On 1 August 2012 04:51, Jingoo Han <jg1.han@samsung.com> wrote:
> >> > On Wednesday, August 01, 2012 1:39 AM Damien Cassou wrote:
> >> >>
> >> >> From: Damien Cassou <damien.cassou@lifl.fr>
> >> >>
> >> >> The various devm_ functions allocate memory that is released when a driver
> >> >> detaches.  This patch uses these functions for data that is allocated in
> >> >> the probe function of a platform device and is only freed in the remove
> >> >> function.
> >> >>
> >> >> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
> >> >>
> >> >> ---
> >> >>  drivers/video/exynos/exynos_dp_core.c |   27 +++++++--------------------
> >> >>  1 file changed, 7 insertions(+), 20 deletions(-)
> >> >>
> >> >> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> >> >> index c6c016a..00fe4f0 100644
> >> >> --- a/drivers/video/exynos/exynos_dp_core.c
> >> >> +++ b/drivers/video/exynos/exynos_dp_core.c
> >> >> @@ -872,7 +872,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >> >>
> >> >>       dp->dev = &pdev->dev;
> >> >>
> >> >> -     dp->clock = clk_get(&pdev->dev, "dp");
> >> >> +     dp->clock = devm_clk_get(&pdev->dev, "dp");
> >> >>       if (IS_ERR(dp->clock)) {
> >> >>               dev_err(&pdev->dev, "failed to get clock\n");
> >> >>               return PTR_ERR(dp->clock);
> >> >> @@ -881,31 +881,24 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >> >>       clk_enable(dp->clock);
> >> >>
> >> >>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> >> -     if (!res) {
> >> >> -             dev_err(&pdev->dev, "failed to get registers\n");
> >> >> -             ret = -EINVAL;
> >> >> -             goto err_clock;
> >> >> -     }
> >> >
> >> > Why do you remove this return check?
> >> > If there is no reason, please, do it as follows:
> >> >
> >> >         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> >         if (!res) {
> >> >                 dev_err(&pdev->dev, "failed to get registers\n");
> >> > -               ret = -EINVAL;
> >> > -               goto err_clock;
> >> > +               return -EINVAL;
> >> >         }
> >> >
> >> >
> >>
> >> devm_request_and_ioremap function checks the validity of res. Hence
> >> this check above is redundant and can be removed.
> >
> >
> > I don't think so.
> > Even though function called next checks the NULL value,
> > for robustness, the return value of platform_get_resource() should be
> > checked.
> >
> > It is possible that devm_request_and_ioremap() can be changed in the future,
> > as request_mem_region() & ioremap() were changed to devm_request_and_ioremap().
> 
> They are not changed. They still exist.  devm_request_and_ioremap() is
> an additional function provided for device managed resources.


OK, I see. I accept it.
Anyway it is simpler.


> 
> 
> >
> >
> > Best regards,
> > Jingoo Han
> >
> >
> >>
> >> Damien,
> >> This patch only adds devm_clk_get() function. Hence you could make the
> >> subject line more specific.
> >>
> >>
> >>
> >>
> >> > Best regards,
> >> > Jingoo Han
> >> >
> >> >
> >> >>
> >> >>       dp->reg_base = devm_request_and_ioremap(&pdev->dev, res);
> >> >>       if (!dp->reg_base) {
> >> >>               dev_err(&pdev->dev, "failed to ioremap\n");
> >> >> -             ret = -ENOMEM;
> >> >> -             goto err_clock;
> >> >> +             return -ENOMEM;
> >> >>       }
> >> >>
> >> >>       dp->irq = platform_get_irq(pdev, 0);
> >> >>       if (!dp->irq) {
> >> >>               dev_err(&pdev->dev, "failed to get irq\n");
> >> >> -             ret = -ENODEV;
> >> >> -             goto err_clock;
> >> >> +             return -ENODEV;
> >> >>       }
> >> >>
> >> >>       ret = devm_request_irq(&pdev->dev, dp->irq, exynos_dp_irq_handler, 0,
> >> >>                               "exynos-dp", dp);
> >> >>       if (ret) {
> >> >>               dev_err(&pdev->dev, "failed to request irq\n");
> >> >> -             goto err_clock;
> >> >> +             return ret;
> >> >>       }
> >> >>
> >> >>       dp->video_info = pdata->video_info;
> >> >> @@ -917,7 +910,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >> >>       ret = exynos_dp_detect_hpd(dp);
> >> >>       if (ret) {
> >> >>               dev_err(&pdev->dev, "unable to detect hpd\n");
> >> >> -             goto err_clock;
> >> >> +             return ret;
> >> >>       }
> >> >>
> >> >>       exynos_dp_handle_edid(dp);
> >> >> @@ -926,7 +919,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >> >>                               dp->video_info->link_rate);
> >> >>       if (ret) {
> >> >>               dev_err(&pdev->dev, "unable to do link train\n");
> >> >> -             goto err_clock;
> >> >> +             return ret;
> >> >>       }
> >> >>
> >> >>       exynos_dp_enable_scramble(dp, 1);
> >> >> @@ -940,17 +933,12 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
> >> >>       ret = exynos_dp_config_video(dp, dp->video_info);
> >> >>       if (ret) {
> >> >>               dev_err(&pdev->dev, "unable to config video\n");
> >> >> -             goto err_clock;
> >> >> +             return ret;
> >> >>       }
> >> >>
> >> >>       platform_set_drvdata(pdev, dp);
> >> >>
> >> >>       return 0;
> >> >> -
> >> >> -err_clock:
> >> >> -     clk_put(dp->clock);
> >> >> -
> >> >> -     return ret;
> >> >>  }
> >> >>
> >> >>  static int __devexit exynos_dp_remove(struct platform_device *pdev)
> >> >> @@ -962,7 +950,6 @@ static int __devexit exynos_dp_remove(struct platform_device *pdev)
> >> >>               pdata->phy_exit();
> >> >>
> >> >>       clk_disable(dp->clock);
> >> >> -     clk_put(dp->clock);
> >> >>
> >> >>       return 0;
> >> >>  }
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >>
> >>
> >> --
> >> With warm regards,
> >> Sachin
> >
> 
> 
> 
> --
> With warm regards,
> Sachin

