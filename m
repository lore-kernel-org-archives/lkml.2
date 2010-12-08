Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0LHAqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:32 -0500
Received: from kroah.org ([198.145.64.141]:45828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0LHAqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:24 2010
Message-Id: <20101208004424.803960336@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [004/127] block: check for proper length of iov entries in blk_rq_map_user_iov()
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit 9284bcf4e335e5f18a8bc7b26461c33ab60d0689 upstream.

Ensure that we pass down properly validated iov segments before
calling into the mapping or copy functions.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-map.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -205,6 +205,8 @@ int blk_rq_map_user_iov(struct request_q
 			unaligned = 1;
 			break;
 		}
+		if (!iov[i].iov_len)
+			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)


