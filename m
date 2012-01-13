Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2AMMlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:41:52 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52736 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab2AMMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:41:51 -0500
X-Sasl-enc: cN2g828op01Na2HYzVHndnKX8BjkiXs123mAjDHGT5r2ub/6+w9cf9Aqhg 1326458510
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - fix deal with autofs4_write races
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Dave Airlie <airlied@gmail.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jan 2012 20:41:46 +0800
Message-ID: <20120113124145.31045.22056.stgit@web.messagingengine.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how I missed this obvious mistake when I
reviewed Als' patches, sorry.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/waitq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 9ef5b29..da8876d 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -76,7 +76,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 		data += wr;
 		bytes -= wr;
 	}
-	mutex_lock(&sbi->pipe_mutex);
+	mutex_unlock(&sbi->pipe_mutex);
 
 	set_fs(fs);
 

