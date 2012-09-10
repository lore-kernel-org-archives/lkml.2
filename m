Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2IJSsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:48:52 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:37777 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347Ab2IJSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:48:51 -0400
Date: Mon, 10 Sep 2012 20:48:47 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.mingarelli@hp.com, stable@vger.kernel.org
Subject: Re: [PATCH] hpwdt: Fix kdump issue in hpwdt
Message-ID: <20120910184847.GC27604@spo001.leaseweb.com>
References: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

> kdump can be interrupted by watchdog timer when the timer is left
> activated on the crash kernel. Changed the hpwdt driver to disable
> watchdog timer at boot-time. This assures that watchdog timer is
> disabled until /dev/watchdog is opened, and prevents watchdog timer
> to be left running on the crash kernel.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
> Cc: stable@vger.kernel.org 
> ---
>  drivers/watchdog/hpwdt.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
> index 1eff743..ae60406 100644
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
>  	hpwdt_timer_reg = pci_mem_addr + 0x70;
>  	hpwdt_timer_con = pci_mem_addr + 0x72;
>  
> +	/* Make sure that timer is disabled until /dev/watchdog is opened */
> +	hpwdt_stop();
> +
>  	/* Make sure that we have a valid soft_margin */
>  	if (hpwdt_change_timer(soft_margin))
>  		hpwdt_change_timer(DEFAULT_MARGIN);

Added to linux-watchdog-next .

Kind regards,
Wim.

