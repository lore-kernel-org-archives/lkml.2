Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0INUXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:23:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0INUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/15] ibmasmfs: use generic_file_llseek
Date: Tue, 14 Sep 2010 22:22:34 +0200
Message-Id: <1284495763-7506-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WouSyCKyPAgfIeLCrCSFRBpWB377eeUk0K/Ttt/2W1Y
 tHLRMgEkQuTgPglARHedKkE9kgwTUusz+xou5ezP4rG/e+ldq2
 bNODf5s6isUikSUox9vdw55g4mocDvMHrxfTgKYch+QGoPM8/H
 hatdmGoQ8G9TfbYHyvEQTTSVWZtWhLU6dl7EMsFI9iizs5ucUJ
 03fAgjRnw4L8FcCNCUZlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default for llseek will change to no_llseek,
so ibmasmfs needs to add explicit .llseek
assignments. Since we're dealing with regular
files from a VFS perspective, use generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/misc/ibmasm/ibmasmfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index 8844a3f..af2497a 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -584,6 +584,7 @@ static const struct file_operations command_fops = {
 	.release =	command_file_close,
 	.read =		command_file_read,
 	.write =	command_file_write,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations event_fops = {
@@ -591,6 +592,7 @@ static const struct file_operations event_fops = {
 	.release =	event_file_close,
 	.read =		event_file_read,
 	.write =	event_file_write,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations r_heartbeat_fops = {
@@ -598,6 +600,7 @@ static const struct file_operations r_heartbeat_fops = {
 	.release =	r_heartbeat_file_close,
 	.read =		r_heartbeat_file_read,
 	.write =	r_heartbeat_file_write,
+	.llseek =	generic_file_llseek,
 };
 
 static const struct file_operations remote_settings_fops = {
@@ -605,6 +608,7 @@ static const struct file_operations remote_settings_fops = {
 	.release =	remote_settings_file_close,
 	.read =		remote_settings_file_read,
 	.write =	remote_settings_file_write,
+	.llseek =	generic_file_llseek,
 };
 
 
-- 
1.7.1

