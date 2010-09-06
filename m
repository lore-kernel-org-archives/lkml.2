Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0IFNvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:51:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62775 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0IFNvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DGvx42x06HsK5mjBtQuTiAU419MXsCU8qVRVqcJSqMEuZLCErI0Tc7x0x+Yj4nVlOy
         Co6kH776qo6tbbzxqfO7B8W2gK1T7dFGKfPRG/zBlkkaKXWjQ5rU/QS80buk2Vn3PrQT
         o4U2F4nner5mYH3MwFjsI7SuA9dV5DzOuOasQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
References: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
Date: Mon, 6 Sep 2010 14:51:11 +0100
Message-ID: <AANLkTi=fTMp+PthyKam-QHmJYfTC68LBEU_XKWhah4-O@mail.gmail.com>
Subject: Re: [PATCH] Function btree_get_extent: Incorrect if-else if statement
From: Andre Nogueira <andre.neo.net@gmail.com>
To: chris.mason@oracle.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I sent this patch weeks ago. I would like to have some feedback about it.

Thanks in advance.

2010/8/9 André Nogueira <andre.neo.net@gmail.com>:
> The btree_get_extent function (in file disk-io.c) calls the
> add_extent_mapping (in file extent_map.c). The add_extent_mapping
> function can return two values: 0 or -EEXIST.
>
> After the call, it is used an if-else if statement. If the result is
> -EEXIST, the if statement is executed. If the result is 0, the else if
> statement will not be executed because it is false.
>
> Thank you.
>
> Signed-off-by: Andre Nogueira <andre.neo.net@gmail.com>
>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 34f7c37..76eb161 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -164,7 +164,7 @@ static struct extent_map *btree_get_extent(struct
> inode *inode,
>                                                   failed_len);
>                        ret = -EIO;
>                }
> -       } else if (ret) {
> +       } else {
>                free_extent_map(em);
>                em = NULL;
>        }
> --
> 1.6.3.3
>



-- 
André Nogueira
http://sites.google.com/site/andrenogueirasite/
