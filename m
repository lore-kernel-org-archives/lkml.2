Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1BDMYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:24:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1BDMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cUqQl0v4PzGthXp/Q3Ecy+ASeu4nMxPmSTPLlBPyDvd+DAvDy1Hq9PFD8QPPpt1JGe
         P5jMJogrWa2o5j3g6gIflLwlYPG8rfLuSuw8SsMTEVSLZ2viOXAFhLexaP3P6rxp4fpz
         75c2MNKt58V2bDAkcMOCjOd2NTam6yIE+tr6M=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: [PATCH 13/20] net: can: janz-ican3: world-writable sysfs termination file
Date: Fri,  4 Feb 2011 15:23:53 +0300
Message-Id: <6b49b9521416fbd50214485d3e14e5f254ada4f7.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to set terminator via sysfs.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/net/can/janz-ican3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index b9a6d7a..366f5cc 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1618,7 +1618,7 @@ static ssize_t ican3_sysfs_set_term(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(termination, S_IWUGO | S_IRUGO, ican3_sysfs_show_term,
+static DEVICE_ATTR(termination, S_IWUSR | S_IRUGO, ican3_sysfs_show_term,
 						   ican3_sysfs_set_term);
 
 static struct attribute *ican3_sysfs_attrs[] = {
-- 
1.7.0.4

