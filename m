Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2AELew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:34:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab2AELeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:34:50 -0500
Date: Thu, 5 Jan 2012 12:34:48 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        reiserfs-devel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20120105113448.GA14947@quack.suse.cz>
References: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
 <20120105080657.GH23916@ZenIV.linux.org.uk>
 <20120105081418.GI23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105081418.GI23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-01-12 08:14:18, Al Viro wrote:
> On Thu, Jan 05, 2012 at 08:06:57AM +0000, Al Viro wrote:
> > On Thu, Jan 05, 2012 at 05:35:21PM +1100, Stephen Rothwell wrote:
> > > Hi Al,
> > > 
> > > After merging the vfs tree, today's linux-next build (powerpc
> > > ppc64_defconfig) produced this warning:
> > > 
> > > fs/reiserfs/super.c:701:2: warning: initialization from incompatible pointer type [enabled by default]
> > > fs/reiserfs/super.c:701:2: warning: (near initialization for 'reiserfs_sops.show_options') [enabled by default]
> > > 
> > > Caused by commit 2ddeb2a58b11 ("vfs: switch ->show_options() to struct
> > > dentry *") interacting with commit f1823b7b87d1 ("reiserfs: Properly
> > > display mount options in /proc/mounts") from the ext3.  This needs some
> > > merge fix ... (and will probably currently cause crashes :-()
> > 
> > Grrr...  Same as changes in the first commit, done to the function introduced
> > by the second (i.e. replace mnt->mnt_sb with dentry->d_sb).  Incidentally,
> > what are reiserfs patches doing in ext3 tree, of all places?
> 
> FWIW, an updated variant of Jan's patch would be this (on top of
> vfs.git#for-next; I can pull his commit there in such form):
  Thanks. I'm removing the old version of the patch from my tree so please
carry the new version in your tree. I was just carrying the patch because
of lack of reiserfs maintainer and because I originally wrote the patch to
accommodate needs of quota tools...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
