Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1CSTx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:53:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1CSTxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cxli4EGcDR8HAh1QdN62+vc6DRvNsQeEWimHFOxGw7iuWZ4Qbud25XNKmyMpDPixQU
         HeCMQt/1P6eYkUpKq1jf+TaUhOxZNdaiItbpyYQmTcD5QWq8kGFX8dC5q+Uwrle4MULn
         VEqVMuA0hagG7odXO4T2LpYRJgCBKvZy4a/1g=
Message-ID: <4D8509D1.6080107@gmail.com>
Date: Sat, 19 Mar 2011 20:53:53 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] osst: wrong index used in inner loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index i was already used in the outer loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/osst.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

I'm not sure if this is the right fix, maybe a break or return
is missing?

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 521e218..d6d6d89 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4702,8 +4702,9 @@ static int __os_scsi_tape_open(struct inode * inode, struct file * filp)
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
 					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
-				for (i=0; i < ST_NBR_PARTITIONS; i++) {
-					STps = &(STp->ps[i]);
+				int j;
+				for (j=0; j < ST_NBR_PARTITIONS; j++) {
+					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
 					STps->eof = ST_NOEOF;
 					STps->at_sm = 0;
