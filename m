Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab0I0RcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:32:13 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3906 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab0I0RcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:32:12 -0400
Message-ID: <4CA0D516.9060404@caviumnetworks.com>
Date: Mon, 27 Sep 2010 10:32:06 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bernhard Walle <walle@corscience.de>
CC: khali@linux-fr.org, rade.bozic.ext@nsn.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: I2C: Return -ETIMEDOUT in octeon_i2c_wait() on
 timeout
References: <1285584916-21317-1-git-send-email-walle@corscience.de>
In-Reply-To: <1285584916-21317-1-git-send-email-walle@corscience.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 17:32:11.0145 (UTC) FILETIME=[EAA4FF90:01CB5E69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 03:55 AM, Bernhard Walle wrote:
> It doesn't make sense to set result to -ETIMEDOUT but return 0 (success)
> afterwards. Since there's code in octeon_i2c_start() to handle the
> error, it should be called.
>
> Signed-off-by: Bernhard Walle<walle@corscience.de>

Thanks for fixing this.

Acked-by: David Daney <ddaney@caviumnetworks.com>


> ---
>   drivers/i2c/busses/i2c-octeon.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
> index 0e9f85d..56dbe54 100644
> --- a/drivers/i2c/busses/i2c-octeon.c
> +++ b/drivers/i2c/busses/i2c-octeon.c
> @@ -218,7 +218,7 @@ static int octeon_i2c_wait(struct octeon_i2c *i2c)
>   		return result;
>   	} else if (result == 0) {
>   		dev_dbg(i2c->dev, "%s: timeout\n", __func__);
> -		result = -ETIMEDOUT;
> +		return -ETIMEDOUT;
>   	}
>
>   	return 0;

