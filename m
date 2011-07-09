Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1GIWNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 18:13:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48341 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1GIWNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 18:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <1310228467-27466-1-git-send-email-jlayton@redhat.com>
References: <1310228467-27466-1-git-send-email-jlayton@redhat.com>
Date: Sat, 9 Jul 2011 17:13:45 -0500
Message-ID: <CAH2r5mvoRmkhzQbB+Q1dM3wQQYy0jr1NJVr7bhs4e7qvw6zKMg@mail.gmail.com>
Subject: Re: [PATCH] cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks correct; merged

On Sat, Jul 9, 2011 at 11:21 AM, Jeff Layton <jlayton@redhat.com> wrote:
> This needs to be done regardless of whether that KConfig option is set
> or not.
>
> Reported-by: Sven-Haegar Koch <haegar@sdinet.de>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index fea9ecf..dd695c5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3011,6 +3011,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>        struct tcon_link *tlink;
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>        int referral_walks_count = 0;
> +#endif
>
>        rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
>        if (rc)
> @@ -3018,6 +3019,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>
>        cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
>
> +#ifdef CONFIG_CIFS_DFS_UPCALL
>  try_mount_again:
>        /* cleanup activities if we're chasing a referral */
>        if (referral_walks_count) {
> --
> 1.7.6
>
>



-- 
Thanks,

Steve
