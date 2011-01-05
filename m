Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1AEGIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:08:30 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:40330 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047Ab1AEGI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:08:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=xfbNRsATaZkzWmimORB75K75nwP+PRlYuHY29jXB9wlwrcWpDc2ZT04Khvwib6xHrAC8OgwWiRbueqeOQjHkg6u0Qp6CFqFXLQLSuSx34wtx0TMaUu2FhRhAD16HX3aL;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Documentation/trace/events.txt: Remove obsolete sched_signal_send.
Date: Wed,  5 Jan 2011 14:07:54 +0800
Message-Id: <1294207674-3912-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

'sched_signal_send' doesn't exist in the kernel now. Replace it
with 'signal_generate' so that the example in events.txt can be
executed successfully.

I also change some /debug to /sys/kernel/debug which is debugfs'
default mount directory now(similar to commit 52ad51e).

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 Documentation/trace/events.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 09bd8e9..b510564 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -125,7 +125,7 @@ is the size of the data item, in bytes.
 For example, here's the information displayed for the 'sched_wakeup'
 event:
 
-# cat /debug/tracing/events/sched/sched_wakeup/format
+# cat /sys/kernel/debug/tracing/events/sched/sched_wakeup/format
 
 name: sched_wakeup
 ID: 60
@@ -201,19 +201,19 @@ to the 'filter' file for the given event.
 
 For example:
 
-# cd /debug/tracing/events/sched/sched_wakeup
+# cd /sys/kernel/debug/tracing/events/sched/sched_wakeup
 # echo "common_preempt_count > 4" > filter
 
 A slightly more involved example:
 
-# cd /debug/tracing/events/sched/sched_signal_send
+# cd /sys/kernel/debug/tracing/events/signal/signal_generate
 # echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
 
 If there is an error in the expression, you'll get an 'Invalid
 argument' error when setting it, and the erroneous string along with
 an error message can be seen by looking at the filter e.g.:
 
-# cd /debug/tracing/events/sched/sched_signal_send
+# cd /sys/kernel/debug/tracing/events/signal/signal_generate
 # echo "((sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
 -bash: echo: write error: Invalid argument
 # cat filter
-- 
1.6.3.GIT

