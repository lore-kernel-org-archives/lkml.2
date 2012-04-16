Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2DPBUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 21:20:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50247 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555Ab2DPBUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 21:20:05 -0400
X-Sasl-enc: ZH7Iu4czLoZJgIdQaJwhLkMvx/GHsZmtGID0/JFVO/CuH+CFHlvXXnYT9g 1334539202
Message-ID: <1334539199.2250.1.camel@perseus.themaw.net>
Subject: Re: [PATCH] fs/autofs4/dev-ioctl.c: add missing free_dev_ioctl
From: Ian Kent <raven@themaw.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, autofs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2012 09:19:59 +0800
In-Reply-To: <1334396928-17537-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1334396928-17537-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 11:48 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Free param as done in the other error-handling code.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Oops!
Acked-by: Ian Kent <raven@themaw.net>

> 
> ---
>  fs/autofs4/dev-ioctl.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index 9dacb85..f99c2ce 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -651,7 +651,8 @@ static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __use
>  	fn = lookup_dev_ioctl(cmd);
>  	if (!fn) {
>  		AUTOFS_WARN("unknown command 0x%08x", command);
> -		return -ENOTTY;
> +		err = -ENOTTY;
> +		goto out;
>  	}
>  
>  	fp = NULL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe autofs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


