Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0LYVQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:16:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57585 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0LYVQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=joPFgbwNsU8mKTqrmeOnUB3AWKp+YLKdnVdgoVw7O4lcqWimCdjPwLKUecaJaEhaLQ
         51Hm0yQzhv+VC1XkotlPfULkF7r3yPy1uV1nsV4dl0W01sHJOtipUOECn5IGa31HuqCc
         psnrhhmnYShb4VsW/H+6f34w8oaCI9dTvOHCI=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012251858190.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012251858190.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 22:16:31 +0100
Message-ID: <AANLkTikw_2ztHC4Q0e=QoJ7RjuAXGpX5u0nTjtbdECXa@mail.gmail.com>
Subject: Re: [PATCH] Ceph: Fix use-after-free in destroy_fs_client()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 7:01 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> In fs/ceph/super.c::destroy_fs_client() the pointer 'fsc' is freed by
> kfree() and subsequently used in a call to dout() - use after free bug.
> Easily fixed by simply moving the kfree() call after the dout() call.

As I sad before, %p reads only the address.

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  super.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 08b460a..7373594 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -498,8 +498,8 @@ void destroy_fs_client(struct ceph_fs_client *fsc)
>
>        ceph_destroy_client(fsc->client);
>
> -       kfree(fsc);
>        dout("destroy_fs_client %p done\n", fsc);
> +       kfree(fsc);
>  }
>
>  /*
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
