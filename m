Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2BHE0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 23:26:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57951 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2BHE0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 23:26:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120205062204.763bdab6@tlielax.poochiereds.net>
References: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
	<20120205062204.763bdab6@tlielax.poochiereds.net>
Date: Tue, 7 Feb 2012 22:26:42 -0600
Message-ID: <CAH2r5mud1Y1dWDzr6zn2aD5y0HtPhn_CKP-ZQVR-QNQDWxpqOg@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix NULL pointer dereference in cifs_construct_tcon()
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be merged now.

In addition, jeff's more recent 3 patches are now in cifs-2.6.git

On Sun, Feb 5, 2012 at 5:22 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> On Sun, 5 Feb 2012 00:35:19 +0100 (CET)
> Jesper Juhl <jj@chaosbits.net> wrote:
>
> > If the call to kcalloc() fails and returns NULL we'll dereference a
> > NULL 'vol_info' after we jump to the 'out:' label.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  fs/cifs/connect.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 986709a..bd67b7c 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3859,7 +3859,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
> >       vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
> >       if (vol_info == NULL) {
> >               tcon = ERR_PTR(-ENOMEM);
> > -             goto out;
> > +             goto out2;
> >       }
> >
> >       vol_info->local_nls = cifs_sb->local_nls;
> > @@ -3901,7 +3901,7 @@ out:
> >       kfree(vol_info->username);
> >       kfree(vol_info->password);
> >       kfree(vol_info);
> > -
> > +out2:
> >       return tcon;
> >  }
> >
>
> Thanks. Dan Carpenter already sent a patch a couple of weeks ago to fix
> this. Steve has it in his tree, but hasn't pushed it to Linus yet.
>
> Steve, is there a reason you're waiting?
>
> --
> Jeff Layton <jlayton@redhat.com>




--
Thanks,

Steve
