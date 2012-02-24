Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2BXWSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:18:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63506 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab2BXWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:18:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.201.196 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 14:18:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: christoph.mair@gmail.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: bmp085: Handle jiffies overflow correctly
Message-ID: <20120224221807.GA20680@kroah.com>
References: <1329672481-19583-1-git-send-email-bernhard@bwalle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1329672481-19583-1-git-send-email-bernhard@bwalle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 06:28:01PM +0100, Bernhard Walle wrote:
> By using the time_is_before_jiffies() macro instead of normal
> arithmetic, the jiffies overflow is handled correctly.
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/bmp085.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
> index b29a2be..7cfc598 100644
> --- a/drivers/misc/bmp085.c
> +++ b/drivers/misc/bmp085.c
> @@ -234,7 +234,8 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
>  	int status;
>  
>  	/* alt least every second force an update of the ambient temperature */
> -	if (data->last_temp_measurement + 1*HZ < jiffies) {
> +	if (data->last_temp_measurement == 0 ||
> +			time_is_before_jiffies(data->last_temp_measurement + 1*HZ)) {

This causes a complier warning:
drivers/misc/bmp085.c: In function ‘bmp085_get_pressure’:
drivers/misc/bmp085.c:238:4: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Care to send me a follow-on patch that fixes this?

thanks,

greg k-h
