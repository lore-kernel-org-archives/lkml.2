Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2KJCVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 21:21:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:40565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2KJCVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 21:21:41 -0500
Message-ID: <509DC837.6040007@infradead.org>
Date: Fri, 09 Nov 2012 19:21:27 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH] rapidio: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix rapidio kernel-doc warnings:

Warning(drivers/rapidio/rio.c:415): No description found for parameter 'local'
Warning(drivers/rapidio/rio.c:415): Excess function parameter 'lstart' description in 'rio_map_inb_region'
Warning(include/linux/rio.h:290): No description found for parameter 'switches'
Warning(include/linux/rio.h:290): No description found for parameter 'destid_table'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Matt Porter <mporter@kernel.crashing.org>
Cc:	Alexandre Bounine <alexandre.bounine@idt.com>
---
 drivers/rapidio/rio.c |    2 +-
 include/linux/rio.h   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- lnx-37-rc4.orig/include/linux/rio.h
+++ lnx-37-rc4/include/linux/rio.h
@@ -275,9 +275,11 @@ struct rio_id_table {
  * struct rio_net - RIO network info
  * @node: Node in global list of RIO networks
  * @devices: List of devices in this network
+ * @switches: List of switches in this netowrk
  * @mports: List of master ports accessing this network
  * @hport: Default port for accessing this network
  * @id: RIO network ID
+ * @destid_table: destID allocation table
  */
 struct rio_net {
 	struct list_head node;	/* node in list of networks */
--- lnx-37-rc4.orig/drivers/rapidio/rio.c
+++ lnx-37-rc4/drivers/rapidio/rio.c
@@ -401,7 +401,7 @@ EXPORT_SYMBOL_GPL(rio_release_inb_pwrite
 /**
  * rio_map_inb_region -- Map inbound memory region.
  * @mport: Master port.
- * @lstart: physical address of memory region to be mapped
+ * @local: physical address of memory region to be mapped
  * @rbase: RIO base address assigned to this window
  * @size: Size of the memory region
  * @rflags: Flags for mapping.
