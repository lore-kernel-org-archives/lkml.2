Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2CIDAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:00:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49536 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab2CIDAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:00:17 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
References: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 9 Mar 2012 10:59:56 +0800
Message-ID: <CAF+7xWmDUhzuaPXuGRsr2b4ZjCjxgwpv0hpvMrGqNz3gjUeW0A@mail.gmail.com>
Subject: Re: [PATCH v10] Regulator: Add Anatop regulator driver
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if (anatop_reg->control_reg) {
> +               sel = (uv - anatop_reg->min_voltage) / 25000;

sel = DIV_ROUND_UP(uv - anatop_reg->min_voltage, 25000);

Use DIV_ROUND_UP to avoid the possible truncate of integer division.
This ensures the selected volatge falls within the specified range.


> +static int __devexit anatop_regulator_remove(struct platform_device *pdev)
> +{
> +       struct regulator_dev *rdev = platform_get_drvdata(pdev);
> +       struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
> +       kfree(sreg->name);
> +       regulator_unregister(rdev);
Do regulator_unregister before kfree sreg->name.
