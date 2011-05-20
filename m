Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab1ETALK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45777 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933217Ab1ETALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:08 -0400
X-Sasl-enc: K+WMlwxtPQDb3a/RA9z8MfgQjktMz9bzqOmEYgYKv+Mh 1305850267
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/44] efivars: memory leak on error in create_efivars_bin_attributes()
Date: Thu, 19 May 2011 17:10:20 -0700
Message-Id: <1305850262-9575-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

This is a cut and paste bug.  We intended to free ->del_var and
->new_var but we only free ->new_var.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff0c373..ff2fe40 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -677,8 +677,8 @@ create_efivars_bin_attributes(struct efivars *efivars)
 
 	return 0;
 out_free:
-	kfree(efivars->new_var);
-	efivars->new_var = NULL;
+	kfree(efivars->del_var);
+	efivars->del_var = NULL;
 	kfree(efivars->new_var);
 	efivars->new_var = NULL;
 	return error;
-- 
1.7.4.2

