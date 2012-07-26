Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2GZDDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:03:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2GZDC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:02:59 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        devel@open-fcoe.org
Cc: Sha Zhengju <handai.szj@taobao.com>, robert.w.love@intel.com
Subject: [PATCH] mainline 3.5, fcoe: remove the __exit annotation of fcoe_transport_exit()
Date: Thu, 26 Jul 2012 11:02:44 +0800
Message-Id: <1343271764-17501-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

While testing linux mainline v3.5, it comes out the following warning:

WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch in reference from the function
init_module() to the function .exit.text:fcoe_transport_exit()
The function __init init_module() references a function __exit fcoe_transport_exit().
This is often seen when error handling in the init function uses functionality in the exit path.
The fix is often to remove the __exit annotation of fcoe_transport_exit() so it may be used outside an exit section.


Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: robert.w.love@intel.com
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b46f43d..71cc909 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
 	return 0;
 }
 
-static int __exit fcoe_transport_exit(void)
+static int fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 
-- 
1.7.1

