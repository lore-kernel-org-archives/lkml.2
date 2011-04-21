Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1DUGyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:54:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58765 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1DUGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QAoXtihgy51JvjigB8+X+f+iAoSdhPbsN8ijGawmVfhUq/rGDg5tGVMZG2cHKGtzUo
         ovobohWR1QFoUs3B0waW+zWUpTDAT3ze1/E5kv1xZPzaMuC+vRNCv+qQW3/OkgZB62xC
         WoT1d9KCj6jHu/Efdv6kRQV+6WyO4T6ddC0T4=
From: Liu Yuan <namei.unix@gmail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm, ioapic: Fix an error field reference
Date: Thu, 21 Apr 2011 14:53:57 +0800
Message-Id: <1303368838-5620-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

Function ioapic_debug() in the ioapic_deliver() misnames
one filed by reference. This patch correct it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 virt/kvm/ioapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 0b9df83..8df1ca1 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -167,7 +167,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
 		     "vector=%x trig_mode=%x\n",
-		     entry->fields.dest, entry->fields.dest_mode,
+		     entry->fields.dest_id, entry->fields.dest_mode,
 		     entry->fields.delivery_mode, entry->fields.vector,
 		     entry->fields.trig_mode);
 
-- 
1.7.1

