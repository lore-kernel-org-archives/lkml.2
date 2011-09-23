Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1IWS3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:29:41 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:30416 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1IWS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:29:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1316802498!16441493!44
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/compression.c: quiet sparse noise
Date: Fri, 23 Sep 2011 11:28:56 -0700
User-Agent: KMail/1.9.9
CC: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231128.56757.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse warning:

warning: symbol 'btrfs_compress_op' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com> 

---

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..3e8c133 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -726,7 +726,7 @@ static int comp_num_workspace[BTRFS_COMPRESS_TYPES];
 static atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES];
 static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 
-struct btrfs_compress_op *btrfs_compress_op[] = {
+static struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 };
