Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2IRBoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:44:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62758 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2IRBoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:44:07 -0400
Message-ID: <5057D1E1.60507@gmail.com>
Date: Tue, 18 Sep 2012 11:44:01 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 1/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-2-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347890294-28467-2-git-send-email-shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/12 23:58, Shubhrajyoti D wrote:
>     Convert the struct i2c_msg initialization to C99 format. This makes
>     maintaining and editing the code simpler. Also helps once other fields
>     like transferred are added in future.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/rtc/rtc-ds1672.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
> index 7fa67d0..b44b2a1 100644
> --- a/drivers/rtc/rtc-ds1672.c
> +++ b/drivers/rtc/rtc-ds1672.c
> @@ -37,8 +37,18 @@ static int ds1672_get_datetime(struct i2c_client *client, struct rtc_time *tm)
>  	unsigned char buf[4];
>  
>  	struct i2c_msg msgs[] = {
> -		{client->addr, 0, 1, &addr},	/* setup read ptr */
> -		{client->addr, I2C_M_RD, 4, buf},	/* read date */
> +		{
> +			.addr = client->addr,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &addr
> +		},	/* setup read ptr */

It would be nice to tabify the fields, and put the comments on their own
lines while you are here. With the C99 format you can also omit fields
which are initialised to zero. Like this:

		{
			/* Setup read pointer */
			.addr	= client->addr,
			.len	= 1,
			.buf	= &addr,
		},

~Ryan


