Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2CJJif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 04:38:35 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:62227 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2CJJib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 04:38:31 -0500
Message-ID: <4F5B2113.3060103@bfs.de>
Date: Sat, 10 Mar 2012 10:38:27 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] spi: release lock on error path in spi_pump_messages()
References: <20120310085729.GB4647@elgon.mountain>
In-Reply-To: <20120310085729.GB4647@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 10.03.2012 09:57, schrieb Dan Carpenter:
> We should release the lock here and enable IRQs before returning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 5ae1e84..ab1bdce 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -535,6 +535,7 @@ static void spi_pump_messages(struct kthread_work *work)
>  			if (ret) {
>  				dev_err(&master->dev,
>  					"failed to unprepare transfer hardware\n");
> +				spin_unlock_irqrestore(&master->queue_lock, flags);
>  				return;
>  			}
>  		}


hi Dan,
do you want to protect dev_err() by a spn_lock ?

re,
 wh

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
