Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0J0EYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:24:25 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:43962 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060Ab0J0EX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:23:56 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs: break out inode LRU operations from node_lock
Date: Wed, 27 Oct 2010 15:23:00 +1100
Message-Id: <1288153384-8878-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

The following patches break the inode LRU operations and the first half of
iput_final() out from under the inode_lock. I included the dispose_one_inode
factoring patch to isolate the inode_lock from iput_final() completely. It's
easy enough to drop if you don't want that right now.

It passes xfstests on 1-, 2- and 8-way VMs, survives 8-way parallel
create/traverse/unlink workloads with 0, 1 and 65536 byte files on XFS and
ext4, and shows no problems with looping 50-client dbench runs on XFS or ext4.

The patches should apply to your current merge-stem tree.

