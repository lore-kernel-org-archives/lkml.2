Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab1CDRNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:13:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39209 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1CDRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:13:54 -0500
Date: Fri, 4 Mar 2011 17:13:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [RFC] a couple of i_nlink fixes in btrfs
Message-ID: <20110304171353.GU22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	a) rename() plays with i_nlink of old_inode; bad, since it's not
locked.  I'd add a variant of btrfs_unlink_inode() that would leave
btrfs_drop_nlink()/btrfs_update_inode() to callers and use it instead.
	b) btrfs_link() doesn't check for i_nlink overflows.  I don't
know if there's anything preventing that many links to a file on btrfs,
but if there is, it's at least worth a comment in there...

	Please, review; patches in followups or in #btrfs in vfs-2.6.git
