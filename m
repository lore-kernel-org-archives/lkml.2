Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1J3TQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 15:16:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61461 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1J3TQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 15:16:31 -0400
Message-ID: <4EADA289.8040200@mvista.com>
Date: Sun, 30 Oct 2011 21:16:25 +0200
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: JiSheng Zhang <jszhang3@gmail.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci_platform: add suspend & resume support
References: <20111030142122.560216e2@ustc>
In-Reply-To: <20111030142122.560216e2@ustc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30.10.2011 8:21, JiSheng Zhang wrote:

> Signed-off-by: JiSheng Zhang<jszhang3@gmail.com>
> ---
>   drivers/ata/ahci_platform.c |   54 +++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 54 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index c03277d..60ff9eb 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -202,12 +202,66 @@ static int __devexit ahci_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> +#ifdef CONFIG_PM
> +static int ahci_suspend(struct platform_device *pdev, pm_message_t mesg)
> +{
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);

    You can also call platform_get_drvdata(pdev).

> +static int ahci_resume(struct platform_device *pdev)
> +{
> +	struct device *dev =&pdev->dev;
> +	struct ahci_platform_data *pdata = dev->platform_data;

    There's dev_get_platdata().

WBR, Sergei

