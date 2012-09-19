Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2ISTpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:45:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34584 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044Ab2ISTo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:44:59 -0400
Message-ID: <1348083898.2055.8.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: panel: Fixed a macro coding style issue
From: Joe Perches <joe@perches.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: willy@meta-x.org, gregkh@linuxfoundation.org, evel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 12:44:58 -0700
In-Reply-To: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com>
References: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 01:07 +0530, Adil Mujeeb wrote:
> Removed do {} while (0) loop for a single statement macros
> 
> Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
> ---
>  linux-3.6-rc6/drivers/staging/panel/panel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/linux-3.6-rc6/drivers/staging/panel/panel.c b/linux-3.6-rc6/drivers/staging/panel/panel.c
> index 39f9982..d9fec5b 100644
> --- a/linux-3.6-rc6/drivers/staging/panel/panel.c
> +++ b/linux-3.6-rc6/drivers/staging/panel/panel.c
> @@ -137,8 +137,8 @@
>  #define r_ctr(x)        (parport_read_control((x)->port))
>  #define r_dtr(x)        (parport_read_data((x)->port))
>  #define r_str(x)        (parport_read_status((x)->port))
> -#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
> -#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
> +#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
> +#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))

Unnecessary parentheses too.
It might be better to use static inlines instead.


