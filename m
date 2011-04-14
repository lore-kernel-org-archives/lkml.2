Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab1DNSfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:35:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:37350 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab1DNRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 018/209] block: check for proper length of iov entries in blk_rq_map_user_iov()
Date: Thu, 14 Apr 2011 13:40:48 -0400
Message-Id: <1302803039-9400-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 9284bcf4e335e5f18a8bc7b26461c33ab60d0689 upstream.

Ensure that we pass down properly validated iov segments before
calling into the mapping or copy functions.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/blk-map.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9083cf0..30a7e51 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -205,6 +205,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			unaligned = 1;
 			break;
 		}
+		if (!iov[i].iov_len)
+			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
-- 
1.7.4.4

