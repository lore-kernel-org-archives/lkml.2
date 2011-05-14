Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab1ENSzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:55:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42357 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1ENSzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:55:44 -0400
Date: Sat, 14 May 2011 14:55:43 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20110514185543.GA22706@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should go in too.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-eh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Tejun Heo (1):
      libata: fix oops when LPM is used with PMP

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f26f2fe..dad9fd6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3316,7 +3316,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
-	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
+	bool no_dipm = link->ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
