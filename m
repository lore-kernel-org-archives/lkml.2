Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2K1Tmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:42:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43246 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab2K1Tmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:42:35 -0500
Message-ID: <50B66922.9090209@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 13:42:26 -0600
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] export of_reconfig_notifier_[register,unregister]
References: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
In-Reply-To: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112819-5930-0000-0000-00000EC07E46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of reconfiguration notification chains should be exported for use
by modules.

Signed-off-by:Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
Index: linux-next/drivers/of/base.c
===================================================================
--- linux-next.orig/drivers/of/base.c	2012-11-28 09:18:02.000000000 -0600
+++ linux-next/drivers/of/base.c	2012-11-28 11:05:00.000000000 -0600
@@ -1282,11 +1282,13 @@
 {
 	return blocking_notifier_chain_register(&of_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(of_reconfig_notifier_register);
 
 int of_reconfig_notifier_unregister(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&of_reconfig_chain, nb);
 }
+EXPORT_SYMBOL_GPL(of_reconfig_notifier_unregister);
 
 int of_reconfig_notify(unsigned long action, void *p)
 {

