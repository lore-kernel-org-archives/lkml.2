Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2AEIHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:07:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2AEIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:06:59 -0500
Date: Thu, 5 Jan 2012 08:06:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20120105080657.GH23916@ZenIV.linux.org.uk>
References: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 05:35:21PM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> fs/reiserfs/super.c:701:2: warning: initialization from incompatible pointer type [enabled by default]
> fs/reiserfs/super.c:701:2: warning: (near initialization for 'reiserfs_sops.show_options') [enabled by default]
> 
> Caused by commit 2ddeb2a58b11 ("vfs: switch ->show_options() to struct
> dentry *") interacting with commit f1823b7b87d1 ("reiserfs: Properly
> display mount options in /proc/mounts") from the ext3.  This needs some
> merge fix ... (and will probably currently cause crashes :-()

Grrr...  Same as changes in the first commit, done to the function introduced
by the second (i.e. replace mnt->mnt_sb with dentry->d_sb).  Incidentally,
what are reiserfs patches doing in ext3 tree, of all places?
