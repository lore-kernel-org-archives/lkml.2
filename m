Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab0JRUCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab0JRUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:02:53 -0400
Date: Mon, 18 Oct 2010 13:02:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        toralf.foerster@gmx.de, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] hostfs: fix UML crash
Message-Id: <20101018130208.7b552527.akpm@linux-foundation.org>
In-Reply-To: <201010182053.58496.richard@nod.at>
References: <1287419814-20086-1-git-send-email-richard@nod.at>
	<20101018114039.503233da.akpm@linux-foundation.org>
	<201010182053.58496.richard@nod.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 20:53:58 +0200
Richard Weinberger <richard@nod.at> wrote:

> Am Montag 18 Oktober 2010, 20:40:39 schrieb Andrew Morton:
> > On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at> 
> wrote:
> > > 365b1818 resized f_spare within struct statfs.
> > > hostfs accesses f_spare directly and needs an update.
> > > 
> > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > > Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
> > > Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
> > > ---
> > > 
> > >  fs/hostfs/hostfs_user.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
> > > index 6777aa0..ce2f168 100644
> > > --- a/fs/hostfs/hostfs_user.c
> > > +++ b/fs/hostfs/hostfs_user.c
> > > @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long
> > > *blocks_out,
> > > 
> > >  	spare_out[1] = buf.f_spare[1];
> > >  	spare_out[2] = buf.f_spare[2];
> > >  	spare_out[3] = buf.f_spare[3];
> > > 
> > > -	spare_out[4] = buf.f_spare[4];
> > > +
> > > 
> > >  	return 0;
> > >  
> > >  }
> > 
> > Thanks.
> > 
> > Is there any reason for hostfs to be playing with the f_spare field at all?
> 
> I'm not sure why hostfs is using this field.
> Currently I'm reviewing UML. 
> As soon I'm done with hostfs you'll receive a patch or an explanation. :-)

365b1818 added f_flags to `struct statfs' but didn't carry that over to
`struct compat_statfs' and hence didn't copy f_flags over into
compat_statfs.  Deliberate, or oversight?

