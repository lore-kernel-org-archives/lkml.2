Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab1DYR2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:28:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551Ab1DYR2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:28:23 -0400
Subject: should __modver_version_attr be const
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Mon, 25 Apr 2011 13:28:22 -0400
Message-Id: <1303752502.2103.169.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't __modver_version_attr be const? It is placed in section
__modver and asm-generic/vmlinux.lds.h puts section __modver in with
RO_DATA_SECTION. Without the const, section __modver has RW attribute.

diff --git a/include/linux/module.h b/include/linux/module.h
index 5de4204..e62f808 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -174,7 +174,7 @@ extern struct module __this_module;
 #define MODULE_VERSION(_version)					\
 	extern ssize_t __modver_version_show(struct module_attribute *,	\
 					     struct module *, char *);	\
-	static struct module_version_attribute __modver_version_attr	\
+	static const struct module_version_attribute __modver_version_attr \
 	__used								\
     __attribute__ ((__section__ ("__modver"),aligned(sizeof(void *)))) \
 	= {								\


--Mark


