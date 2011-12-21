Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1LUEHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:07:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52332 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LUEHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:07:03 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-be-4ef15b66fdfd
From: Kukjin Kim <kgene.kim@samsung.com>
To: jhbird.choi@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>, jhbird.choi@gmail.com
References: <1323829221-14171-1-git-send-email-jhbird.choi@samsung.com>
In-reply-to: <1323829221-14171-1-git-send-email-jhbird.choi@samsung.com>
Subject: RE: [RESEND PATCH] ARM: SAMSUNG: Add s3c_setparent_clksrc in
 s3c_set_clksrc
Date: Wed, 21 Dec 2011 13:07:01 +0900
Message-id: <061a01ccbf95$fe1e6960$fa5b3c20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy65qWSLQgrCey/QLqSyIqVV4QUCgAs7CRw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jhbird.choi@samsung.com wrote:
> 
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Currently we have to run clk_set_parent to change clock source.
> But if there are sources & parent defined, it means we will select a
> parent
> in multiple clock sources. So sources & parent are already defined,
> set the parent clock int s3c_set_clksrc.
> Then we can reduce many clk_set_parent function in driver or setup_clock
> function.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  arch/arm/plat-samsung/clock-clksrc.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/clock-clksrc.c b/arch/arm/plat-
> samsung/clock-clksrc.c
> index ae8b850..61dfe0d 100644
> --- a/arch/arm/plat-samsung/clock-clksrc.c
> +++ b/arch/arm/plat-samsung/clock-clksrc.c
> @@ -140,6 +140,14 @@ void __init_or_cpufreq s3c_set_clksrc(struct
> clksrc_clk *clk, bool announce)
>  		return;
>  	}
> 
> +	if (clk->sources && clk->clk.parent) {
> +		if (s3c_setparent_clksrc(&clk->clk, clk->clk.parent)) {
> +			printk(KERN_ERR "%s: bad source is %s\n",
> +					clk->clk.name, clk->clk.parent->name);
> +			return;
> +		}
> +	}
> +
>  	clksrc = __raw_readl(clk->reg_src.reg);
>  	clksrc &= mask;
>  	clksrc >>= clk->reg_src.shift;
> --
> 1.7.1

Hmm, I think, this  is not good. If there is a mux which includes clock sources, as you know, its parent clock can be selected
according to the value of reg_src and it should be changed by calling clk_set_parent() even though this can help in some kind of
view. And the clksrc_clk depends on SoC not board so the clk.parent cannot be fixed at the clock.c file.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

