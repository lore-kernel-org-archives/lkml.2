Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0IBMYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:24:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56119 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0IBMYm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:24:42 -0400
Message-Id: <4C7FB3A80200007800013F22@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:24:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <rusty@rustcorp.com.au>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] no need to align .modinfo strings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Their use is not performance critical, and hence it seems better to
save some space.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/moduleparam.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.36-rc3/include/linux/moduleparam.h
+++ 2.6.36-rc3-modinfo-align/include/linux/moduleparam.h
@@ -21,8 +21,8 @@
 #define __module_cat(a,b) ___module_cat(a,b)
 #define __MODULE_INFO(tag, name, info)					  \
 static const char __module_cat(name,__LINE__)[]				  \
-  __used								  \
-  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
+  __used __attribute__((section(".modinfo"), unused, aligned(1)))	  \
+  = __stringify(tag) "=" info
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
 #endif



