Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1CUXPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:06 -0400
Received: from kroah.org ([198.145.64.141]:49197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab1CUXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.377501781@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antony Pavlov <antony@niisi.msk.ru>,
        Guillaume LECERF <glecerf@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [02/87] mtd: jedec_probe: Change variable name from cfi_p to cfi
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Antony Pavlov <antony@niisi.msk.ru>

commit efba2e313ea1b1bd69a7c4659263becf43bb1adc upstream.

In the following commit, we'll need to use the CMD() macro in order to
fix the initialisation of the sector_erase_cmd field. That requires the
local variable to be called 'cfi', so change it first in a simple patch.

Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
Acked-by: Guillaume LECERF <glecerf@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/chips/jedec_probe.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1935,14 +1935,14 @@ static void jedec_reset(u32 base, struct
 }
 
 
-static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
+static int cfi_jedec_setup(struct cfi_private *cfi, int index)
 {
 	int i,num_erase_regions;
 	uint8_t uaddr;
 
-	if (! (jedec_table[index].devtypes & p_cfi->device_type)) {
+	if (!(jedec_table[index].devtypes & cfi->device_type)) {
 		DEBUG(MTD_DEBUG_LEVEL1, "Rejecting potential %s with incompatible %d-bit device type\n",
-		      jedec_table[index].name, 4 * (1<<p_cfi->device_type));
+		      jedec_table[index].name, 4 * (1<<cfi->device_type));
 		return 0;
 	}
 
@@ -1950,27 +1950,27 @@ static int cfi_jedec_setup(struct cfi_pr
 
 	num_erase_regions = jedec_table[index].nr_regions;
 
-	p_cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
-	if (!p_cfi->cfiq) {
+	cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
+	if (!cfi->cfiq) {
 		//xx printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
 		return 0;
 	}
 
-	memset(p_cfi->cfiq,0,sizeof(struct cfi_ident));
+	memset(cfi->cfiq, 0, sizeof(struct cfi_ident));
 
-	p_cfi->cfiq->P_ID = jedec_table[index].cmd_set;
-	p_cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
-	p_cfi->cfiq->DevSize = jedec_table[index].dev_size;
-	p_cfi->cfi_mode = CFI_MODE_JEDEC;
+	cfi->cfiq->P_ID = jedec_table[index].cmd_set;
+	cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
+	cfi->cfiq->DevSize = jedec_table[index].dev_size;
+	cfi->cfi_mode = CFI_MODE_JEDEC;
 
 	for (i=0; i<num_erase_regions; i++){
-		p_cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
+		cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
 	}
-	p_cfi->cmdset_priv = NULL;
+	cfi->cmdset_priv = NULL;
 
 	/* This may be redundant for some cases, but it doesn't hurt */
-	p_cfi->mfr = jedec_table[index].mfr_id;
-	p_cfi->id = jedec_table[index].dev_id;
+	cfi->mfr = jedec_table[index].mfr_id;
+	cfi->id = jedec_table[index].dev_id;
 
 	uaddr = jedec_table[index].uaddr;
 
@@ -1978,8 +1978,8 @@ static int cfi_jedec_setup(struct cfi_pr
 	   our brains explode when we see the datasheets talking about address
 	   lines numbered from A-1 to A18. The CFI table has unlock addresses
 	   in device-words according to the mode the device is connected in */
-	p_cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / p_cfi->device_type;
-	p_cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / p_cfi->device_type;
+	cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / cfi->device_type;
+	cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / cfi->device_type;
 
 	return 1;	/* ok */
 }


