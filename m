Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0CYSEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:04:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33807 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0CYSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:04:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=KeqiWhK7KbJ/PvFv0DCwUbJ4s/fg2NyeCvZhjvh8/ukO6OUH0tN2SEFnoeuGkbRr/
	TLQVzbQK5aqjnzaT5/q8A==
Subject: [PATCH 0/4] io-controller: Use names rather than major:minor
To: vgoyal@redhat.com, jens.axboe@oracle.com
From: Chad Talbott <ctalbott@google.com>
Cc: mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Date: Thu, 25 Mar 2010 11:04:17 -0700
Message-ID: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stack (which includes Gui's patch for per-device weights),
changes the various blkio.* stats to use the disks' names (sda, sdb,
etc.) rather than major:minor pairs when printing statistics.
Additionally setting a per-device policy can be done via the disk's
name.

This has the side effect of fixing the "root cgroup shows no stats"
problem that Ricky mentioned.

Chad

---

Chad Talbott (4):
      blkio_group key change: void * -> request_queue *
      Adds an RCU-protected pointer to request_queue that makes it easy to
      io-controller: Add a new interface "weight_device" for IO-Controller
      Use disk-names to set blkio.weight_device policy


 block/blk-cgroup.c     |  224 +++++++++++++++++++++++++++++++++++++++++++++---
 block/blk-cgroup.h     |   23 ++++-
 block/blk-sysfs.c      |    4 +
 block/cfq-iosched.c    |   27 ++----
 include/linux/blkdev.h |    6 +
 5 files changed, 248 insertions(+), 36 deletions(-)

