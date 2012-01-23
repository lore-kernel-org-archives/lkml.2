Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2AWDjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:39:31 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57922 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2AWDja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:39:30 -0500
X-AuditID: b753bd60-96e5dba00000359c-95-4f1cd66fa5f0
X-AuditID: b753bd60-96e5dba00000359c-95-4f1cd66fa5f0
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH 0/3] xfs: change available ranges in quota check
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 23 Jan 2012 12:45:14 +0900
Message-ID: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series changes available ranges of softlimit and
hardlimit in quota check, as follows.

(1) Consider new reservation for quota check
    The disk block reservation checks if (current usage + new
    reservation) reach the quota limit although the inode reservation
    does not use the new reservation for quota check. It should
    consider it, as well. This is mandatory for (2).

(2) Change available ranges of softlimit and hardlimit in quota check
    Currently xfs quota allows us to use disk blocks and inodes
    up to lower than quota limits. They should be used up to
    not greater than the limits.

Thanks,

---

Mitsuo Hayasaka (3):
      xfs: cleanup quota check on disk blocks and inodes reservations
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: consider new reservation for quota check on inode reservation


 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   15 +++++++--------
 4 files changed, 24 insertions(+), 25 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
