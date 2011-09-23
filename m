Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1IWBqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:46:10 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:48322 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1IWBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:46:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1316742366!39435830!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/extent_map.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:45:56 -0700
User-Agent: KMail/1.9.9
CC: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221845.56204.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse noise:

warning: symbol '__lookup_extent_mapping' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>
linux-btrfs@vger.kernel.org
linux-kernel@vger.kernel.org

---

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..48004fe 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -282,7 +282,7 @@ static u64 range_end(u64 start, u64 len)
 	return start + len;
 }
 
-struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
+static struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
 					   u64 start, u64 len, int strict)
 {
 	struct extent_map *em;
