Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab1F3QFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:05:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57587 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751252Ab1F3QFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:05:05 -0400
Date: Thu, 30 Jun 2011 09:05:02 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassi.brar@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com,
        Ben Dooks <ben-linux@fluff.org>, Seungwhan Youn <sw.youn@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 1/6] Samsung SoC ADC: use regulator (VDD for ADC).
Message-ID: <20110630160501.GG3249@opensource.wolfsonmicro.com>
References: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
 <1309420175-10301-2-git-send-email-myungjoo.ham@samsung.com>
 <201106301122.50800.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106301122.50800.anarsoul@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 11:22:50AM +0300, Vasily Khoruzhick wrote:
> On Thursday 30 June 2011 10:49:30 MyungJoo Ham wrote:

> > +	adc->vdd = regulator_get(dev, "vdd");
> > +	if (IS_ERR(adc->vdd)) {
> > +		dev_err(dev, "operating without regulator \"vdd\" .\n");
> > +		ret = PTR_ERR(adc->vdd);
> > +		goto err_alloc;
> > +	}
> > +

> NACK. Make it optional, otherwise it breaks s3c24xx.

No, the above code is how the regulator API should be used.  The API
will stub itself out if not in use so unless the s3c24xx platforms are
using regulators and there's a couple of options in the regulator API
for handling partially defined hookups of regulators on the board.

If there isn't a separate supply for the regulators on S3C24xx devices
then I guess the best option is to provide that supply as a dummy
regulator in the s3c24xx core code.
