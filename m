Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0DAWBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:01:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0DAWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:01:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=bPHK+4TBvchRZKrIfB6sXXgXpULTQrj5OEyHkIq+t51FtjXFuUd70feD9MKRQKcpQ
	BLpWABc/Lral3L5VKaVWA==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 0/3] blkio: IO controller stats
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 01 Apr 2010 15:00:31 -0700
Message-ID: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements some additional stats for IO controller.

These stats have helped us debug issues with earlier IO controller
versions and should be useful now as well.
We've been using these stats for monitoring and debugging problems after the
fact as these stats can be collected and stored for later use.

One might argue that most of this information can be exported using blktrace
when debugging. However, blktrace has non-trivial performance impact and
cannot be always turned on. These stats provide a way for continuous monitoring
without losing much performance on rotational disks. We've been able to look
at these stats and debug issues after problems have been reported in the wild
and understand the IO pattern of the affected workloads.
Some of these stats are also a good data source for high-level analysis and
capacity planning.

This patchset adds 4 stats and I will send out another patchset later for
stats like io_merged and some stats that can be turned on only for
debugging - idle_time (total time spent idling for this blkio_group),
wait_time (total time spent by the blkio_group waiting before any one of its
queues got a timeslice). I've tried to breakdown the stats and sent the most
basic ones here.
---

Divyesh Shah (3):
      Increment the blkio cgroup stats for real now.
      Add io controller stats like
      Remove per-cfqq nr_sectors as we'll be passing that info at request dispatch


 block/blk-cgroup.c     |  239 ++++++++++++++++++++++++++++++++++++++++++++----
 block/blk-cgroup.h     |   57 +++++++++--
 block/blk-core.c       |    6 +
 block/cfq-iosched.c    |   14 +--
 include/linux/blkdev.h |   20 ++++
 5 files changed, 291 insertions(+), 45 deletions(-)

-- 
Divyesh
