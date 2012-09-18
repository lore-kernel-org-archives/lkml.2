Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2IRBp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:45:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52654 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2IRBp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:45:26 -0400
Message-ID: <5057D22E.8080202@gmail.com>
Date: Tue, 18 Sep 2012 11:45:18 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 3/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com>
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
>  drivers/rtc/rtc-isl1208.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
> index dd2aeee..c3a76ae 100644
> --- a/drivers/rtc/rtc-isl1208.c
> +++ b/drivers/rtc/rtc-isl1208.c
> @@ -68,9 +68,9 @@ isl1208_i2c_read_regs(struct i2c_client *client, u8 reg, u8 buf[],
>  {
>  	u8 reg_addr[1] = { reg };
>  	struct i2c_msg msgs[2] = {
> -		{client->addr, 0, sizeof(reg_addr), reg_addr}
> +		{.addr = client->addr, .flags = 0, .len = sizeof(reg_addr), .buf = reg_addr}
>  		,

Putting the whole initialiser on one line is a bit ugly. Any reason not
to expand it over multiple lines as the previous patch (and majority of
other drivers) does?

~Ryan

