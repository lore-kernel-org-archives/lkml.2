Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab1FWPI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:08:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52852 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab1FWPI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dDxNRMDbxvUJXHVMErSAc17B+BA7HZQVzJF7Yvh9LdjF6/by1Y0iIqdxn9tUCSnwSQ
         ssVXWvAi1cfbJ8gGujRqPzC8hIhtHqufymJ4+TzSG15galUxRPj3gHQJKbYw3V9XNt05
         EwXbww33M6SLfCceRkb5ionTLxOKYAaf7Xmds=
Message-ID: <4E0356E6.30104@gmail.com>
Date: Thu, 23 Jun 2011 17:08:22 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alex Elder <aelder@sgi.com>
CC: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xfs: Silence bounds checking compiler warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc with -Warray-bounds generates a false positive on this
since xfs defines the struct with u8 name[1]; to be able to
add a tag at the end.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 fs/xfs/xfs_dir2_block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 580d99c..09b4aed 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
 		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
 	dep->namelen = 2;
-	dep->name[0] = dep->name[1] = '.';
+	dep->name[0] = ((__u8 *)dep->name)[1] = '.';
 	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
-- 
1.7.5.4



