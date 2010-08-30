Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0H3PnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:43:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0H3PnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:43:22 -0400
Message-ID: <4C7BD183.1080801@kernel.org>
Date: Mon, 30 Aug 2010 17:42:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: [PATCH] block: initialize flush request with WRITE_FLUSH instead
 of REQ_FLUSH
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
In-Reply-To: <4C7BB932.1070405@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 15:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_flush_request() only set REQ_FLUSH when initializing flush
requests making them READ requests.  Use WRITE_FLUSH instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Snitzer <snitzer@redhat.com>
---
So, this was the culprit for the incorrect data direction for flush
requests.

Thanks.

 block/blk-flush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -77,7 +77,7 @@ static void post_flush_end_io(struct req
 static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_FLUSH;
+	rq->cmd_flags = WRITE_FLUSH;
 	rq->rq_disk = disk;
 }

