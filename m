Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2L0O4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:56:45 -0500
Received: from mout.gmx.net ([212.227.15.19]:61550 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2L0O4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:56:42 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+UPWU4p5OUWYmi8S38BFaG8NNfu2ik7q/915abQ2
	MPrdABLwcCZ9i+
From: Marc Dietrich <marvin24@gmx.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linuxfoundation.org, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS6586x
Date: Thu, 27 Dec 2012 15:56:32 +0100
Message-ID: <7345841.MepJzddHFh@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1356102748-722-1-git-send-email-ldewangan@nvidia.com>
References: <1356102748-722-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Friday 21 December 2012 20:42:28 you wrote:
> Add an RTC driver for TPS6586X chips by TI.
> This driver supports:
> - Setting and getting time and date.
> - Setting and reading alarm time.
> - Alarm and interrupt functionlity.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Remove WARN flag, just returning error is fine.
> - Register interrupt after rtc device register.
> 
>  drivers/rtc/Kconfig        |    8 +
>  drivers/rtc/Makefile       |    1 +
>  drivers/rtc/rtc-tps6586x.c |  356
> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 365
> insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-tps6586x.c
> 
....
>
> diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
> new file mode 100644
> index 0000000..d9a50a0
> --- /dev/null
> +++ b/drivers/rtc/rtc-tps6586x.c
....
>
> +static int tps6586x_rtc_probe(struct platform_device *pdev)
> +{
> +	struct device *tps_dev = to_tps6586x_dev(&pdev->dev);
> +	struct tps6586x_rtc *rtc;
> +	int ret;
> +
> +	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
> +	if (!rtc)
> +		return -ENOMEM;
> +
> +	rtc->dev = &pdev->dev;
> +	rtc->irq = platform_get_irq(pdev, 0);
> +
> +	/* Set epoch start as 00:00:00:01:01:2000 */
> +	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);

any reason why you hard coded it to 2000? All boards I know use 2009, so with 
this patch, everyone needs to set his clock again.

Marc

