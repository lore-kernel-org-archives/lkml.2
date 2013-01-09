Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3AIEDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:03:49 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:32883 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab3AIEDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:03:48 -0500
From: Benoit Goby <benoit@android.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Goby <benoit@android.com>
Subject: [PATCH] usb: gadget: FunctionFS: Fix missing braces in parse_opts
Date: Tue,  8 Jan 2013 19:57:09 -0800
Message-Id: <1357703829-26621-1-git-send-email-benoit@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing braces around an if block in ffs_fs_parse_opts. This broke
parsing the uid/gid mount options and causes mount to fail when using
uid/gid. This has been introduced by commit b9b73f7c (userns: Convert usb
functionfs to use kuid/kgid where appropriate) in 3.7.

Signed-off-by: Benoit Goby <benoit@android.com>
---
 drivers/usb/gadget/f_fs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 4a6961c..8c2f251 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1153,15 +1153,15 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 					pr_err("%s: unmapped value: %lu\n", opts, value);
 					return -EINVAL;
 				}
-			}
-			else if (!memcmp(opts, "gid", 3))
+			} else if (!memcmp(opts, "gid", 3)) {
 				data->perms.gid = make_kgid(current_user_ns(), value);
 				if (!gid_valid(data->perms.gid)) {
 					pr_err("%s: unmapped value: %lu\n", opts, value);
 					return -EINVAL;
 				}
-			else
+			} else {
 				goto invalid;
+			}
 			break;
 
 		default:
-- 
1.7.7.3

