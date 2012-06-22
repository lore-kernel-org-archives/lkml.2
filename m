Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279Ab2FVF4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:56:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233Ab2FVF4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:56:16 -0400
Date: Fri, 22 Jun 2012 07:56:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Cc: kernel@pengutronix.de
Subject: Re: [PATCH RESEND] of: add const to struct of_device_id.data
Message-ID: <20120622055613.GL5642@pengutronix.de>
References: <1335171381-24869-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120607102014.GI22191@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120607102014.GI22191@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 12:20:14PM +0200, Uwe Kleine-König wrote:
> Drivers should never need to modify the data of a device id. So it can
> be const which in turn allows more consts in the driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> (Cc += lkml + Grant)
> 
> Hello,
> 
> this might introduce warnings in drivers that access the data member
> without using const, so this is definitly merge window material if it is
> considered at all.
ping

Best regards
Uwe

>  include/linux/mod_devicetable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 501da4c..183f411 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -222,7 +222,7 @@ struct of_device_id
>  	char	type[32];
>  	char	compatible[128];
>  #ifdef __KERNEL__
> -	void	*data;
> +	const void *data;
>  #else
>  	kernel_ulong_t data;
>  #endif
> -- 
> 1.7.10
> 
> 
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
