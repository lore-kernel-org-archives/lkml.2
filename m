Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0C2SGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:06:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab0C2SF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:05:59 -0400
Date: Mon, 29 Mar 2010 14:05:21 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup __generic_block_fiemap and fix a few minor
	issues
Message-ID: <20100329180520.GA4539@localhost.localdomain>
References: <20100303163715.GB2215@localhost.localdomain> <alpine.LFD.2.00.1003040754150.7046@localhost.localdomain> <20100304162039.GA5722@localhost.localdomain> <20100304085021.1b4e5c58.randy.dunlap@oracle.com> <20100304171253.GB5722@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304171253.GB5722@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:12:54PM -0500, Josef Bacik wrote:
> On Thu, Mar 04, 2010 at 08:50:21AM -0800, Randy Dunlap wrote:
> > On Thu, 4 Mar 2010 11:20:40 -0500 Josef Bacik wrote:
> > 
> > > Ahh yes thats much nicer, thank you.  Here is my updated patch with your
> > > suggestions.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > > ---
> > >  fs/ioctl.c         |   81 +++++++++++++++++++++++++++++----------------------
> > >  include/linux/fs.h |    5 ++-
> > >  2 files changed, 49 insertions(+), 37 deletions(-)
> > > 
> > > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > > index 6c75110..64fed0b 100644
> > > --- a/fs/ioctl.c
> > > +++ b/fs/ioctl.c
> > > @@ -228,13 +228,22 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
> > >  
> > >  #ifdef CONFIG_BLOCK
> > >  
> > > -#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
> > > -#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
> > > +static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
> > > +{
> > > +	return (offset >> inode->i_blkbits);
> > > +}
> > > +
> > > +static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
> > > +{
> > > +	return (blk << inode->i_blkbits);
> > > +}
> > >  
> > >  /**
> > >   * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
> > >   * @inode - the inode to map
> > > - * @arg - the pointer to userspace where we copy everything to
> > > + * @fieinfo - the fiemap info struct that will be passed back to userspace
> > > + * @start - where to start mapping in the inode
> > > + * @len - how much space to map
> > >   * @get_block - the fs's get_block function
> > >   *
> > >   * This does FIEMAP for block based inodes.  Basically it will just loop
> > 
> > Please fix the kernel-doc notation.  Function parameter notation is like:
> > 
> >  * @start: where to start mapping in the inode
> 
> Sounds good, fixed below.  Thanks,
>

Is there anything else that needs to be done with this?  I just noticed it did
not get pulled in yet, just wanted to make sure there are no outstanding issues.
Thanks,

Josef 
