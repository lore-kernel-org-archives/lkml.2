Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0HIIXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:23:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab0HIIXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:23:36 -0400
Subject: Re: [PATCH 1/2 RESEND] regulator: lp3971 - remove unnecessary ret
 value checking in lp3971_i2c_write()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1281053354.12131.4.camel@mola>
References: <1281053354.12131.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 09:23:31 +0100
Message-ID: <1281342211.3035.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 08:09 +0800, Axel Lin wrote:
> We already check count value before calling i2c_smbus_read_byte_data(),
> no need to check it again.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> This resend adds regulator: prefix in the subject line.
> 
>  drivers/regulator/lp3971.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
> index d4d9822..3bb82b6 100644
> --- a/drivers/regulator/lp3971.c
> +++ b/drivers/regulator/lp3971.c
> @@ -377,7 +377,7 @@ static int lp3971_i2c_read(struct i2c_client *i2c, char reg, int count,
>  	if (count != 1)
>  		return -EIO;
>  	ret = i2c_smbus_read_byte_data(i2c, reg);
> -	if (ret < 0 || count != 1)
> +	if (ret < 0)
>  		return -EIO;
>  
>  	*dest = ret;

Applied 1/2 only as 2/2 is the same patch.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

