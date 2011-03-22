Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1CVWKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:10:49 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:56594 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755576Ab1CVWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:10:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type:X-Identified-User;
	b=rkj0o+rRl1YSJ4sDOQC/+uLQTQ7ClnItBRD/VYVS9ih1BccLTWwXf2/DaOMcQ67xBSQFEO+YJzwDsKqb85tC/dufN8gDFo2mSphVl00z4AwI+2RLJL46tmG0R7Sc6Ae+;
Date: Tue, 22 Mar 2011 15:10:33 -0700 (PDT)
From: Randy Dunlap <rdunlap@xenotime.net>
X-X-Sender: rddunlap@chimera.site
To: Linda Walsh <lkml@tlinx.org>, axboe@kernel.dk
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/iostats.txt: bit-size reference etc.
In-Reply-To: <4D83D188.3000909@tlinx.org>
Message-ID: <alpine.LFD.2.00.1103221509030.20572@chimera.site>
References: <4D83D188.3000909@tlinx.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

- correction that disk stats values are native-word-sized
   32-bit or 64-bit values, not always 32-bi values
- drop "Last modified" entry; use git for that
- fix a few typos
- change "cpu" to "CPU"

Reported-by: Linda Walsh <lkml@tlinx.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  Documentation/iostats.txt |   17 ++++++++---------
  1 file changed, 8 insertions(+), 9 deletions(-)

--- linux-2.6.38-git11.orig/Documentation/iostats.txt
+++ linux-2.6.38-git11/Documentation/iostats.txt
@@ -1,8 +1,6 @@
  I/O statistics fields
  ---------------

-Last modified Sep 30, 2003
-
  Since 2.4.20 (and some versions before, with patches), and 2.5.45,
  more extensive disk statistics have been introduced to help measure disk
  activity. Tools such as sar and iostat typically interpret these and do
@@ -46,11 +44,12 @@ the above example, the first field of st
  By contrast, in 2.6 if you look at /sys/block/hda/stat, you'll
  find just the eleven fields, beginning with 446216.  If you look at
  /proc/diskstats, the eleven fields will be preceded by the major and
-minor device numbers, and device name.  Each of these formats provide
+minor device numbers, and device name.  Each of these formats provides
  eleven fields of statistics, each meaning exactly the same things.
  All fields except field 9 are cumulative since boot.  Field 9 should
-go to zero as I/Os complete; all others only increase.  Yes, these are
-32 bit unsigned numbers, and on a very busy or long-lived system they
+go to zero as I/Os complete; all others only increase (unless they
+overflow and wrap).  Yes, these are (32-bit or 64-bit) unsigned long
+(native word size) numbers, and on a very busy or long-lived system they
  may wrap. Applications should be prepared to deal with that; unless
  your observations are measured in large numbers of minutes or hours,
  they should not wrap twice before you notice them.
@@ -96,11 +95,11 @@ introduced when changes collide, so (for
  read I/Os issued per partition should equal those made to the disks ...
  but due to the lack of locking it may only be very close.

-In 2.6, there are counters for each cpu, which made the lack of locking
-almost a non-issue.  When the statistics are read, the per-cpu counters
-are summed (possibly overflowing the unsigned 32-bit variable they are
+In 2.6, there are counters for each CPU, which make the lack of locking
+almost a non-issue.  When the statistics are read, the per-CPU counters
+are summed (possibly overflowing the unsigned long variable they are
  summed to) and the result given to the user.  There is no convenient
-user interface for accessing the per-cpu counters themselves.
+user interface for accessing the per-CPU counters themselves.

  Disks vs Partitions
  -------------------

