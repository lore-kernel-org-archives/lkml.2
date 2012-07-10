Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2GKAHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:07:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33131 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756238Ab2GKAHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:07:00 -0400
Message-ID: <1341953954.6118.167.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] panel: Use pr_err(...) rather than printk(KERN_ERR
 ...)
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org
In-Reply-To: <1341919515-8909-1-git-send-email-yamanetoshi@gmail.com>
References: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
	 <1341919515-8909-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 13:59:14 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 20:25 +0900, Toshiaki Yamane wrote:
> This change is inspired by checkpatch.

[]

Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include

and remove the "panel: " prefixes from output messages.

> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
[]
> @@ -1987,7 +1987,7 @@ static struct logical_input *panel_bind_key(char *name, char *press,
>  
>  	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
>  	if (!key) {
> -		printk(KERN_ERR "panel: not enough memory\n");
> +		pr_err("panel: not enough memory\n");

OOM messages are duplicative and unnecessary.
alloc failures get a dump_stack.

[]

> @@ -2109,8 +2109,7 @@ static void panel_attach(struct parport *port)
>  		return;
>  
>  	if (pprt) {
> -		printk(KERN_ERR
> -		       "panel_attach(): port->number=%d parport=%d, "
> +		pr_err("panel_attach(): port->number=%d parport=%d, "
>  		       "already registered !\n",

Please coalesce formats and use "%s: ...", __func__ when there
is an embedded function name.  It'd also be nice to use argument
alignment to open parenthesis.

		pr_err("%s: port->number=%d parport=%d, already registered\n",
		       port->number, parport);


etc...

cheers, Joe

