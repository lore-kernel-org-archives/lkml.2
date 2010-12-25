Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0LYVOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:14:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61497 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0LYVOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YZKuDecveVo25uVU/k+wLIRwP+R31FXry+Po0Fet2SHAWJgjD8JJe5NDXiMqGls0lD
         f+yx7vQgYH9RSfGI9vGWqtvjMA1cxbhY38o2JNL6VM9Jvw0oCL8RxePhOKoKloYfj0v+
         3f6IBRo3KYe68GFrX491kn8uhvI+jl7mQmJqg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012251908410.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012251908410.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 22:14:30 +0100
Message-ID: <AANLkTi=O=rKgXMBgMDRFZCCUSkqvHhZ+DkstSzWASVfQ@mail.gmail.com>
Subject: Re: [PATCH] Ceph: Fix use-after-free bug in ceph_messenger_destroy()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 7:11 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> In net/ceph/messenger.c::ceph_messenger_destroy() the pointer 'msgr' is
> freed by kfree() and subsequently used in a call to dout() - use after
> free bug.

As I sad before, %p reads only the address.

> Easily fixed by simply moving the kfree() call after the dout() call.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  messenger.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index b6ff4a1..26514a7 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -2131,8 +2131,8 @@ void ceph_messenger_destroy(struct ceph_messenger *msgr)
>        dout("destroy %p\n", msgr);
>        kunmap(msgr->zero_page);
>        __free_page(msgr->zero_page);
> -       kfree(msgr);
>        dout("destroyed messenger %p\n", msgr);
> +       kfree(msgr);
>  }
>  EXPORT_SYMBOL(ceph_messenger_destroy);
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,
//richard
