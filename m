Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1F0Pj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:39:29 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40691 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751328Ab1F0Pit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:38:49 -0400
Message-Id: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182743.git.ralf@linux-mips.org>
In-Reply-To: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
From: Ralf Baechle <ralf@linux-mips.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Date: Sun, 26 Jun 2011 12:19:55 +0100
Subject: [PATCH 01/12] SCSI: sim710: Fix section mismatch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/scsi/sim710.o(.data+0x4c): Section mismatch in reference from the variable sim710_eisa_driver to the function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
---
 drivers/scsi/sim710.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 8ac6ce7..a128502 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -286,7 +286,7 @@ static struct eisa_device_id sim710_eisa_ids[] = {
 };
 MODULE_DEVICE_TABLE(eisa, sim710_eisa_ids);
 
-static __init int
+static __devinit int
 sim710_eisa_probe(struct device *dev)
 {
 	struct eisa_device *edev = to_eisa_device(dev);
-- 
1.7.4.4

