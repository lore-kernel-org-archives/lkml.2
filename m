Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0IMNM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:12:57 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:44471 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab0IMNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:12:56 -0400
Message-ID: <4C8E2355.60807@tilera.com>
Date: Mon, 13 Sep 2010 09:12:53 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: <kernel-janitors@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mundt <lethal@linux-sh.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] char: hvc: check for error case
References: <1284317835-5086-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284317835-5086-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/12/2010 2:57 PM, Vasiliy Kulikov wrote:
> hvc_alloc() may fail, if so exit from init() with error.
>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Thanks, accepted into my tree (for the next merge window).  In practice all
this means is in debug mode we'll get a warning from do_one_initcall()
rather than silence, but you're right, it's technically better. :-)

> ---
>  I cannot compile this driver at all, so it is not tested.
>
>  drivers/char/hvc_tile.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hvc_tile.c b/drivers/char/hvc_tile.c
> index c4efb55..7a84a05 100644
> --- a/drivers/char/hvc_tile.c
> +++ b/drivers/char/hvc_tile.c
> @@ -61,7 +61,8 @@ console_initcall(hvc_tile_console_init);
>  
>  static int __init hvc_tile_init(void)
>  {
> -	hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
> -	return 0;
> +	struct hvc_struct *s;
> +	s = hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
> +	return IS_ERR(s) ? PTR_ERR(s) : 0;
>  }
>  device_initcall(hvc_tile_init);

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

