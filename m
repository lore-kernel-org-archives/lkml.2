Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1CAPtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:49:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58077 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1CAPtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t1Xx44x7xYx6HOnEeTE1btuZ9446HqLECVKQpMKfkUgdGy6hs9gkUxB7rqLEKWudbb
         sCPkpN1BiHdbjGFsRo3bzQblVmOqWqc77xRK9uZdmHa70Ynx9iM6akjtJ6VJ3EX5WSkh
         +D1DcUTjyhnwfG7ufWRsW4RpVCpv2UHEUhG+0=
MIME-Version: 1.0
In-Reply-To: <20110301123701.955702964@szeredi.hu>
References: <20110301123645.189703316@szeredi.hu>
	<20110301123701.955702964@szeredi.hu>
Date: Tue, 1 Mar 2011 16:49:07 +0100
Message-ID: <AANLkTimVPaTm45q8ZfKpQGjiyTwyOuHJVMuOOHzgY75P@mail.gmail.com>
Subject: Re: [PATCH 2/6 v6] vfs: export do_splice_direct() to modules
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

On Tue, Mar 1, 2011 at 1:36 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Export do_splice_direct() to modules.  Needed by overlay filesystem.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/splice.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: linux-2.6/fs/splice.c
> ===================================================================
> --- linux-2.6.orig/fs/splice.c  2011-02-22 11:04:39.000000000 +0100
> +++ linux-2.6/fs/splice.c       2011-03-01 12:18:16.000000000 +0100
> @@ -1296,6 +1296,7 @@ long do_splice_direct(struct file *in, l
>
>        return ret;
>  }
> +EXPORT_SYMBOL(do_splice_direct);

I have a question on your patch, why are you using EXPORT_SYMBOL()
instead of EXPORT_SYMBOL_GPL()?
Are you using EXPORT_SYMBOL() because all symbols in fs/splice.c
are exported via EXPORT_SYMBOL()?

To be more precise, are there any rules to decide when _GPL() should be used?
IMHO we should always use _GPL() for new symbols.

>  static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
>                               struct pipe_inode_info *opipe,
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
