Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2HZQWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:22:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60963 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2HZQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:22:12 -0400
Message-ID: <503A4D04.2050303@iki.fi>
Date: Sun, 26 Aug 2012 19:21:24 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, awalls@md.metrocast.net
Subject: Re: [PATCH] drivers/media/dvb-frontends/rtl2830.c: correct double
 assignment
References: <1345997751-340-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345997751-340-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 07:15 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> The double assignment is meant to be a bit-or to combine two values.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression i;
> @@
>
> *i = ...;
>   i = ...;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>   drivers/media/dvb-frontends/rtl2830.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
> index 8fa8b08..b6ab858 100644
> --- a/drivers/media/dvb-frontends/rtl2830.c
> +++ b/drivers/media/dvb-frontends/rtl2830.c
> @@ -254,7 +254,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
>   		goto err;
>
>   	buf[0] = tmp << 6;
> -	buf[0] = (if_ctl >> 16) & 0x3f;
> +	buf[0] |= (if_ctl >> 16) & 0x3f;
>   	buf[1] = (if_ctl >>  8) & 0xff;
>   	buf[2] = (if_ctl >>  0) & 0xff;
>
>
Thank you!

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


Antti
-- 
http://palosaari.fi/
