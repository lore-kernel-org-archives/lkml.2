Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2BAKnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:43:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2BAKnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:43:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
Date: Wed, 1 Feb 2012 05:43:50 -0500
Message-ID: <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com>
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized to 0
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 5:39 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> We declare 'exact' without initializing it and then do:
>
> [...]
>        if (strlen(p->cru_driver_name))
>                exact = 1;
>
>        if (priority && !exact)
>                return -EINVAL;
>
> [...]
>
> If the first 'if' is not true, then the second will test an
> uninitialized 'exact'.

not needed . as the cru_driver_name will always be present :).
> As far as I can tell, what we want is for 'exact' to be initialized to
> 0 (zero/false).
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  crypto/crypto_user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>  Compile tested only.
>
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index 16f8693..36a2af7 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -304,7 +304,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
>                          struct nlattr **attrs)
>  {
> -       int exact;
> +       int exact = 0;
>        const char *name;
>        struct crypto_alg *alg;
>        struct crypto_user_alg *p = nlmsg_data(nlh);
> --
> 1.7.8.4
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
