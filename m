Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0GGVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:41:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab0GGVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/18] ibmasmfs: use generic_file_llseek
Date: Wed,  7 Jul 2010 23:40:12 +0200
Message-Id: <1278538820-1392-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:cx4PszM5n2jbK+/EvdK/vf+IckCdO02ZokcUfeSGNpq
 K15/n+GLb1ioK3kt6jmeMViPwkTRP3Wvofn20ZIdCI7KIDOvqr
 AZEpDYIy9lCFayozRN7rwhkzJglsjZ7/sJbFWtokd+17jvZ0j6
 86g3DoTKw4C/NY1indMnDxm5zRNGWDYhnOIhaYtbYlyYLFeXII
 sSFxpWf3lWDi++T3EnsJQ==
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

