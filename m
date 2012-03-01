Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab2CAUhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:37:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab2CAUhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:37:01 -0500
Date: Thu, 1 Mar 2012 21:36:58 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        dchinner@redhat.com, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/9] fuse: Push file_update_time() into
 fuse_page_mkwrite()
Message-ID: <20120301203658.GC13104@quack.suse.cz>
References: <1330602103-8851-1-git-send-email-jack@suse.cz>
 <1330602103-8851-7-git-send-email-jack@suse.cz>
 <87obsgce4a.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obsgce4a.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-03-12 20:31:17, Miklos Szeredi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > CC: Miklos Szeredi <miklos@szeredi.hu>
> > CC: fuse-devel@lists.sourceforge.net
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/fuse/file.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 4a199fd..eade72e 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -1323,6 +1323,7 @@ static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	 */
> >  	struct inode *inode = vma->vm_file->f_mapping->host;
> >  
> > +	file_update_time(vma->vm_file);
> 
> Fuse sets S_CMTIME in inode flags, so this is a no-op.  IOW the patch is
> not needed.
  I see. Thanks. Patch dropped.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
