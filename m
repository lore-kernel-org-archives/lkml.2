Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2KNF7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:59:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55176 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315Ab2KNFus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:48 -0500
Message-Id: <20121114053940.641117649@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 49/82] target: Dont return success from module_init() if setup fails
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 0d0f9dfb31e0a6c92063e235417b42df185b3275 upstream.

If the call to core_dev_release_virtual_lun0() fails, then nothing
sets ret to anything other than 0, so even though everything is
torn down and freed, target_core_init_configfs() will seem to succeed
and the module will be loaded.  Fix this by passing the return value
on up the chain.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_configfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 015f5be..c123327 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3206,7 +3206,8 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
-	if (core_dev_setup_virtual_lun0() < 0)
+	ret = core_dev_setup_virtual_lun0();
+	if (ret < 0)
 		goto out;
 
 	return 0;


