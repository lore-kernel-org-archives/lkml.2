Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0GFPI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:08:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0GFPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=lvIriZA452Y/tMRQCOWGrpRzdRF8UXWMX2VwQVCG4SofCesPKdV6GcsfV6ACMILBSd
         AKX4JwZaTdrcsqWcviaj6ooaxgeXkmwHWpi9rnuSwAd8kQqBOVevcFOrzy7Tl1lV5rbs
         RNhueCz6Aw9I+ek19o5E1e0FFz8+zRZPNb1ic=
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       linux-ima-user@lists.sourceforge.net,
       Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH] ima: add default rule for initramfs files
Date: Tue,  6 Jul 2010 17:08:22 +0200
Message-Id: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the default policy shipped with IMA, in order to avoid measurements
of files in the initial ramdisk. Those files can be measured early in the boot process
by the bootloader.
The patch applies to latest version of the mainline kernel 2.6.35-rc4.


Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_policy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index aef8c0a..92d8d0e 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -64,6 +64,7 @@ static struct ima_measure_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
-- 
1.7.1

