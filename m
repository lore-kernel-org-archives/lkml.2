Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1JWElu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 00:41:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49432 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1JWElt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 00:41:49 -0400
MIME-Version: 1.0
X-Originating-IP: [94.44.240.67]
In-Reply-To: <20111022080147.11165.52913.stgit@perseus.themaw.net>
References: <20111022080147.11165.52913.stgit@perseus.themaw.net>
Date: Sun, 23 Oct 2011 06:41:48 +0200
Message-ID: <CAJfpegtA8BmTsPTFb5VpMkb=tRmLvjauMGUbhy7Grco5vcncDg@mail.gmail.com>
Subject: Re: [PATCH] vfs - fix automount should ignore LOOKUP_FOLLOW
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 10:01 AM, Ian Kent <raven@themaw.net> wrote:
> The recent patch by Miklos Szeredi that was meant to restore the original
> behavior of not triggering automounts on stat(2) and other symlink following
> syscalls also eliminated the unconditional triggering of automounts for
> intermediate path components by eliminating the LOOKUP_CONTUNUE flag from
> the check in fs/namei.c:follow_automount().
>
> This introduces a regression itself because it alters the original behaviour
> which was to unconditionally automount on intermediate path components.

LOOKUP_CONTINUE flag no longer exists (commit 49084c3 "kill LOOKUP_CONTINUE")

So this patch makes no sense for HEAD, it may make sense for backports.

Miklos

>
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>
>  fs/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 0b3138d..e4eee7c 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -732,7 +732,7 @@ static int follow_automount(struct path *path, unsigned flags,
>         * as being automount points.  These will need the attentions
>         * of the daemon to instantiate them before they can be used.
>         */
> -       if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> +       if (!(flags & (LOOKUP_PARENT | LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
>                     LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
>            path->dentry->d_inode)
>                return -EISDIR;
>
>
