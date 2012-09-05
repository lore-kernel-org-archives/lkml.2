Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab2IEPOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:14:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:13:59 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org
Subject: [RFC PATCH 1/3] tcm_iscsi: warn on incorrect precondition for iscsit_do_crypto_hash_sg
Date: Wed,  5 Sep 2012 17:13:43 +0200
Message-Id: <1346858025-10459-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While iscsit_do_crypto_hash_sg does look at cmd->first_data_sg_off
when computing cur_len, it ignores it completely when computing the
hash.  As a result, the first cmd->first_data_sg_off bytes are
included in the hash even though they should not.  Warn if this
happens.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 97c0f78..224679e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1135,6 +1135,7 @@ static u32 iscsit_do_crypto_hash_sg(
 
 	sg = cmd->first_data_sg;
 	page_off = cmd->first_data_sg_off;
+	WARN_ON(page_off != sg->offset);
 
 	i = 0;
 	while (data_length) {
-- 
1.7.1


