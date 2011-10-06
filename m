Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1JFHAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:00:33 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18143 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab1JFHAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:00:31 -0400
Message-ID: <4E8D5206.4080608@dsn.lapis-semi.com>
Date: Thu, 06 Oct 2011 16:00:22 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/7 v3] i2c-eg20t: delete 10bit access processing
References: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com> <1317884192-10694-4-git-send-email-tomoya-linux@dsn.lapis-semi.com>
In-Reply-To: <1317884192-10694-4-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/06 15:56), Tomoya MORINAGA wrote:

Previous [PATCH 3/7] is duplicated like below.
  [PATCH 3/7 v3] i2c-eg20t: delete 10bit access processing
  [PATCH 3/7 v1] i2c-eg20t: Fix 10bit access issue

Please ignore "[PATCH 3/7 v3] i2c-eg20t: delete 10bit access processing"
Sorry for the in inconvenience.

-- 
tomoya
ROHM Co., Ltd.

> From: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
> 
> Linux I2C core doesn't support 10bit access formally.
> Additionally, we can't test with 10bit mode.
> This patch deletes the 10bit access processing.
> 
> Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.lapis-semi.com>
> ---
>   drivers/i2c/busses/i2c-eg20t.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
> index c5b9924..aa1705e 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -410,7 +410,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
>   	}
> 
>   	if (msgs->flags&  I2C_M_TEN) {
> -		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7);
> +		addr_2_msb = ((addr&  I2C_MSB_2B_MSK)>>  7)&  0x06;
>   		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
>   		if (first)
>   			pch_i2c_start(adap);
> @@ -515,7 +515,6 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
>   	if (msgs->flags&  I2C_M_TEN) {
>   		addr_2_msb = (((addr&  I2C_MSB_2B_MSK)>>  7) | (I2C_RD));
>   		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> -
>   	} else {
>   		/* 7 address bits + R/W bit */
>   		addr = (((addr)<<  1) | (I2C_RD));

