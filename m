Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1DEPBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1DEO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 22/34] scsi/in2000: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:09 +0200
Message-Id: <1302015561-21047-23-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/in2000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 6568aab..6096d93 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2228,7 +2228,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 	bp = buf;
 	*bp = '\0';
 	if (hd->proc & PR_VERSION) {
-		sprintf(tbuf, "\nVersion %s - %s. Compiled %s %s", IN2000_VERSION, IN2000_DATE, __DATE__, __TIME__);
+		sprintf(tbuf, "\nVersion %s - %s.", IN2000_VERSION, IN2000_DATE);
 		strcat(bp, tbuf);
 	}
 	if (hd->proc & PR_INFO) {
-- 
1.7.4.1

