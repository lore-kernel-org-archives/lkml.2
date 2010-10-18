Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0JRSyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:54:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:37276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab0JRSyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:54:09 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] hostfs: fix UML crash
Date: Mon, 18 Oct 2010 20:53:58 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        toralf.foerster@gmx.de
References: <1287419814-20086-1-git-send-email-richard@nod.at> <20101018114039.503233da.akpm@linux-foundation.org>
In-Reply-To: <20101018114039.503233da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182053.58496.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 18 Oktober 2010, 20:40:39 schrieb Andrew Morton:
> On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at> 
wrote:
> > 365b1818 resized f_spare within struct statfs.
> > hostfs accesses f_spare directly and needs an update.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
> > Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
> > ---
> > 
> >  fs/hostfs/hostfs_user.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
> > index 6777aa0..ce2f168 100644
> > --- a/fs/hostfs/hostfs_user.c
> > +++ b/fs/hostfs/hostfs_user.c
> > @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long
> > *blocks_out,
> > 
> >  	spare_out[1] = buf.f_spare[1];
> >  	spare_out[2] = buf.f_spare[2];
> >  	spare_out[3] = buf.f_spare[3];
> > 
> > -	spare_out[4] = buf.f_spare[4];
> > +
> > 
> >  	return 0;
> >  
> >  }
> 
> Thanks.
> 
> Is there any reason for hostfs to be playing with the f_spare field at all?

I'm not sure why hostfs is using this field.
Currently I'm reviewing UML. 
As soon I'm done with hostfs you'll receive a patch or an explanation. :-)

Cheers,
//richard
