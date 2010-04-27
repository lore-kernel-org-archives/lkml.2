Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0D0Mxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:53:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36406 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0D0Mxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FZWvrW+ZbTWtw+1uQDQb3jP1M542osgg3MCszAVpRoWLAPlIKM9BOs0capYXobqbq6
         2dZExn2nu1N50vHBQADv9IS07NkH3ofeJFyF6sP2yRias1zI2H1/MwnodQpzB2SdN3x3
         WErj5c0KXv8pRAD1DnYmj5J0ms1anfTx6cLN4=
MIME-Version: 1.0
In-Reply-To: <20100427114816.GE13859@logfs.org>
References: <20100426094810.GE27497@kernel.dk>
	 <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk>
	 <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org>
	 <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com>
	 <20100427111759.GA13859@logfs.org>
	 <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com>
	 <20100427114004.GD13859@logfs.org> <20100427114816.GE13859@logfs.org>
Date: Tue, 27 Apr 2010 14:53:37 +0200
Message-ID: <r2h4aa525de1004270553t202fef74u3f4564f4187624c6@mail.gmail.com>
Subject: Re: [PATCH] [LogFS] Return -EINVAL if filesystem image doesn't match
From: Paolo Minazzi <paolo.minazzi@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the patch below solve the problem for you (without the explicit
> "rootfstype=romfs")?
>
> Jörn
>
> --
> One of my most productive days was throwing away 1000 lines of code.
> -- Ken Thompson.
>
>
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  fs/logfs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/logfs/super.c b/fs/logfs/super.c
> index 5866ee6..f649038 100644
> --- a/fs/logfs/super.c
> +++ b/fs/logfs/super.c
> @@ -413,7 +413,7 @@ static int __logfs_read_sb(struct super_block *sb)
>
>        page = find_super_block(sb);
>        if (!page)
> -               return -EIO;
> +               return -EINVAL;
>
>        ds = page_address(page);
>        super->s_size = be64_to_cpu(ds->ds_filesystem_size);

The above patch solve the problem for me.
Now I can mount root without rootfstype=romfs

Bye,
Paolo
