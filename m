Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab1CIOSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:18:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42467 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1CIOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:18:43 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ibm_rtl: Fix casting
To: linux-kernel@vger.kernel.org, mjg@redht.com
Date: Wed, 09 Mar 2011 13:57:50 +0000
Message-ID: <20110309135746.26054.11486.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix silly warnings in the build caused by non-use of %p

Signed-off-by: Alan Cox <alan@linux.intel.com>
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

