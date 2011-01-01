Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1AAQpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:45:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32930 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1AAQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=i6yUKod0h5grj1bMxwUzTpZ8kPVI2QcsXVr4SBecwm1T7H0bnt2WKK/uqJbd9hiXqb
         9ynLkfzUFGyDKsWnBtrvvdnUYLyNMDBdgNd6oaG7lZAOOvWempNbOVg0PtuygEkJgKyt
         o/qjdHUH7I8xGox+sB2yjKWkdUNLelC9SUI+8=
Message-ID: <4D1F5A17.4010807@gmail.com>
Date: Sat, 01 Jan 2011 17:45:11 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de,
        linux-scsi@vger.kernel.org
Subject: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WRITE_{6,10,12} are defined numbers, so the branch was always taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

See include/scsi/scsi.h:58-123 for
#define WRITE_6               0x0a
#define WRITE_10              0x2a
#define WRITE_12              0xaa

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 17e3df4..a6e5222 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1171,7 +1171,8 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
+	if (pcmd->cmnd[0] & WRITE_6 || pcmd->cmnd[0] & WRITE_10 ||
+			pcmd->cmnd[0] & WRITE_12 ){
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	}
 	ccb->arc_cdb_size = arccdbsize;
