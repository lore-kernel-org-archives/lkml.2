Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0I3L0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab0I3L0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:26:44 -0400
Date: Thu, 30 Sep 2010 07:26:15 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: smfrench@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] cifs: set backing_dev_info on new S_ISREG inodes
Message-ID: <20100930072615.3eb07575@barsoom.rdu.redhat.com>
In-Reply-To: <20100929231730.GA6921@infradead.org>
References: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
	<20100929231730.GA6921@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 19:17:30 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Sep 29, 2010 at 09:49:54AM -0400, Jeff Layton wrote:
> > Testing on very recent kernel (2.6.36-rc6) made this warning pop:
> > 
> >     WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x65/0x70()
> >     Hardware name:
> >     Dirtiable inode bdi default != sb bdi cifs
> > 
> > ...the following patch fixes it and seems to be the obviously correct
> > thing to do for cifs.
> 
> See my patch in the btrfs/default_backing_dev_info thread for the real
> fix for the underlying issue.  But your patch won't harm either way.
> 

Thanks Christoph. I looked to NFS as a model for this, which does a
very similar thing in nfs_fhget. It's probably reasonable for us to set
this here in case there is further churn in the VFS for this sort of
thing.

-- 
Jeff Layton <jlayton@redhat.com>
