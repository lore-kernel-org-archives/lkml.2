Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1KVAqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:46:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1KVAp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:45:59 -0500
Date: Tue, 22 Nov 2011 08:44:34 +0800
From: wangyanqing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: warns@pre-sense.de, linux-kernel@vger.kernel.org, tj@kernel.org,
        jaxboe@fusionio.com
Subject: [PATCH] fs:partitions:efi.c: correct misuse force_gpt
Message-ID: <20111122004434.GA6584@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	akpm@linux-foundation.org, warns@pre-sense.de,
	linux-kernel@vger.kernel.org, tj@kernel.org, jaxboe@fusionio.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The primary gpt header maybe broken, so we should
check the alternate gpt header no matter whether
there is a gpt boot parameter.(The alternate gpt header
is for this way).

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 fs/partitions/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 6296b40..53fd92f 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -553,7 +553,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 		good_agpt = is_gpt_valid(state,
 					 le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
-        if (!good_agpt && force_gpt)
+        if (!good_agpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
 
         /* The obviously unsuccessful case */
-- 
1.7.3.4

