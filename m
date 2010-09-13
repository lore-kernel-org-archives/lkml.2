Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0IMQab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:30:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36545 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0IMQa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R2wngUCz7BPpgN71oEplyN5dJByVSLQywX6NajjqEKLL+eurEfAwWAYfGl9ROVilpt
         bJVOvCuzZsDKctGHnYejhOPYbQmStw/VkHGVcdVKJ8+rc780+cmPtzw+sF7L7Z3SKkBC
         eRu9mRe8dryXfc6r8JbXRUhK/dxV2XXHAwMPc=
MIME-Version: 1.0
In-Reply-To: <1284165942.4009.5.camel@lenovo>
References: <1284165942.4009.5.camel@lenovo>
Date: Mon, 13 Sep 2010 11:30:27 -0500
Message-ID: <AANLkTi=q5qTNomN0VQ__9V8cbF=ygGMFkm2a3=qiaYja@mail.gmail.com>
Subject: Re: [PATCH] FS: cifs: Fix compile warning
From: Steve French <smfrench@gmail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 7:45 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> In today linux-next I got a compile warning due a possibly uninitialized variable
>
> This trivial patch solves the issue
>
> Thanks a lot
>
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..ee1bba4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>                __u32 parm_len;
>                __u32 acl_len;
>                struct smb_com_ntransact_rsp *pSMBr;
> -               char *pdata;
> +               char *pdata = NULL;

This looks like a compiler problem - the variable is always
initialized by validate_ntransact except when
buf (which contains the smb) is null, when it returns -EINVAL and in
that case pdata is not used.
Setting it to null would not help anyway - if it were left as null it
would oops on the memcpy (where pdata is used).

This area of code has not changed recently.


-- 
Thanks,

Steve
