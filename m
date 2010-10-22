Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0JVXVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:21:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0JVXVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:21:12 -0400
Date: Fri, 22 Oct 2010 16:18:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Keith Mannthey <kmannth@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH -next] ibm_rtl: fix printk format warning
Message-Id: <20101022161847.e70bf995.randy.dunlap@oracle.com>
In-Reply-To: <20101022152350.fc79e2b9.sfr@canb.auug.org.au>
References: <20101022152350.fc79e2b9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/platform/x86/ibm_rtl.c:305:warning: format '%#llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Keith Mannthey <kmannth@us.ibm.com>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/ibm_rtl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101022.orig/drivers/platform/x86/ibm_rtl.c
+++ linux-next-20101022/drivers/platform/x86/ibm_rtl.c
@@ -302,7 +302,7 @@ static int __init ibm_rtl_init(void) {
 			RTL_DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
 			      rtl_cmd_width, rtl_cmd_type);
 			addr = ioread32(&rtl_table->cmd_port_address);
-			RTL_DEBUG("addr = %#llx\n", addr);
+			RTL_DEBUG("addr = %#llx\n", (unsigned long long)addr);
 			plen = rtl_cmd_width/sizeof(char);
 			rtl_cmd_addr = rtl_port_map(addr, plen);
 			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
