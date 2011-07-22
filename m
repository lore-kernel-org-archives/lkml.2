Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1GVMjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:39:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25275 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794Ab1GVMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:39:07 -0400
Message-ID: <4E296F65.1080904@dsn.okisemi.com>
Date: Fri, 22 Jul 2011 21:39:01 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] pch_uart: Add MSI support
References: <20110701223209.GA9581@kroah.com> <1309762711-8571-1-git-send-email-alexander.stein@systec-electronic.com>
In-Reply-To: <1309762711-8571-1-git-send-email-alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/04 15:58), Alexander Stein wrote:
> Signed-off-by: Alexander Stein<alexander.stein@systec-electronic.com>
> ---
> Hello Greg,
> 
> I'm sorry. This patch was based some other patches, like console support.
> 
> Changes in v3:
> * Rebased to current git master
> 
>   drivers/tty/serial/pch_uart.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 4652109..d3ba85b 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -1429,6 +1429,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>   		goto init_port_hal_free;
>   	}
> 
> +	pci_enable_msi(pdev);
> +
>   	iobase = pci_resource_start(pdev, 0);
>   	mapbase = pci_resource_start(pdev, 1);
>   	priv->mapbase = mapbase;
> @@ -1485,6 +1487,8 @@ static void pch_uart_pci_remove(struct pci_dev *pdev)
>   	struct eg20t_port *priv;
> 
>   	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
> +
> +	pci_disable_msi(pdev);
>   	pch_uart_exit_port(priv);
>   	pci_disable_device(pdev);
>   	kfree(priv);
> @@ -1568,6 +1572,7 @@ static int __devinit pch_uart_pci_probe(struct pci_dev *pdev,
>   	return ret;
> 
>   probe_disable_device:
> +	pci_disable_msi(pdev);
>   	pci_disable_device(pdev);
>   probe_error:
>   	return ret;


Using this patch, PCH_UART doesn't work all.
For using MSI, I think, need bus master enable(pci_set_master) ?

Best Regards,
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
