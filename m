Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0ICVrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:47:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15425 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0ICVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:47:42 -0400
Date: Sat, 04 Sep 2010 06:47:52 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] regulators: add support max8952 regulator
In-reply-to: <20100903094200.GC8381@sirena.org.uk>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Changhwan Youn'" <chaos.youn@samsung.com>, lrg@slimlogic.co.uk
Message-id: <01e301cb4bb1$ac1fa240$045ee6c0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActLTEXAHf2uWOLLTh2PsSwBRlF95wAZN9PA
References: <1283476524-12820-1-git-send-email-kgene.kim@samsung.com>
 <20100903094200.GC8381@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
Hi,

Thanks for your review.

> On Fri, Sep 03, 2010 at 10:15:24AM +0900, Kukjin Kim wrote:
> 
> > +	ret2 = max8649_reg_read(info->i2c, MAX8649_CHIP_ID2);
> > +	if (ret2 < 0) {
> > +		dev_err(info->dev, "Failed to detect ID of %s:%d\n",
> > +			id->name, ret2);
> >  		goto out;
> >  	}
> 
> If the read fails you'll not set an error code when you jump to out so
> the probe will report success.  It might be clearer to have separate id
> variables which you store the read values into if they're OK, just from
> a legibility point of view.
> 
Ok..will fix it.

> > -	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
> > +	dev_info(info->dev, "Detected %s (ID:%x %x)\n", id->name, ret,
ret2);
> > +
> > +	info->type = id->driver_data;
> 
> It'd be nice to check that the type that was supplied matches the ID
> read from the chip in case the user got things wrong, just for
> defensiveness.

Ok..will modify as per your suggestion.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

