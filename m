Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1C2W1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:27:18 -0400
Received: from mail.perches.com ([173.55.12.10]:4347 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1C2WWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:13 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/23] ibm_rtl: Remove warnings from casts of pointer to int
Date: Tue, 29 Mar 2011 15:21:33 -0700
Message-Id: <eb6d14b87417ac78c65dde4997f8ccb842391732.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just print them as %p.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/ibm_rtl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 94a114a..f0b0683 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -275,7 +275,7 @@ static int __init ibm_rtl_init(void) {
 		if ((readq(&tmp->signature) & RTL_MASK) == RTL_SIGNATURE) {
 			phys_addr_t addr;
 			unsigned int plen;
-			RTL_DEBUG("found RTL_SIGNATURE at %#llx\n", (u64)tmp);
+			RTL_DEBUG("found RTL_SIGNATURE at %p\n", tmp);
 			rtl_table = tmp;
 			/* The address, value, width and offset are platform
 			 * dependent and found in the ibm_rtl_table */
@@ -287,7 +287,7 @@ static int __init ibm_rtl_init(void) {
 			RTL_DEBUG("addr = %#llx\n", (unsigned long long)addr);
 			plen = rtl_cmd_width/sizeof(char);
 			rtl_cmd_addr = rtl_port_map(addr, plen);
-			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
+			RTL_DEBUG("rtl_cmd_addr = %p\n", rtl_cmd_addr);
 			if (!rtl_cmd_addr) {
 				ret = -ENOMEM;
 				break;
-- 
1.7.4.2.g597a6.dirty

