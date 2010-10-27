Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0J0XDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:03:17 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:34105 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757236Ab0J0XDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:03:14 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs: break out inode LRU operations from inode_lock V2
Date: Thu, 28 Oct 2010 10:02:14 +1100
Message-Id: <1288220538-21476-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

The following patches break the inode LRU operations and the first
half of iput_final() out from under the inode_lock.  The patches
should apply to your current merge-stem tree.

Version 2:
- make i_state checks/__iget() atomic under inode->i_lock
- merge dispose_one_inode() into evict()
- move inode hash removal after ->evict_inode call.
- always take the inode_lru_lock() when checking whether the inode
  is on the lru or not.
