Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1CMSfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 14:35:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56573 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1CMSfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 14:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LpresFCiLc0+7JTom3+c9q3ZzckYibIazTSontT1dPxT1xtvkTYhFwDmQS4h3oX2OW
         ut8zRm8mAQGCDpGYObPdOltJmCQHx+sSIWWwYk+46xJkTglNZm4XVx4wHSNYwrhKwvNy
         oUy4qAOQtWuQ9+JRT9f1xdZl6hK6HSjBe1S8c=
MIME-Version: 1.0
In-Reply-To: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com>
References: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com>
Date: Sun, 13 Mar 2011 13:35:08 -0500
Message-ID: <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_=5BPATCH=5D_cifssmb=3A_=5BFIX=5D_warning=3A_=91pdata=92_may_?=
	=?windows-1252?Q?be_used_uninitialized?=
From: Steve French <smfrench@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does look a problem with the compiler.  Which compiler version?

As you noted, pdata is either initialized or we return rc!=0 and don't use it.

On Sun, Mar 13, 2011 at 11:23 AM, Richard Genoud
<richard.genoud@gmail.com> wrote:
> This suppress the warning, as far as there's no way pdata is
> uninitialized, because validate_ntransact() will initialize pdata or
> return rc != 0. In this case (goto qsec_out), pdata won't be used.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 904aa47..efa3f8e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3138,7 +3138,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>                __u32 parm_len;
>                __u32 acl_len;
>                struct smb_com_ntransact_rsp *pSMBr;
> -               char *pdata;
> +               char *pdata = NULL;
>
>  /* validate_nttransact */
>                rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
> --
> 1.7.1
>
>



-- 
Thanks,

Steve
