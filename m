Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1ANEJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:09:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1ANEJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sJ/gob7aPGK8j3JcCWqNf8A5iNm4OqVKiaEkqd8t/Zx2Lcd0735iu2S5xANxtfJBTy
         tCbYRRI+Rvk0gNARVR+SlhYW5SK/ED0zf9iiGcIecbcE+EE7ywQZVfRQT4vlaekbMIOV
         ZdW7km+KE0mhTdvJHl2s308T/XkFOlW73CRxo=
MIME-Version: 1.0
In-Reply-To: <7352.1294971049@jrobl>
References: <7352.1294971049@jrobl>
Date: Fri, 14 Jan 2011 15:09:10 +1100
Message-ID: <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 1:10 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Isn't it path.dentry->d_inode instead of nd.inode?
>
> J. R. Okajima
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 5bb7588..1df3bee 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2356,8 +2374,9 @@ reval:
>                        goto exit_dput;
>                error = __do_follow_link(&path, &nd, &cookie);
>                if (unlikely(error)) {
> -                       if (!IS_ERR(cookie) && nd.inode->i_op->put_link)
> -                               nd.inode->i_op->put_link(path.dentry, &nd, cookie);
> +                       struct dentry *i = path.dentry->d_inode;
> +                       if (!IS_ERR(cookie) && i->i_op->put_link)
> +                               i->i_op->put_link(path.dentry, &nd, cookie);
>                        /* nd.path had been dropped */
>                        nd.path = path;
>                        goto out_path;

It should be the inode we followed, rather than the inode of the
new path, I think.
