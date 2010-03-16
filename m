Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab0CPQ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:57:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab0CPQ56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:57:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=W+ldQUptVFBxvz2YVeKC5Xwksb/pjxKYIkanfJH4BENSXPdxtR2v7h6h4HiDPG2Z2
	LH4YGLGbu4bXKi3NgE0Sw==
MIME-Version: 1.0
In-Reply-To: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
References: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
From: Laurent Chavey <chavey@google.com>
Date: Tue, 16 Mar 2010 09:57:34 -0700
Message-ID: <97949e3e1003160957q377b3e78g25dc095fc835f65d@mail.gmail.com>
Subject: Re: [PATCH 1/1] NET: netpoll, fix potential NULL ptr dereference
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Daniel Borkmann <danborkmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: chavey@google.com

On Tue, Mar 16, 2010 at 8:29 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Stanse found that one error path in netpoll_setup dereferences npinfo
> even though it is NULL. Avoid that by adding new label and go to that
> instead.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Daniel Borkmann <danborkmann@googlemail.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/core/netpoll.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 7aa6972..d4ec38f 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -735,7 +735,7 @@ int netpoll_setup(struct netpoll *np)
>                npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
>                if (!npinfo) {
>                        err = -ENOMEM;
> -                       goto release;
> +                       goto put;
>                }
>
>                npinfo->rx_flags = 0;
> @@ -845,7 +845,7 @@ int netpoll_setup(struct netpoll *np)
>
>                kfree(npinfo);
>        }
> -
> +put:
>        dev_put(ndev);
>        return err;
>  }
> --
> 1.7.0.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
