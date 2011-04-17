Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab1DQQXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 12:23:20 -0400
Received: from wnohang.net ([178.79.154.173]:50437 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1DQQXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 12:23:14 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 619E640206
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 7059240200
Date: Sun, 17 Apr 2011 21:53:08 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: linux-mm@kvack.org
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Add check for dirty_writeback_interval in
 bdi_wakeup_thread_delayed
Message-ID: <20110417162308.GA1208@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 2.6.38.3-ck3-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function bdi_wakeup_thread_delayed, no checks are performed on
dirty_writeback_interval unlike other places and timeout is being set to
zero as result, thus defeating the purpose. So, I have changed it to be
passed default value of interval which is 500 centiseconds, when it is
set to zero.
I have also verified this and tested it.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  mm/backing-dev.c |    5 ++++-
  1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index befc875..d06533c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -336,7 +336,10 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
  {
  	unsigned long timeout;
  
-	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
+	if (dirty_writeback_interval)
+		timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
+	else
+		timeout = msecs_to_jiffies(5000);
  	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
  }
  
-- 
1.7.4.4

--------------------------
Raghavendra Prabhu
GPG Id : D72BE977

