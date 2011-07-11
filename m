Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab1GKRcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab1GKRce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:32:34 -0400
Date: Mon, 11 Jul 2011 12:49:10 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
Message-ID: <20110711124910.66470fad@tlielax.poochiereds.net>
In-Reply-To: <CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
References: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 11:40:12 -0500
Steve French <smfrench@gmail.com> wrote:

> ok - merged.
> 
> Am testing now.  If anyone else has test data on current cifs-2.6.git
> I could send pull request faster.
> 
> On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton@redhat.com> wrote:
> > ...as that function can sleep.
> >
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/cifs/connect.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index ceab134..dd695c5 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void *data)
> >
> >        rc = compare_mount_options(sb, mnt_data);
> >  out:
> > -       cifs_put_tlink(tlink);
> >        spin_unlock(&cifs_tcp_ses_lock);
> > +       cifs_put_tlink(tlink);
> >        return rc;
> >  }
> >
> > --
> > 1.7.6
> >
> >
> 
> 
> 

Testing with all of the patches in my cifs-3.0 and cifs-3.1 branches worked fine.

-- 
Jeff Layton <jlayton@redhat.com>
