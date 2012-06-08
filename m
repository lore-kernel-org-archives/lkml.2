Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2FHDpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:45:25 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53381 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2FHDpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:45:23 -0400
Message-ID: <1339127063.32077.8.camel@ThinkPad-T420>
Subject: [PATCH powerpc] fix Section mismatch warnings in prom_init.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Fri, 08 Jun 2012 11:44:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12060717-1618-0000-0000-000001C8F334
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches tries to fix a couple of Section mismatch warnings like
following one:

WARNING: arch/powerpc/kernel/built-in.o(.text+0x2923c): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.call_prom()
The function .prom_query_opal() references
the function __init .call_prom().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .call_prom is wrong.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c
b/arch/powerpc/kernel/prom_init.c
index 1b488e5..0794a30 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1312,7 +1312,7 @@ static struct opal_secondary_data {
 
 extern char opal_secondary_entry;
 
-static void prom_query_opal(void)
+static void __init prom_query_opal(void)
 {
 	long rc;
 
@@ -1436,7 +1436,7 @@ static void __init prom_opal_hold_cpus(void)
 	prom_debug("prom_opal_hold_cpus: end...\n");
 }
 
-static void prom_opal_takeover(void)
+static void __init prom_opal_takeover(void)
 {
 	struct opal_secondary_data *data = &RELOC(opal_secondary_data);
 	struct opal_takeover_args *args = &data->args;
-- 
1.7.1



