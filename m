Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1H3TGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:06:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53494 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab1H3TGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:06:53 -0400
From: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Subject: [PATCH 1/1] Free fw_priv in fw_create_instance
Date: Wed, 31 Aug 2011 00:36:32 +0530
Message-Id: <1314731192-1960-1-git-send-email-rajan.aggarwal85@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_priv is not being freed in some of the error scenarios in
fw_create_instance.
This patch makes sure that this is kfreed properly in all error
situations in the fw_create_instance logic where it is required.

Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
---
 drivers/base/firmware_class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 06ed6b4..3ddbc48 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -497,6 +497,7 @@ err_del_dev:
 	device_del(f_dev);
 err_put_dev:
 	put_device(f_dev);
+	kfree(fw_priv);
 err_out:
 	return ERR_PTR(error);
 }
-- 
1.7.4.1

