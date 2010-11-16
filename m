Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab0KPLnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:43:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:49204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630Ab0KPLns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:48 -0500
Date: Tue, 16 Nov 2010 12:43:46 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101116114346.GB4757@quack.suse.cz>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
 <1289840723-3056-2-git-send-email-josef@redhat.com>
 <20101116111611.GA4757@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116111611.GA4757@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-11-10 12:16:11, Jan Kara wrote:
> On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> > diff --git a/fs/open.c b/fs/open.c
> > index 4197b9e..ab8dedf 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EINVAL;
> >  
> >  	/* Return error if mode is not supported */
> > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
>   Why not just:
> if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?
  And BTW, since FALLOC_FL_PUNCH_HOLE does not change the file size, should
not we enforce that FALLOC_FL_KEEP_SIZE is / is not set? I don't mind too
much which way but keeping it ambiguous (ignored) in the interface usually
proves as a bad idea in future when we want to further extend the interface...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
