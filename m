Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2HHKsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:48:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50347 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2HHKsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:48:02 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-78-502243be4337
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Anton Vorontsov'" <anton.vorontsov@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: "'John Stultz'" <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Sascha Hauer'" <kernel@pengutronix.de>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
References: <20120805230238.GA1663@lizard>
 <1344207819-3415-2-git-send-email-anton.vorontsov@linaro.org>
In-reply-to: <1344207819-3415-2-git-send-email-anton.vorontsov@linaro.org>
Subject: RE: [PATCH 2/9] ARM: plat-s3c24xx: Don't use FIQ_START
Date: Wed, 08 Aug 2012 19:47:26 +0900
Message-id: <0af201cd7553$3346dd70$99d49850$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zXv4Nk/NdkUpOQE6Z1HjghOL/jwB856QA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd19zkoBBr2LLSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/GW/2QqucVTMesfTwNjI3sXIwSEhYCKxa35OFyMnkCkmceHe
	ejYQW0hgEaPEs/dOXYxcQPY8Jolz0+cwgSTYBDQkDr9/xg5iiwjESsyadosFpIhZoINZYtXC
	P1DdWRIXp61mBrE5Bbwkzv26DtYsLGAv0XRlB1icRUBVYv+xW2A2r4CtxJFLDawQtqDEj8n3
	WEBsZgEtifU7jzNB2PISm9e8ZYY4Wl3i0V9diBuMJI7uXQ1VIiKx78U7xgmMQrOQTJqFZNIs
	JJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4iJ9J72Bc1WBxiFGAg1GJh3dT
	qmKAEGtiWXFl7iFGCQ5mJRHePQeBQrwpiZVVqUX58UWlOanFhxilOViUxHlNvL/6CwmkJ5ak
	ZqemFqQWwWSZODilGhg31nxt5nW5wev/htG7kWdjjMFWvS2d87z5Ml08PI/qv37kMt9u3XMv
	phKhh56+T/V8+UV5y6fs1NnPqnmtaKtq3rd9z1WzthXMkzvAZ2Nx/N7JcrElV6anR26P5RbR
	6Xx7d2PjrDXnXMoFP62V2iX9fGaYZNNs4fpTWbb7Dz90fCzXbam+3UWJpTgj0VCLuag4EQDc
	iBXPXgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> 
> We're about to remove FIQ_START mess, so move the platform-specific
> detail inside platform-specific s3c24xx_set_fiq().
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

BTW, how was going on the 'change FIQ_START to a variable' patch from Shawn
Guo?
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/106486.html

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


> ---
>  arch/arm/plat-s3c24xx/irq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
> index fe57bbb..e4e9567 100644
> --- a/arch/arm/plat-s3c24xx/irq.c
> +++ b/arch/arm/plat-s3c24xx/irq.c
> @@ -503,7 +503,7 @@ int s3c24xx_set_fiq(unsigned int irq, bool on)
>  	unsigned offs;
> 
>  	if (on) {
> -		offs = irq - FIQ_START;
> +		offs = irq - IRQ_EINT0;
>  		if (offs > 31)
>  			return -EINVAL;
> 
> --
> 1.7.10.4

