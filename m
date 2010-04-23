Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0DWCRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:17:08 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:33083 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab0DWCRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:17:05 -0400
Message-ID: <4BD102E0.5070503@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 03:16:00 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4] squashfs: fix locking bug in zlib wrapper
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix locking bug in zlib wrapper introduced by recent decompressor changes.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/zlib_wrapper.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 15a03d0..7a60387 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -128,8 +128,9 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
  		goto release_mutex;
  	}

+	length = stream->total_out;
  	mutex_unlock(&msblk->read_data_mutex);
-	return stream->total_out;
+	return length;

  release_mutex:
  	mutex_unlock(&msblk->read_data_mutex);
-- 
1.6.3.3

