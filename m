Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1EPUTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:19:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57574 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1EPUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:19:14 -0400
Subject: Re: [PATCH RESEND] mfd: Fix off-by-one value range checking for
 tps65910_i2c_write
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1305555542.2337.3.camel@phoenix>
References: <1305555542.2337.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:19:10 +0100
Message-ID: <1305577150.3156.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 22:19 +0800, Axel Lin wrote:
> If bytes == (TPS65910_MAX_REGISTER + 1), we have a buffer overflow when
> doing memcpy(&msg[1], src, bytes).
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/tps65910.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index bf649cf..e318248 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -71,7 +71,7 @@ static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
>  	u8 msg[TPS65910_MAX_REGISTER + 1];
>  	int ret;
>  
> -	if (bytes > (TPS65910_MAX_REGISTER + 1))
> +	if (bytes > TPS65910_MAX_REGISTER)
>  		return -EINVAL;
>  
>  	msg[0] = reg;

Applied.

