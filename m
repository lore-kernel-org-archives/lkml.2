Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3AIXKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:10:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36297 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3AIXKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:10:39 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/5] module: constify within_module_*
Date: Wed,  9 Jan 2013 18:09:16 -0500
Message-Id: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These helper functions just check a set intersection with a range, and
don't actually modify struct module.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/module.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 7760c6d..2e5d49e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -396,13 +396,13 @@ bool is_module_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
-static inline int within_module_core(unsigned long addr, struct module *mod)
+static inline int within_module_core(unsigned long addr, const struct module *mod)
 {
 	return (unsigned long)mod->module_core <= addr &&
 	       addr < (unsigned long)mod->module_core + mod->core_size;
 }
 
-static inline int within_module_init(unsigned long addr, struct module *mod)
+static inline int within_module_init(unsigned long addr, const struct module *mod)
 {
 	return (unsigned long)mod->module_init <= addr &&
 	       addr < (unsigned long)mod->module_init + mod->init_size;
-- 
1.8.1

