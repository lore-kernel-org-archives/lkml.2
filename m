Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2DSVNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:13:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65069 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab2DSVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:22 -0400
Message-Id: <20120419210614.091295936@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [ 35/59] pch_phub: Fix register miss-setting issue
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

commit 20ae6d0b307963416db0e8433602e5d5c95e942b upstream.

Register "interrupt delay value" is for GbE which is connected to Bus-m of PCIe.
However currently, the value is set for Bus-n.
As a result, the value is not set correctly.
This patch moves setting the value processing of Bus-n to Bus-m.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/pch_phub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -735,6 +735,8 @@ static int __devinit pch_phub_probe(stru
 		 * Device8(GbE)
 		 */
 		iowrite32(0x000a0000, chip->pch_phub_base_address + 0x14);
+		/* set the interrupt delay value */
+		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
@@ -752,8 +754,6 @@ static int __devinit pch_phub_probe(stru
 		 * Device6(SATA 2):f
 		 */
 		iowrite32(0x0000ffa0, chip->pch_phub_base_address + 0x14);
-		/* set the interrupt delay value */
-		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;


