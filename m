Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2GKBwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:52:18 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50091 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752186Ab2GKBwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:52:17 -0400
Message-ID: <4FFCDC54.8030408@marvell.com>
Date: Wed, 11 Jul 2012 09:52:20 +0800
From: Qiao Zhou <zhouqiao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: SamuelOrtiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Remove __devexit annotation for pm80x_deinit
References: <1341971280.25495.0.camel@phoenix>
In-Reply-To: <1341971280.25495.0.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2012 01:52:05.0607 (UTC) FILETIME=[C611AF70:01CD5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 09:48 AM, Axel Lin wrote:
> This fixes below section mismatch warning:
>
>    LD      drivers/mfd/built-in.o
> WARNING: drivers/mfd/built-in.o(.devinit.text+0x46c): Section mismatch in reference from the function pm800_probe() to the function .devexit.text:pm80x_deinit()
> The function __devinit pm800_probe() references
> a function __devexit pm80x_deinit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __devexit annotation of
> pm80x_deinit() so it may be used outside an exit section.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>   drivers/mfd/88pm80x.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
> index 62da342..cd0bf52 100644
> --- a/drivers/mfd/88pm80x.c
> +++ b/drivers/mfd/88pm80x.c
> @@ -91,7 +91,7 @@ err_regmap_init:
>   }
>   EXPORT_SYMBOL_GPL(pm80x_init);
>
> -int __devexit pm80x_deinit(struct i2c_client *client)
> +int pm80x_deinit(struct i2c_client *client)
>   {
>   	struct pm80x_chip *chip = i2c_get_clientdata(client);
>
>
Alex,

thanks again for the fixing, and would try to avoid such warning in future.

-- 

Best Regards
Qiao


