Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab0KQDGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:06:48 -0500
Received: from THUNK.ORG ([69.25.196.29]:35369 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0KQDGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:06:46 -0500
Date: Tue, 16 Nov 2010 22:06:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Avi Kivity <avi@redhat.com>
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101117030640.GD3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Avi Kivity <avi@redhat.com>,
	Josef Bacik <josef@redhat.com>, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
	ocfs2-devel@oss.oracle.com
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
 <1289840723-3056-5-git-send-email-josef@redhat.com>
 <4CE2783F.1020004@redhat.com>
 <20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
 <4CE28211.6060204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE28211.6060204@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >There is no simple way to test if a filesystem supports hole punching or not so
> >the check has to be done per fs.  Thanks,
> 
> Could put a flag word in superblock_operations.  Filesystems which
> support punching (or other features) can enable it there.

No, it couldn't be in super_operations.  It may vary on a per-inode
basis for some file systems, such as ext4 (depending on whether the
inode is extent-mapped or indirect-block mapped).

So at least for ext4 we'd need to call into fallocate() function
anyway, once we add support.  I suppose if other file systems really
want it, we could add a flag to the super block ops structure, so they
don't have do the "do we support the punch" operation.  I can go
either way on that; although if we think the majority of file systems
are going support punch in the long-term, then it might not be worth
it to add such a flag.

						- Ted
