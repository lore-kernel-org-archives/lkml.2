Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1AUOjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:39:31 -0500
Received: from www.tglx.de ([62.245.132.106]:45236 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1AUOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:39:30 -0500
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBI: fix unaligned leb_start value
From: John Ogness <john.ogness@linutronix.de>
Date: Fri, 21 Jan 2011 15:39:02 +0100
Message-ID: <87zkqu1fuh.fsf@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

The wrong header size was used in calculating the data offset. The
data offset should be VID header offset + VID header size (aligned to
the minimum I/O unit).

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
This patch is against linux-next-20110121.

Since the value is later aligned, this patch does not fix any real
world problem. But it should be fixed nonetheless.

 drivers/mtd/ubi/build.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index f49e49d..a4f47dd 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -737,7 +737,7 @@ static int io_init(struct ubi_device *ubi)
 	}
 
 	/* Similar for the data offset */
-	ubi->leb_start = ubi->vid_hdr_offset + UBI_EC_HDR_SIZE;
+	ubi->leb_start = ubi->vid_hdr_offset + UBI_VID_HDR_SIZE;
 	ubi->leb_start = ALIGN(ubi->leb_start, ubi->min_io_size);
 
 	dbg_msg("vid_hdr_offset   %d", ubi->vid_hdr_offset);
-- 
1.5.6.5
