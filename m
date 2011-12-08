Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1LHOI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:08:26 -0500
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1085 "HELO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751994Ab1LHOIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:08:16 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8727
Message-ID: <4EE0C4E7.4050608@metafoo.de>
Date: Thu, 08 Dec 2011 15:08:39 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/2] hwmon: jz4740: fix signedness bug
References: <1323349452.2823.1.camel@phoenix>
In-Reply-To: <1323349452.2823.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 02:04 PM, Axel Lin wrote:
> wait_for_completion_interruptible_timeout() may return negative value.
> In this case, checking if (t > 0)  will return true if t is unsigned.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  drivers/hwmon/jz4740-hwmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
> index 7a48b1e..3d7e590 100644
> --- a/drivers/hwmon/jz4740-hwmon.c
> +++ b/drivers/hwmon/jz4740-hwmon.c
> @@ -59,7 +59,7 @@ static ssize_t jz4740_hwmon_read_adcin(struct device *dev,
>  {
>  	struct jz4740_hwmon *hwmon = dev_get_drvdata(dev);
>  	struct completion *completion = &hwmon->read_completion;
> -	unsigned long t;
> +	long t;
>  	unsigned long val;
>  	int ret;
>  

