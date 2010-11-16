Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0KPQdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0KPQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:33:47 -0500
Date: Tue, 16 Nov 2010 11:33:21 -0500
From: Josef Bacik <josef@redhat.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101116163320.GB2524@localhost.localdomain>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-5-git-send-email-josef@redhat.com> <4CE2AF5B.7020500@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE2AF5B.7020500@draigBrady.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 04:20:43PM +0000, Pádraig Brady wrote:
> On 15/11/10 17:05, Josef Bacik wrote:
> > Ext4 doesn't have the ability to punch holes yet, so make sure we return
> > EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> > be added later.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/ext4/extents.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 0554c48..35bca73 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> >  	struct ext4_map_blocks map;
> >  	unsigned int credits, blkbits = inode->i_blkbits;
> >  
> > +	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> > +	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
> > +		return -EOPNOTSUPP;
> > +
> >  	/*
> >  	 * currently supporting (pre)allocate mode for extent-based
> >  	 * files _only_
> 
> So for older versions of ext4 or other filesystems, how do we know
> that fallocate(...,FALLOC_FL_PUNCH_HOLE) is not supported.
> I.E. how do we detect at runtime that the call succeeded
> and didn't just do a normal fallocate()?
>

Older kernels won't accept FALLOC_FL_PUNCH_HOLE, so you'll get an error.
Thanks,

Josef 
