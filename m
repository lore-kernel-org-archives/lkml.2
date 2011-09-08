Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab1IHB05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:26:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:17654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757760Ab1IHB04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,348,1312182000"; 
   d="scan'208";a="49111941"
Subject: [RFC]block: don't mark flush request as SOFTBARRIER
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <htejun@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 09:29:54 +0800
Message-ID: <1315445394.29510.71.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering why flush request should be marked as SOFTBARRIER. Current flush
sequence guarantees the correctness of flush even the request is reordered by
ioscheduler.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/elevator.c b/block/elevator.c
index a3b64bc..e589b76 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -715,7 +715,6 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		break;
 
 	case ELEVATOR_INSERT_FLUSH:
-		rq->cmd_flags |= REQ_SOFTBARRIER;
 		blk_insert_flush(rq);
 		break;
 	default:


