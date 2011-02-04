Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab1BDMYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:24:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1BDMYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hz2fGIETdRoScCCv2011bLdLrXk6NkmHPJ1KCClGS8v9BSRQ2LpR1co76NrV/h7vW3
         eo+LQwGF/r1VVTXvJbhPjHEzctAnfM9wpTkFBX1lA/rrW+50cNc2uCPdnQspzyz/lZRq
         9FwB2NBSQITevq1IfNNc6tOY7SQxvV6Uo+S6o=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/20] scsi: aic94xx: world-writable sysfs update_bios file
Date: Fri,  4 Feb 2011 15:24:10 +0300
Message-Id: <4481b95e41fd0408fdded32f150c4742cf0d0b0b.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to load firmware.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3b7e83d..d5ff142 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -486,7 +486,7 @@ static ssize_t asd_show_update_bios(struct device *dev,
 			flash_error_table[i].reason);
 }
 
-static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUGO,
+static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUSR,
 	asd_show_update_bios, asd_store_update_bios);
 
 static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
-- 
1.7.0.4

