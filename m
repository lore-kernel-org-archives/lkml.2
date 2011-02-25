Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1BYX5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 18:57:40 -0500
Received: from mail.perches.com ([173.55.12.10]:3937 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1BYX5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 18:57:39 -0500
Subject: [PATCH] platform: Constify samsung-laptop.c
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
In-Reply-To: <20110225224705.GA5706@kroah.com>
References: <20110225224705.GA5706@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 15:57:36 -0800
Message-ID: <1298678256.4002.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sabi_config to const.
Reduces data, increases text ~200 bytes.

$ size drivers/platform/x86/samsung-laptop.o*
   text	   data	    bss	    dec	    hex	filename
   6933	   5084	   1560	  13577	   3509	drivers/platform/x86/samsung-laptop.o.new
   6765	   5252	   1560	  13577	   3509	drivers/platform/x86/samsung-laptop.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/samsung-laptop.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index a8e82b8..720c9eb 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -108,12 +108,12 @@ struct sabi_performance_level {
 struct sabi_config {
 	const char *test_string;
 	u16 main_function;
-	struct sabi_header_offsets header_offsets;
-	struct sabi_commands commands;
-	struct sabi_performance_level performance_levels[4];
+	const struct sabi_header_offsets header_offsets;
+	const struct sabi_commands commands;
+	const struct sabi_performance_level performance_levels[4];
 };
 
-static struct sabi_config sabi_configs[] = {
+static const struct sabi_config sabi_configs[] = {
 	{
 		.test_string = "SECLINUX",
 
@@ -211,7 +211,7 @@ static struct sabi_config sabi_configs[] = {
 	{ },
 };
 
-static struct sabi_config *sabi_config;
+static const struct sabi_config *sabi_config;
 
 static void __iomem *sabi;
 static void __iomem *sabi_iface;
@@ -467,7 +467,7 @@ static ssize_t set_performance_level(struct device *dev,
 	if (count >= 1) {
 		int i;
 		for (i = 0; sabi_config->performance_levels[i].name; ++i) {
-			struct sabi_performance_level *level =
+			const struct sabi_performance_level *level =
 				&sabi_config->performance_levels[i];
 			if (!strncasecmp(level->name, buf, strlen(level->name))) {
 				sabi_set_command(sabi_config->commands.set_performance_level,
-- 
1.7.4.2.g597a6.dirty



