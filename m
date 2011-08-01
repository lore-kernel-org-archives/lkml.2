Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1HAKwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:52:18 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:50875 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1HAKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:52:14 -0400
Message-ID: <4E368559.4000807@ge.com>
Date: Mon, 01 Aug 2011 11:52:09 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: vme_user: change kmalloc+memset to kzalloc
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312194053-32310-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2011 10:49:05.0033 (UTC) FILETIME=[A1D42F90:01CC5038]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 11:20, Manohar Vanga wrote:
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index 91d2cc7..3cbeb2a 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -651,7 +651,7 @@ static int __init vme_user_init(void)
>  
>  
>  	/* Dynamically create the bind table based on module parameters */
> -	ids = kmalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
> +	ids = kzalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
>  	if (ids == NULL) {
>  		printk(KERN_ERR "%s: Unable to allocate ID table\n",
>  			driver_name);
> @@ -659,8 +659,6 @@ static int __init vme_user_init(void)
>  		goto err_id;
>  	}
>  
> -	memset(ids, 0, (sizeof(struct vme_device_id) * (bus_num + 1)));
> -
>  	for (i = 0; i < bus_num; i++) {
>  		ids[i].bus = bus[i];
>  		/*


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
