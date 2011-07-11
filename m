Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab1GKQkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:40:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab1GKQkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
References: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
Date: Mon, 11 Jul 2011 11:40:12 -0500
Message-ID: <CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok - merged.

Am testing now.  If anyone else has test data on current cifs-2.6.git
I could send pull request faster.

On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton@redhat.com> wrote:
> ...as that function can sleep.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ceab134..dd695c5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void *data)
>
>        rc = compare_mount_options(sb, mnt_data);
>  out:
> -       cifs_put_tlink(tlink);
>        spin_unlock(&cifs_tcp_ses_lock);
> +       cifs_put_tlink(tlink);
>        return rc;
>  }
>
> --
> 1.7.6
>
>



-- 
Thanks,

Steve
