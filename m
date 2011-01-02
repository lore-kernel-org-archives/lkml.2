Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1ABHsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:48:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:35933 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1ABHXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 144/260] drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:17:20 -0500
Message-Id: <1293952756-15010-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:47.0822 (UTC) FILETIME=[DB466AE0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit b4aaa78f4c2f9cde2f335b14f4ca30b01f9651ca upstream.

The VIAFB_GET_INFO device ioctl allows unprivileged users to read 246
bytes of uninitialized stack memory, because the "reserved" member of
the viafb_ioctl_info struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of
it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/via/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/ioctl.c b/drivers/video/via/ioctl.c
index da03c07..4d553d0 100644
--- a/drivers/video/via/ioctl.c
+++ b/drivers/video/via/ioctl.c
@@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long arg)
 {
 	struct viafb_ioctl_info viainfo;
 
+	memset(&viainfo, 0, sizeof(struct viafb_ioctl_info));
+
 	viainfo.viafb_id = VIAID;
 	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
 
-- 
1.7.3.3

