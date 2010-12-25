Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0LYVMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:12:34 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42939 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0LYVMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ahx9nCxXYOcmUyKdEMUWSVNMRw9T8iSeSYBBb9sGAMKmAYG3bzpEN1G4WREItjRcbr
         MGyhjwQmu0ftmJMe0JDDBYMxPeZiNQgaFNN1ts1q5AyofHa50QfGpd0AQDVPDABX1hxO
         174iVJHnQo5gFFJk0d5nZX+3xPaHr73JR0Bx4=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012251914370.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012251914370.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 22:12:31 +0100
Message-ID: <AANLkTik+yrpY8T69w_RQ84ZbRqwkjvFhvxHLBvU14N3f@mail.gmail.com>
Subject: Re: [PATCH] Ceph: Fix a use-after-free bug in ceph_destroy_client().
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Sage Weil <sage@newdream.net>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 7:17 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hello,
>
> In net/ceph/ceph_common.c::ceph_destroy_client() the pointer 'client' is
> freed by kfree() and subsequently used in a call to dout() - use after
> free bug.

Not really. %p reads only the address of "client".
kfree() does not alter this address.

> Easily fixed by simply moving the kfree() call after the dout() call.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ceph_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index f3e4a13..890bbbf 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -408,8 +408,8 @@ void ceph_destroy_client(struct ceph_client *client)
>
>        ceph_destroy_options(client->options);
>
> -       kfree(client);
>        dout("destroy_client %p done\n", client);
> +       kfree(client);
>  }
>  EXPORT_SYMBOL(ceph_destroy_client);
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
