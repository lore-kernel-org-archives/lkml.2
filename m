Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2LIQGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:06:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:6016 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab2LIQGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:06:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="231334442"
Message-ID: <50C4B5D7.4030808@intel.com>
Date: Mon, 10 Dec 2012 00:01:27 +0800
From: xtu4 <xiaobing.tu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, 'axboe@kernel.dk', di.zhang@intel.com,
        xtu4 <xiaobing.tu@intel.com>
Subject: [PATCH] Allow 0ms deadline latency
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Allow 0ms deadline latency, increase the read speed

Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
---
block/deadline-iosched.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index c644137..e502d6b 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -230,7 +230,7 @@ static inline int deadline_check_fifo(struct 
deadline_data *dd, int ddir)
        /*
         * rq is expired!
         */
-       if (time_after(jiffies, rq_fifo_time(rq)))
+       if (time_after_eq(jiffies, rq_fifo_time(rq)))
                return 1;

         return 0;
-- 
1.7.6

