Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0E1WKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:10:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59073 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0E1WKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:10:00 -0400
Date: Fri, 28 May 2010 15:08:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Alexandre Bounine <alexandre.bounine@idt.com>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] rapidio: fix new kernel-doc warnings
Message-Id: <20100528150808.ebac6402.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C003F24.01B4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a bunch of new rapidio kernel-doc warnings:

Warning(include/linux/rio.h:123): No description found for parameter 'comp_tag'
Warning(include/linux/rio.h:123): No description found for parameter 'phys_efptr'
Warning(include/linux/rio.h:123): No description found for parameter 'em_efptr'
Warning(include/linux/rio.h:123): No description found for parameter 'pwcback'
Warning(include/linux/rio.h:247): No description found for parameter 'set_domain'
Warning(include/linux/rio.h:247): No description found for parameter 'get_domain'
Warning(drivers/rapidio/rio-scan.c:1133): No description found for parameter 'rdev'
Warning(drivers/rapidio/rio-scan.c:1133): Excess function parameter 'port' description in 'rio_init_em'
Warning(drivers/rapidio/rio.c:349): No description found for parameter 'rdev'
Warning(drivers/rapidio/rio.c:349): Excess function parameter 'mport' description in 'rio_request_inb_pwrite'
Warning(drivers/rapidio/rio.c:393): No description found for parameter 'port'
Warning(drivers/rapidio/rio.c:393): No description found for parameter 'local'
Warning(drivers/rapidio/rio.c:393): No description found for parameter 'destid'
Warning(drivers/rapidio/rio.c:393): No description found for parameter 'hopcount'
Warning(drivers/rapidio/rio.c:393): Excess function parameter 'rdev' description in 'rio_mport_get_physefb'
Warning(drivers/rapidio/rio.c:845): Excess function parameter 'local' description in 'rio_std_route_clr_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
---
 drivers/rapidio/rio-scan.c |    2 +-
 drivers/rapidio/rio.c      |   10 ++++++----
 include/linux/rio.h        |    6 ++++++
 3 files changed, 13 insertions(+), 5 deletions(-)

--- linux-2.6.34-git14.orig/drivers/rapidio/rio-scan.c
+++ linux-2.6.34-git14/drivers/rapidio/rio-scan.c
@@ -1124,7 +1124,7 @@ static void rio_update_route_tables(stru
 
 /**
  * rio_init_em - Initializes RIO Error Management (for switches)
- * @port: Master port associated with the RIO network
+ * @rdev: RIO device
  *
  * For each enumerated switch, call device-specific error management
  * initialization routine (if supplied by the switch driver).
--- linux-2.6.34-git14.orig/drivers/rapidio/rio.c
+++ linux-2.6.34-git14/drivers/rapidio/rio.c
@@ -338,7 +338,7 @@ int rio_release_outb_dbell(struct rio_de
 
 /**
  * rio_request_inb_pwrite - request inbound port-write message service
- * @mport: RIO device to which register inbound port-write callback routine
+ * @rdev: RIO device to which register inbound port-write callback routine
  * @pwcback: Callback routine to execute when port-write is received
  *
  * Binds a port-write callback function to the RapidIO device.
@@ -385,7 +385,10 @@ EXPORT_SYMBOL_GPL(rio_release_inb_pwrite
 /**
  * rio_mport_get_physefb - Helper function that returns register offset
  *                      for Physical Layer Extended Features Block.
- * @rdev: RIO device
+ * @port: Master port to issue transaction
+ * @local: Indicate a local master port or remote device access
+ * @destid: Destination ID of the device
+ * @hopcount: Number of switch hops to the device
  */
 u32
 rio_mport_get_physefb(struct rio_mport *port, int local,
@@ -430,7 +433,7 @@ rio_mport_get_physefb(struct rio_mport *
 
 /**
  * rio_get_comptag - Begin or continue searching for a RIO device by component tag
- * @comp_tag: RIO component tad to match
+ * @comp_tag: RIO component tag to match
  * @from: Previous RIO device found in search, or %NULL for new search
  *
  * Iterates through the list of known RIO devices. If a RIO device is
@@ -835,7 +838,6 @@ int rio_std_route_get_entry(struct rio_m
  * rio_std_route_clr_table - Clear swotch route table using standard registers
  *   defined in RIO specification rev.1.3.
  * @mport: Master port to issue transaction
- * @local: Indicate a local master port or remote device access
  * @destid: Destination ID of the device
  * @hopcount: Number of switch hops to the device
  * @table: routing table ID (global or port-specific)
--- linux-2.6.34-git14.orig/include/linux/rio.h
+++ linux-2.6.34-git14/include/linux/rio.h
@@ -88,11 +88,15 @@ union rio_pw_msg;
  * @swpinfo: Switch port info
  * @src_ops: Source operation capabilities
  * @dst_ops: Destination operation capabilities
+ * @comp_tag: RIO component tag
+ * @phys_efptr: RIO device extended features pointer
+ * @em_efptr: RIO Error Management features pointer
  * @dma_mask: Mask of bits of RIO address this device implements
  * @rswitch: Pointer to &struct rio_switch if valid for this device
  * @driver: Driver claiming this device
  * @dev: Device model device
  * @riores: RIO resources this device owns
+ * @pwcback: port-write callback function for this device
  * @destid: Network destination ID
  */
 struct rio_dev {
@@ -222,6 +226,8 @@ struct rio_net {
  * @add_entry: Callback for switch-specific route add function
  * @get_entry: Callback for switch-specific route get function
  * @clr_table: Callback for switch-specific clear route table function
+ * @set_domain: Callback for switch-specific domain setting function
+ * @get_domain: Callback for switch-specific domain get function
  * @em_init: Callback for switch-specific error management initialization function
  * @em_handle: Callback for switch-specific error management handler function
  */
