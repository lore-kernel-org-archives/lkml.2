Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966916Ab0GSV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:58:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43598 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965308Ab0GSV6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ba91t/M6tTFkdVsIkNrUcSnYRAHnbw88phu0xgUMSXIJ3oGELNVOC1YOnOv/01YviD
         9dFwu6C4dgeV4+yI7z1TRnuv+PEiegqsEYilxwdJPoYOJmTyx0DNl0WptHBn4A4BwB+h
         BElmDYfyQW3gGYLbXt1e7YfJDfN8rP7eh6zh4=
MIME-Version: 1.0
In-Reply-To: <1279296925-25147-1-git-send-email-segooon@gmail.com>
References: <1279296925-25147-1-git-send-email-segooon@gmail.com>
Date: Mon, 19 Jul 2010 16:58:21 -0500
Message-ID: <AANLkTil-rrLA9iLJRkf9C4aGK1CnvitSIVktScMpjvxx@mail.gmail.com>
Subject: Re: [PATCH 10/15] fs: cifs: check kmalloc() result
From: Steve French <smfrench@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@redhat.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Joe Perches <joe@perches.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Fri, Jul 16, 2010 at 11:15 AM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> If kmalloc() fails exit with -ENOMEM.
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  fs/cifs/readdir.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index daf1753..d5e591f 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,6 +847,11 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>                end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
>
>                tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
> +               if (tmp_buf == NULL) {
> +                       rc = -ENOMEM;
> +                       break;
> +               }
> +
>                for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
>                        if (current_entry == NULL) {
>                                /* evaluate whether this case is an error */
> --
> 1.7.0.4
>
>



-- 
Thanks,

Steve
