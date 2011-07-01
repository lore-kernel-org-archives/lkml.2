Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1GAIWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:22:35 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60271 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1GAIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:22:33 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] kernel: auditfilter: replace kmalloc+memset with kzalloc
Date: Fri,  1 Jul 2011 20:21:58 +1200
Message-Id: <1309508518-23586-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced a kmalloc+memset pair with a single call to kzalloc.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 kernel/auditfilter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f8277c8..d0af29d 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -603,10 +603,9 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 	void *bufp;
 	int i;
 
-	data = kmalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);
+	data = kzalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);
 	if (unlikely(!data))
 		return NULL;
-	memset(data, 0, sizeof(*data));
 
 	data->flags = krule->flags | krule->listnr;
 	data->action = krule->action;
-- 
1.7.4.1

