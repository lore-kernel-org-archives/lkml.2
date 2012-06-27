Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2F0O6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:58:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64810 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2F0O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:58:46 -0400
From: Lekensteyn <lekensteyn@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc fix for 3.5] mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq
Date: Wed, 27 Jun 2012 16:58:35 +0200
Message-ID: <67041533.Myjsgf8nbb@al>
User-Agent: KMail/4.8.4 (Linux/3.5.0-1-custom; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1340806460-21646-1-git-send-email-tomas.winkler@intel.com>
References: <1340806460-21646-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2012 17:14:20 Tomas Winkler wrote:
> when the default irq quick handler is used then IRQF_ONESHOT must be set
> otherwise the request fails and following error is displayed:
> 
> mei 0000:00:16.0: irq 48 for MSI/MSI-X
> genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 48
> mei 0000:00:16.0: request_threaded_irq failed: irq = 48.
> dpm_run_callback(): pci_pm_resume+0x0/0x140 returns -22
> PM: Device 0000:00:16.0 failed to resume async: error -22
> 
> Reported-by: Lekensteyn <lekensteyn@gmail.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Peter Wu <lekensteyn@gmail.com>

(for the real name policy, if you prefer "Lekensteyn", it's fine too)

> ---
>  drivers/misc/mei/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index 7de1389..783fcd7 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -1147,7 +1147,7 @@ static int mei_pci_resume(struct device *device)
>  		err = request_threaded_irq(pdev->irq,
>  			NULL,
>  			mei_interrupt_thread_handler,
> -			0, mei_driver_name, dev);
> +			IRQF_ONESHOT, mei_driver_name, dev);
>  	else
>  		err = request_threaded_irq(pdev->irq,
>  			mei_interrupt_quick_handler,
