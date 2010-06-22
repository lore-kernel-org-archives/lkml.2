Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0FVNfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:35:45 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:41869 "EHLO
	xyzzy.farnsworth.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab0FVNfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:35:44 -0400
X-Greylist: delayed 2898 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 09:35:44 EDT
Date: Tue, 22 Jun 2010 05:47:09 -0700
From: Dale Farnsworth <dale@farnsworth.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-ID: <20100622124709.GA6170@farnsworth.org>
References: <4C207DAF.7010200@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C207DAF.7010200@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] RTC/max6900: use rtc_valid_tm to check returning tm
	for max6900
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 05:09:03PM +0800, Wan ZongShun wrote:
> Use rtc_valid_tm to check returning tm for max6900,
> it can avoid returning wrong tm value.
> ---
>  drivers/rtc/rtc-max6900.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
> index a4f6665..486142c 100644
> --- a/drivers/rtc/rtc-max6900.c
> +++ b/drivers/rtc/rtc-max6900.c
> @@ -159,7 +159,7 @@ static int max6900_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
>  		      bcd2bin(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
>  	tm->tm_wday = bcd2bin(regs[MAX6900_REG_DW]);
> 
> -	return 0;
> +	return rtc_valid_tm(tm);
>  }
> 
>  static int max6900_i2c_clear_write_protect(struct i2c_client *client)

Ack.

Thanks,
-Dale
