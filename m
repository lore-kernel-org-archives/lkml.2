Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1FTFro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:47:44 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:35746
	"EHLO qmta01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab1FTFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:33 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/22] staging: usbip: userspace: usbip: modify command failure
Date: Sun, 19 Jun 2011 22:44:39 -0700
Message-Id: <2bb10c928e0daa3fe8d4010b1f802f4d7052b213.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a bad option is given, display a message stating such and output
usage. When a bad command is given, output command help.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index cdfe4c2..583b179 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -125,13 +125,13 @@ static int usbip_version(int argc, char *argv[])
 	(void) argc;
 	(void) argv;
 
-	printf("%s\n", usbip_version_string);
+	printf(PROGNAME " (%s)\n", usbip_version_string);
 	return 0;
 }
 
 static int run_command(const struct command *cmd, int argc, char *argv[])
 {
-	dbg("running command: `%s'\n", cmd->name);
+	dbg("running command: `%s'", cmd->name);
 	return cmd->fn(argc, argv);
 }
 
@@ -163,8 +163,11 @@ int main(int argc, char *argv[])
 			usbip_use_syslog = 1;
 			openlog("", LOG_PID, LOG_USER);
 			break;
+		case '?':
+			printf("usbip: invalid option\n");
 		default:
-			goto err_out;
+			usbip_usage();
+			goto out;
 		}
 	}
 
@@ -180,8 +183,8 @@ int main(int argc, char *argv[])
 			}
 	}
 
-err_out:
-	usbip_usage();
+	/* invalid command */
+	usbip_help(0, NULL);
 out:
 	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
 }
-- 
1.7.5.2

