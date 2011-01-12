Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1ALUUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:20:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ALUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:20:33 -0500
Date: Wed, 12 Jan 2011 12:20:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH -next] x86/e820: fix build when ACPI is disabled
Message-Id: <20110112122014.2d8455d7.randy.dunlap@oracle.com>
In-Reply-To: <20110112141822.c29314c4.sfr@canb.auug.org.au>
References: <20110112141822.c29314c4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_ACPI is not enabled:

arch/x86/kernel/e820.c:734: error:implicit declaration of function 'suspend_nvs_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/acpi.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20110112.orig/include/linux/acpi.h
+++ linux-next-20110112/include/linux/acpi.h
@@ -360,5 +360,10 @@ static inline int acpi_table_parse(char 
 {
 	return -1;
 }
+
+static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+{
+	return 0;
+}
 #endif	/* !CONFIG_ACPI */
 #endif	/*_LINUX_ACPI_H*/
