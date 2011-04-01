Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1DAGlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38191 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DAGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZWBJqZQafwZ0ynsFIbmo7PjTb2z/GQ/hVUwmGb8twzSiHOhzIfe+J9paK0Ni8z5B6G
         w+cRQWcxhHUXX/mPlAwIBXKc62T3Zzhgb9R8bDQJLku4K8Gi4tWWz4lEcoJ+mNIhHsDg
         wi93j0sqxUiYQfW+yvPClx/Lj9bgZ/hSG+s1Y=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 4/5] staging/keucr: smilmain use pr_<level> for messages
Date: Fri,  1 Apr 2011 14:38:42 +0800
Message-Id: <249d7f9c127bf8cc04c23033ec138494a800da87.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smilmain.c use pr_<level> for messages

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/smilmain.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index 2cbe9f8..311c23b 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -102,12 +102,12 @@ int SM_FreeMem(void)
 {
 	int	i;
 
-	printk("SM_FreeMem start\n");
+	pr_info("SM_FreeMem start\n");
 	for (i=0; i<MAX_ZONENUM; i++)
 	{
 		if (Log2Phy[i]!=NULL)
 		{
-			printk("Free Zone = %x, Addr = %p\n", i, Log2Phy[i]);
+			pr_info("Free Zone = %x, Addr = %p\n", i, Log2Phy[i]);
 			kfree(Log2Phy[i]);
 			Log2Phy[i] = NULL;
 		}
@@ -198,7 +198,7 @@ int Media_D_CopySector(struct us_data *us, DWORD start,WORD count,BYTE *buf)
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
-	//printk("Media_D_CopySector !!!\n");
+	/* pr_info("Media_D_CopySector !!!\n"); */
 	if (Conv_D_MediaAddr(us, start))
 		return(ErrCode);
 
@@ -657,7 +657,7 @@ int Media_D_OneSectWriteFlush(PFDO_DEVICE_EXTENSION fdoExt)
 //----- Check_D_MediaFmt() ---------------------------------------------
 int Check_D_MediaFmt(struct us_data *us)
 {
-	printk("Check_D_MediaFmt\n");
+	pr_info("Check_D_MediaFmt\n");
 	//ULONG i,j, result=FALSE, zone,block;
 
 	//usleep(56*1024);
@@ -1334,7 +1334,7 @@ int Copy_D_PhyOneSect(struct us_data *us)
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
-	//printk("Copy_D_PhyOneSect --- Secotr = %x\n", Media.Sector);
+	/* pr_info("Copy_D_PhyOneSect --- Secotr = %x\n", Media.Sector); */
 	if (ReadBlock!=NO_ASSIGN)
 	{
 		Media.PhyBlock=ReadBlock;
@@ -1620,7 +1620,8 @@ int Make_D_LogTable(struct us_data *us)
 	if (Log2Phy[Media.Zone]==NULL)
 	{
 		Log2Phy[Media.Zone] = kmalloc(MAX_LOGBLOCK*sizeof(WORD), GFP_KERNEL);
-		//printk("ExAllocatePool Zone = %x, Addr = %x\n", Media.Zone, Log2Phy[Media.Zone]);
+		/* pr_info("ExAllocatePool Zone = %x, Addr = %x\n",
+				Media.Zone, Log2Phy[Media.Zone]); */
 		if (Log2Phy[Media.Zone]==NULL)
 			return(ERROR);
 	}
@@ -1630,7 +1631,8 @@ int Make_D_LogTable(struct us_data *us)
 	//for(Media.Zone=0; Media.Zone<MAX_ZONENUM; Media.Zone++)
 	//for(Media.Zone=0; Media.Zone<Ssfdc.MaxZones; Media.Zone++)
 	{
-		//printk("Make_D_LogTable --- MediaZone = 0x%x\n", Media.Zone);
+		/* pr_info("Make_D_LogTable --- MediaZone = 0x%x\n",
+							Media.Zone); */
 		for(Media.LogBlock=0; Media.LogBlock<Ssfdc.MaxLogBlocks; Media.LogBlock++)
 			Log2Phy[Media.Zone][Media.LogBlock]=NO_ASSIGN;
 
-- 
1.7.1

