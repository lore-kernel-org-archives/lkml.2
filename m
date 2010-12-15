Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0LOVaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:30:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0LOVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:30:22 -0500
Subject: Re: [PATCH] regulator: Allow modular build of mc13xxx-core
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yong Shen <yong.shen@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1292422225-27530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20101215140344.GF5723@sirena.org.uk>
	 <1292422225-27530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 21:30:16 +0000
Message-ID: <1292448616.3348.33.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 14:10 +0000, Mark Brown wrote:
> Since the MFD core for this device and the regulator drivers for these
> devices can be built modular we should also support modular build of
> the shared code for the regulator drivers, otherwise we try to link
> built in code against modular code with unfortunate results.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks Mark !

It looks like you sent the wrong patch as I had to also add :-

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index da46b3c..f53d31b 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -89,6 +89,7 @@ int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
 
        return mc13xxx_regulators[id].voltages[selector];
 }
+EXPORT_SYMBOL_GPL(mc13xxx_regulator_list_voltage);
 
 int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
                                                int min_uV, int max_uV)
@@ -232,6 +233,7 @@ int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev)
 {
        return 1;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_sw_regulator_is_enabled);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Yong Shen <yong.shen@linaro.org>");

To get it all building.

Now applied and squashed with above.

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

