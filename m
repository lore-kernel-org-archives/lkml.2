Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2GKPNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:13:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932748Ab2GKPNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:13:24 -0400
Message-ID: <1342019603.13724.65.camel@joe2Laptop>
Subject: Re: [PATCH v2] panel: Use pr_err(...) rather than printk(KERN_ERR
 ...)
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 08:13:23 -0700
In-Reply-To: <1341997147-25417-1-git-send-email-yamanetoshi@gmail.com>
References: <1341997147-25417-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:59 +0900, Toshiaki Yamane wrote:
> This change is inspired by checkpatch.

The changelog could be improved a bit.  Maybe:

Added pr_fmt.
Removed unnecessary OOM messages.
Removed embedded message prefixes.
Added __func__ to all pr_err messages.

> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
[]
> @@ -2110,10 +2110,8 @@ static void panel_attach(struct parport *port)
>  		return;
>  
>  	if (pprt) {
> -		printk(KERN_ERR
> -		       "panel_attach(): port->number=%d parport=%d, "
> -		       "already registered !\n",
> -		       port->number, parport);
> +		pr_err("%s: port->number=%d parport=%d, already registerd !\n",
> +		       __func__, port->number, parport);

typo of registered


