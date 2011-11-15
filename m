Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1KOOb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:31:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab1KOOb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:31:57 -0500
Message-ID: <1321367515.10093.75.camel@localhost>
Subject: Re: [PATCH] audit: fix mark refcounting
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Nov 2011 09:31:55 -0500
In-Reply-To: <CAJfpeguYfkaRB=E8Ui6Ew2dz0z_F52nYC4Oaxk+ttEHcLiKvjg@mail.gmail.com>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	 <CAJfpeguYfkaRB=E8Ui6Ew2dz0z_F52nYC4Oaxk+ttEHcLiKvjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I picked it up in my audit tree for next go round, although I haven't
published the tree as I'm still doing devel...  Should be in next in a
week or two.

-Eric

On Tue, 2011-11-15 at 15:12 +0100, Miklos Szeredi wrote:
> Ping?
> 
> On Mon, Nov 7, 2011 at 3:59 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Removing the parent of a watched file results in "kernel BUG at
> > fs/notify/mark.c:139".
> >
> > To reproduce
> >
> >  add "-w /tmp/audit/dir/watched_file" to audit.rules
> >  rm -rf /tmp/audit/dir
> >
> > This is caused by fsnotify_destroy_mark() being called without an
> > extra reference taken by the caller.
> >
> > Reported by Francesco Cosoleto here:
> >
> >  https://bugzilla.novell.com/show_bug.cgi?id=689860
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > CC: Al Viro <viro@zeniv.linux.org.uk>
> > CC: Eric Paris <eparis@redhat.com>
> > CC: stable@vger.kernel.org
> > ---
> >  kernel/audit_watch.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > Index: linux.git/kernel/audit_watch.c
> > ===================================================================
> > --- linux.git.orig/kernel/audit_watch.c 2011-09-13 16:08:20.000000000 +0200
> > +++ linux.git/kernel/audit_watch.c      2011-11-07 15:19:07.000000000 +0100
> > @@ -349,7 +349,9 @@ static void audit_remove_parent_watches(
> >        }
> >        mutex_unlock(&audit_filter_mutex);
> >
> > +       audit_get_parent(parent);
> >        fsnotify_destroy_mark(&parent->mark);
> > +       audit_put_parent(parent);
> >  }
> >
> >  /* Get path information necessary for adding watches. */
> >


