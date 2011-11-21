Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1KUJjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:39:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43124 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1KUJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:39:05 -0500
Date: Mon, 21 Nov 2011 17:38:01 +0800
From: wangyanqing <udknight@gmail.com>
To: warns@pre-sense.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        warns@pre-sense.de, jaxboe@fusionio.com
Subject: [PATCH] fs:partitions:efi.c: bugfix a issue in find_valid_gpt
Message-ID: <20111121093801.GA1062@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>, warns@pre-sense.de,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	tj@kernel.org, jaxboe@fusionio.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I meet a 3T disk, which partitioned by Windows 7,
and linux report unknow partition table. But it can been
detected the partition table when I add gpt to boot
parameter.

This issue caused by the find_valid_gpt function will fail
out when check the legacy mbr failed if there is no gpt boot
parameter.

if boot without gpt, we should fail back to check the guid
partition table when check the legacy mbr failed instead of
fail out.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 fs/partitions/efi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 6296b40..302631e 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -543,8 +543,6 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
                         good_pmbr = is_pmbr_valid(legacymbr);
                         kfree(legacymbr);
                 }
-                if (!good_pmbr)
-                        goto fail;
         }
 
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
-- 
1.7.3.4

