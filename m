Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab0LOA3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:29:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43432 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0LOA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:29:29 -0500
Date: Tue, 14 Dec 2010 16:26:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, akpm <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] eeepc-wmi: fix function return type to kill warning
Message-Id: <20101214162646.5dd1c0de.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix return type warning:

drivers/platform/x86/eeepc-wmi.c:322: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/eeepc-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2637-rc4.orig/drivers/platform/x86/eeepc-wmi.c
+++ lnx-2637-rc4/drivers/platform/x86/eeepc-wmi.c
@@ -298,7 +298,7 @@ static void eeepc_wmi_notify(u32 value, 
 	kfree(obj);
 }
 
-static int store_cpufv(struct device *dev, struct device_attribute *attr,
+static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
 	int value;
