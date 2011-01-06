Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1AFVMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:12:22 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:64352 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842Ab1AFVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:12:20 -0500
Message-ID: <4D263031.5070306@lougher.demon.co.uk>
Date: Thu, 06 Jan 2011 21:12:17 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/5] Squashfs: remove unnecessary variable in zlib_wrapper
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Get rid of unnecessary bytes variable, and remove redundant
initialisation of zlib_err.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/zlib_wrapper.c |    9 ++++-----
  1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 7a60387..1f4833b 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -66,8 +66,8 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
  	struct buffer_head **bh, int b, int offset, int length, int srclength,
  	int pages)
  {
-	int zlib_err = 0, zlib_init = 0;
-	int avail, bytes, k = 0, page = 0;
+	int zlib_err, zlib_init = 0;
+	int k = 0, page = 0;
  	z_stream *stream = msblk->stream;

  	mutex_lock(&msblk->read_data_mutex);
@@ -75,11 +75,10 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
  	stream->avail_out = 0;
  	stream->avail_in = 0;

-	bytes = length;
  	do {
  		if (stream->avail_in == 0 && k < b) {
-			avail = min(bytes, msblk->devblksize - offset);
-			bytes -= avail;
+			int avail = min(length, msblk->devblksize - offset);
+			length -= avail;
  			wait_on_buffer(bh[k]);
  			if (!buffer_uptodate(bh[k]))
  				goto release_mutex;
-- 
1.6.3.3

