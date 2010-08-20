Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab0HTJDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:03:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41579 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167Ab0HTJDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:03:16 -0400
References: <1282269518.31048.2.camel@mola> (sfid-20100820_025559_952196_DC42F756)
Message-Id: <1DE04AB3-1B9A-4962-8A13-AFC74A898D80@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1282269518.31048.2.camel@mola> (sfid-20100820_025559_952196_DC42F756)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B500)
Mime-Version: 1.0 (iPad Mail 7B500)
Subject: Re: [PATCH 1/4] regulator/wm831x-dcdc: fix potential NULL dereference
Date: Fri, 20 Aug 2010 10:03:32 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Aug 2010, at 02:58, Axel Lin <axel.lin@gmail.com> wrote:

> pdata is dereferenced earlier than tested for being NULL.
> Thus move the dereference of "pdata" below the check for NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> drivers/regulator/wm831x-dcdc.c |   36 ++++++++++++++++++++++++------------
> 1 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
> index dbfaf59..ed66fac 100644
> --- a/drivers/regulator/wm831x-dcdc.c
> +++ b/drivers/regulator/wm831x-dcdc.c
> @@ -501,14 +501,17 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
> {
>  	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
>  	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
> -	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);

ARRAY_SIZE() isn't actually a dereference, it's evaluated at compile time.