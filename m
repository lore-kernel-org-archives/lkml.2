Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1JWLd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:33:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43412 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab1JWLdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:33:55 -0400
X-Sasl-enc: 19Op836EX0lAmQRBxxyURbKRrHjMLSHeLUErzrODSPpH 1319369634
Subject: Re: [PATCH] vfs - fix automount should ignore LOOKUP_FOLLOW
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegtA8BmTsPTFb5VpMkb=tRmLvjauMGUbhy7Grco5vcncDg@mail.gmail.com>
References: <20111022080147.11165.52913.stgit@perseus.themaw.net>
	 <CAJfpegtA8BmTsPTFb5VpMkb=tRmLvjauMGUbhy7Grco5vcncDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 19:33:49 +0800
Message-ID: <1319369629.7876.6.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 06:41 +0200, Miklos Szeredi wrote:
> On Sat, Oct 22, 2011 at 10:01 AM, Ian Kent <raven@themaw.net> wrote:
> > The recent patch by Miklos Szeredi that was meant to restore the original
> > behavior of not triggering automounts on stat(2) and other symlink following
> > syscalls also eliminated the unconditional triggering of automounts for
> > intermediate path components by eliminating the LOOKUP_CONTUNUE flag from
> > the check in fs/namei.c:follow_automount().
> >
> > This introduces a regression itself because it alters the original behaviour
> > which was to unconditionally automount on intermediate path components.
> 
> LOOKUP_CONTINUE flag no longer exists (commit 49084c3 "kill LOOKUP_CONTINUE")

Oh .. right, now I think about it I did see that commit, opps!

> 
> So this patch makes no sense for HEAD, it may make sense for backports.

Yeah, I was a bit to hasty trying to solve my own backport mistake.

> 
> Miklos
> 
> >
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >
> >  fs/namei.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 0b3138d..e4eee7c 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -732,7 +732,7 @@ static int follow_automount(struct path *path, unsigned flags,
> >         * as being automount points.  These will need the attentions
> >         * of the daemon to instantiate them before they can be used.
> >         */
> > -       if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
> > +       if (!(flags & (LOOKUP_PARENT | LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
> >                     LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
> >            path->dentry->d_inode)
> >                return -EISDIR;
> >
> >


