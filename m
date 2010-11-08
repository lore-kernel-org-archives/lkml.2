Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0KHXWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:22:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19384 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab0KHXWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:22:02 -0500
Date: Tue, 9 Nov 2010 00:10:35 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Nicolas Kaiser <nikai@nikai.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 14/17][trivial] staging, spectra: Remove unnecessary casts
 of void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082355410.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/staging/spectra/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 lld_emu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/spectra/lld_emu.c b/drivers/staging/spectra/lld_emu.c
index 6733bbf..095f2f0 100644
--- a/drivers/staging/spectra/lld_emu.c
+++ b/drivers/staging/spectra/lld_emu.c
@@ -180,10 +180,8 @@ u16 emu_Flash_Init(void)
 	nand_dbg_print(NAND_DBG_TRACE, "%s, Line %d, Function: %s\n",
 		       __FILE__, __LINE__, __func__);
 
-	flash_memory[0] = (u8 *)vmalloc(GLOB_LLD_PAGE_SIZE *
-						   GLOB_LLD_BLOCKS *
-						   GLOB_LLD_PAGES *
-						   sizeof(u8));
+	flash_memory[0] = vmalloc(GLOB_LLD_PAGE_SIZE * GLOB_LLD_BLOCKS *
+				  GLOB_LLD_PAGES * sizeof(u8));
 	if (!flash_memory[0]) {
 		printk(KERN_ERR "Fail to allocate memory "
 		       "for nand emulator!\n");



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

