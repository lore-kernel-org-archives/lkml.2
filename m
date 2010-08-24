Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0HXGiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 02:38:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59544 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab0HXGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 02:38:21 -0400
X-Sasl-enc: XE4IoyuCfBEtwYWyCRS3qdgLIG6wUZaTnSrHOj1I7yFT 1282631900
Message-ID: <4C7368E4.30501@ladisch.de>
Date: Tue, 24 Aug 2010 08:38:28 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] HPET: unmap unused I/O space
References: <1282595278-22226-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1282595278-22226-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> When the initialization code in hpet founds a memory resource and does
> not found IRQ, it does not unmap the memory resource previously
> mapped.
> [...]
> Since I got no reply previously, fix this by simply unmapping the
> space when IRQ is not found and memory region was mapped previously.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> ---
>  drivers/char/hpet.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -1017,6 +1017,8 @@ static int hpet_acpi_add(struct acpi_device *device)
>  		return -ENODEV;
>  
>  	if (!data.hd_address || !data.hd_nirqs) {
> +		if (data.hd_address)
> +			iounmap(data.hd_address);
>  		printk("%s: no address or irqs in _CRS\n", __func__);
>  		return -ENODEV;
>  	}
