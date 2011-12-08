Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1LHOI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:08:29 -0500
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1059 "HELO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752084Ab1LHOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:08:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32681
Message-ID: <4EE0C4F1.9080607@metafoo.de>
Date: Thu, 08 Dec 2011 15:08:49 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 2/2] jz4740-battery: fix signedness bug
References: <1323349452.2823.1.camel@phoenix> <1323349526.2823.2.camel@phoenix>
In-Reply-To: <1323349526.2823.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 02:05 PM, Axel Lin wrote:
> wait_for_completion_interruptible_timeout() may return negative value.
> In this case, checking if (t > 0)  will return true if t is unsigned.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks


> ---
>  drivers/power/jz4740-battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 763f894..5bb1ddd 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -67,7 +67,7 @@ static irqreturn_t jz_battery_irq_handler(int irq, void *devid)
>  
>  static long jz_battery_read_voltage(struct jz_battery *battery)
>  {
> -	unsigned long t;
> +	long t;
>  	unsigned long val;
>  	long voltage;
>  

