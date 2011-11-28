Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1K1MkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:40:20 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53245 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1K1MkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:40:18 -0500
Message-ID: <4ED3811F.1070101@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 20:39:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/5] jump-label: export jump_label_inc/jump_label_dec
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112802-5140-0000-0000-000000544597
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export these two symbols, they will be used by mmu audit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 kernel/jump_label.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index bbdfe2a..7d3d452 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -70,6 +70,7 @@ void jump_label_inc(struct jump_label_key *key)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
 	jump_label_unlock();
 }
+EXPORT_SYMBOL_GPL(jump_label_inc);

 void jump_label_dec(struct jump_label_key *key)
 {
@@ -79,6 +80,7 @@ void jump_label_dec(struct jump_label_key *key)
 	jump_label_update(key, JUMP_LABEL_DISABLE);
 	jump_label_unlock();
 }
+EXPORT_SYMBOL_GPL(jump_label_dec);

 static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 {
-- 
1.7.7.3

