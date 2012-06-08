Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022Ab2FHDLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:11:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48432 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab2FHDLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:11:50 -0400
Date: Thu, 7 Jun 2012 23:11:44 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
Message-ID: <20120608031144.GA9722@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Tao Ma <boyu.mt@taobao.com>, Greg KH <gregkh@linuxfoundation.org>
References: <20120607040345.775333506@linuxfoundation.org>
 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:03:09AM +0100, Ben Hutchings wrote:
> >  		ei->i_flags = flags;
> [...]
> 
> Shouldn't this last assignment have been deleted?

Yes, I'm testing two patches to push to Linus.  One of them deletes
the last assignment.

The testing cycle should be over by tomorrow morning; in the mean
time, this commit is harmless in its current form (although it won't
fix the problem it was intending to fix until we delete the last
line).


						- Ted

commit b22b1f178f6799278d3178d894f37facb2085765
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Thu Jun 7 19:04:19 2012 -0400

    ext4: don't set i_flags in EXT4_IOC_SETFLAGS
    
    Commit 7990696 uses the ext4_{set,clear}_inode_flags() functions to
    change the i_flags automatically but fails to remove the error setting
    of i_flags.  So we still have the problem of trashing state flags.
    Fix this by removing the assignment.
    
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@kernel.org

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 8ad112a..e34deac 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -123,7 +123,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			else
 				ext4_clear_inode_flag(inode, i);
 		}
-		ei->i_flags = flags;
 
 		ext4_set_inode_flags(inode);
 		inode->i_ctime = ext4_current_time(inode);
