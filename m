Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0KHXVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19325 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0KHXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:42 -0500
Date: Tue, 9 Nov 2010 00:10:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/17][trivial] staging, keucr: Remove unnecessary casts of
 void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082349120.23697@swampdragon.chaosbits.net>
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

This patch removes such casts from drivers/staging/keucr/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ms.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index d4340a9..64778b1 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -347,7 +347,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 	BYTE                     *PageBuffer;
 	MS_LibTypeExtdat         ExtraData;
 
-	if ((PageBuffer = (BYTE *)kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL))==NULL)
+	if ((PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL))==NULL)
 		return (DWORD)-1;
 
 	result = (DWORD)-1;
@@ -480,8 +480,8 @@ int MS_LibAllocLogicalMap(struct us_data *us)
 	DWORD  i;
 
 
-	us->MS_Lib.Phy2LogMap = (WORD *)kmalloc(us->MS_Lib.NumberOfPhyBlock * sizeof(WORD), GFP_KERNEL);
-	us->MS_Lib.Log2PhyMap = (WORD *)kmalloc(us->MS_Lib.NumberOfLogBlock * sizeof(WORD), GFP_KERNEL);
+	us->MS_Lib.Phy2LogMap = kmalloc(us->MS_Lib.NumberOfPhyBlock * sizeof(WORD), GFP_KERNEL);
+	us->MS_Lib.Log2PhyMap = kmalloc(us->MS_Lib.NumberOfLogBlock * sizeof(WORD), GFP_KERNEL);
 
 	if ((us->MS_Lib.Phy2LogMap == NULL) || (us->MS_Lib.Log2PhyMap == NULL))
 	{
@@ -610,8 +610,8 @@ int MS_LibAllocWriteBuf(struct us_data *us)
 {
 	us->MS_Lib.wrtblk = (WORD)-1;
 
-	us->MS_Lib.blkpag = (BYTE *)kmalloc(us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector, GFP_KERNEL);
-	us->MS_Lib.blkext = (MS_LibTypeExtdat *)kmalloc(us->MS_Lib.PagesPerBlock * sizeof(MS_LibTypeExtdat), GFP_KERNEL);
+	us->MS_Lib.blkpag = kmalloc(us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector, GFP_KERNEL);
+	us->MS_Lib.blkext = kmalloc(us->MS_Lib.PagesPerBlock * sizeof(MS_LibTypeExtdat), GFP_KERNEL);
 
 	if ((us->MS_Lib.blkpag == NULL) || (us->MS_Lib.blkext == NULL))
 	{


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

