Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2IUCdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:33:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55131 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2IUCdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:33:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237157951"
Message-ID: <505BD206.9070600@codeaurora.org>
Date: Thu, 20 Sep 2012 19:33:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] clk: Add devm_clk_{register,unregister}()
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org> <1348034730-16473-3-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1348034730-16473-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/12 23:05, Stephen Boyd wrote:
> +void devm_clk_unregister(struct device *dev, struct clk *clk)
> +{
> +	WARN_ON(devres_destroy(dev, devm_clk_release, devm_clk_match, clk));

Hm... I guess this needs to be devres_release() instead of destroy. Can
you squash this in or should I resend for the few character change?

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 6852809..f02f4fe 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1509,7 +1509,7 @@ static int devm_clk_match(struct device *dev, void *res, void *data)
  */
 void devm_clk_unregister(struct device *dev, struct clk *clk)
 {
-       WARN_ON(devres_destroy(dev, devm_clk_release, devm_clk_match, clk));
+       WARN_ON(devres_release(dev, devm_clk_release, devm_clk_match, clk));
 }
 EXPORT_SYMBOL(devm_clk_unregister);
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

