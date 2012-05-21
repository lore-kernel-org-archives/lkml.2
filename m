Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2EUXuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:50:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2EUXuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:50:01 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-19-4fbad4a80a1b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002d01cd3732$e667d7b0$b3378710$%han@samsung.com>
 <20120521095837.GE21033@localhost>
In-reply-to: <20120521095837.GE21033@localhost>
Subject: RE: [PATCH 3/3] backlight: lm3533_bl: use devm_ functions
Date: Tue, 22 May 2012 08:50:00 +0900
Message-id: <000401cd37ac$6f4444a0$4dcccde0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac03OE6ZvgM3LnEwQKmZ9knl00zDdgAc5CRA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd0VV3b5G7w8K2FxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy7l/9zV5wSaDiz/SjLA2Ms3i7GDk4JARMJNZ+U+li5AQyxSQu
	3FvP1sXIxSEksIhRYu3jl2wgCSGB2UwSx9dIgthsAmoSX74cZgexRYDsJ71H2EEamAWWMErM
	efmJEaIhSeJp9x4WEJtTQF9izr9uVhBbWMBJYk3HfLAaFgFViV2PjoIN4hWwlWj9eIoJwhaU
	+DH5Hlgvs4CWxPqdx5kgbHmJzWveMkMcrS7x6K8uxA1GEl9u/mOEKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMbPpHYwrmywOMQowMGo
	xMMbcGmXvxBrYllxZe4hRgkOZiUR3k1tQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8dot3+AsJ
	pCeWpGanphakFsFkmTg4pRoYGzRtuR1uXEvaOqNOvOmfUlfVHxcu/0ktk9KuKYU9fvvUTPPG
	336N9dP/HhIt+aavfOPSziQHrnyWTBmHmWn96/utzFI8GX1tN3RyCFk2rfn/vcfStu+QRa3K
	8sRvbz2yTt7WEf6XXiLhn3FuspLVUu6aKf8fpqlMlqyt1+OzkBDhEn43L16JpTgj0VCLuag4
	EQD/l2H1XwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06 6:59:00 PM +0900, Johan Hovol wrote:
>
> On Mon, May 21, 2012 at 06:20:01PM +0900, Jingoo Han wrote:
> > The devm_ functions allocate memory that is released when a driver
> > detaches. This patch uses devm_kzalloc of these functions.
> >
> > Cc: Johan Hovold <jhovold@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/video/backlight/lm3533_bl.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
> > index 0148227..9f96a6b 100644
> > --- a/drivers/video/backlight/lm3533_bl.c
> > +++ b/drivers/video/backlight/lm3533_bl.c
> > @@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
> >  		return -EINVAL;
> >  	}
> >
> > -	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
> > +	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
> >  	if (!bl) {
> >  		dev_err(&pdev->dev,
> >  				"failed to allocate memory for backlight\n");
> > @@ -318,7 +318,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
> >  	if (IS_ERR(bd)) {
> >  		dev_err(&pdev->dev, "failed to register backlight device\n");
> >  		ret = PTR_ERR(bd);
> > -		goto err_free;
> > +		goto err_return;
> 
> Why not simply return PTR_ERR(bd) here?

Yes, you're right.
I will send the new patch.
Thanks.

Best regards,
Jingoo Han

> 
> >  	}
> >
> >  	bl->bd = bd;
> > @@ -348,8 +348,7 @@ err_sysfs_remove:
> >  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
> >  err_unregister:
> >  	backlight_device_unregister(bd);
> > -err_free:
> > -	kfree(bl);
> > +err_return:
> 
> No need for this label then.
> 
> >
> >  	return ret;
> >  }
> > @@ -367,7 +366,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
> >  	lm3533_ctrlbank_disable(&bl->cb);
> >  	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
> >  	backlight_device_unregister(bd);
> > -	kfree(bl);
> >
> >  	return 0;
> >  }

