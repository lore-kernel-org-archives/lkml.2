Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1F1VwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:52:13 -0400
Received: from trinity.fluff.org ([89.16.178.74]:51323 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1F1VwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:52:06 -0400
Date: Tue, 28 Jun 2011 22:51:57 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-eg20t: Do not print error message if no ACK is
	received
Message-ID: <20110628215157.GL15795@trinity.fluff.org>
References: <1309254219-18875-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309254219-18875-1-git-send-email-alexander.stein@systec-electronic.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:43:39AM +0200, Alexander Stein wrote:
> Doing so would spam the kernel log for each i2cdetect run and
> device probe.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

ok, will add to fixes for -rc.

> ---
>  drivers/i2c/busses/i2c-eg20t.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
> index 8abfa4a..97110f7 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -345,7 +345,7 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
>  	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
>  
>  	if (reg_val != 0) {
> -		pch_err(adap, "return%d\n", -EPROTO);
> +		pch_dbg(adap, "return%d\n", -EPROTO);
>  		return -EPROTO;
>  	}
>  
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

