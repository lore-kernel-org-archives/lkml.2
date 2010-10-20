Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0JTCRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:17:36 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4181 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab0JTCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:17:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADfuvUx5LdoF/2dsb2JhbAChVXLDGoVKBI9L
Date: Wed, 20 Oct 2010 13:17:32 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 33/35] fs: icache introduce inode_get/inode_get_ilock
Message-ID: <20101020021732.GB3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034658.963540555@kernel.dk>
 <4CBD703B.5060607@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD703B.5060607@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:17:31PM +0200, Boaz Harrosh wrote:
> On 10/19/2010 05:42 AM, npiggin@kernel.dk wrote:
> > Index: linux-2.6/fs/exofs/namei.c
> > ===================================================================
> > --- linux-2.6.orig/fs/exofs/namei.c	2010-10-19 14:18:58.000000000 +1100
> > +++ linux-2.6/fs/exofs/namei.c	2010-10-19 14:19:00.000000000 +1100
> > @@ -153,9 +153,7 @@
> >  
> >  	inode->i_ctime = CURRENT_TIME;
> >  	inode_inc_link_count(inode);
> > -	spin_lock(&inode->i_lock);
> > -	inode->i_count++;
> > -	spin_unlock(&inode->i_lock);
> > +	inode_get(inode);
> >  
> >  	return exofs_add_nondir(dentry, inode);
> >  }
> 
> Why won't you define an intermediate inode_get() in patch 08/35 and
> change both puts and gets of all file_systems in one patch? Instead
> of two tree sweeping patches. (At least for all the trivial places
> like here)

I hadn't wanted to make non locking related changes before inode
lock was removed. But yes it may make sense just to do the name
change. I'll see how it looks.

Thanks,
Nick

