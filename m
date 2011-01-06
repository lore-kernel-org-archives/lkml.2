Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1AFVVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:21:08 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:37508 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab1AFVVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:21:06 -0500
Message-ID: <4D26323F.5060906@lougher.demon.co.uk>
Date: Thu, 06 Jan 2011 21:21:03 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] Squashfs: add missing check in zlib_wrapper
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On file system corruption zlib can return Z_STREAM_OK with
input buffers remaining, which will not be released.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/zlib_wrapper.c |    5 +++++
  1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 1f4833b..ab5801f 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -127,6 +127,11 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
  		goto release_mutex;
  	}

+	if (k < b) {
+		ERROR("zlib_uncompress error, data remaining\n");
+		goto release_mutex;
+	}
+
  	length = stream->total_out;
  	mutex_unlock(&msblk->read_data_mutex);
  	return length;
-- 
1.6.3.3

