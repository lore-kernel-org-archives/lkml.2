Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0INWkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:40:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20429 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0INWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:40:29 -0400
Date: Tue, 14 Sep 2010 15:39:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging/bcm: fix printk format warnings
Message-Id: <20100914153958.f690ffae.randy.dunlap@oracle.com>
In-Reply-To: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
References: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lots of printk format warnings in bcm.  Here is a sample of them:

drivers/staging/bcm/CmHost.c:1955: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
drivers/staging/bcm/CmHost.c:1955: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
drivers/staging/bcm/CmHost.c:1955: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
drivers/staging/bcm/LeakyBucket.c:85: warning: format '%d' expects type 'int', but argument 4 has type 'long int'
drivers/staging/bcm/LeakyBucket.c:85: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
drivers/staging/bcm/LeakyBucket.c:85: warning: format '%d' expects type 'int', but argument 4 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/bcm/Bcmchar.c |   14 +++++++-------
 drivers/staging/bcm/CmHost.c  |   10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

--- linux-next-20100913.orig/drivers/staging/bcm/Bcmchar.c
+++ linux-next-20100913/drivers/staging/bcm/Bcmchar.c
@@ -1141,7 +1141,7 @@ static INT bcm_char_ioctl(struct inode *
 			}
 			if(IoBuffer.OutputLength < sizeof(stLocalSFAddIndicationAlt))
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Mismatch req: %lx needed is =0x%x!!!",
+				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Mismatch req: %lx needed is =0x%zx!!!",
 					IoBuffer.OutputLength, sizeof(stLocalSFAddIndicationAlt));
 				return -EINVAL;
 			}
@@ -1172,7 +1172,7 @@ static INT bcm_char_ioctl(struct inode *
 
 			if(IoBuffer.OutputLength != sizeof(S_MIBS_HOST_STATS_MIBS))
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Length Check failed %lu %d\n", IoBuffer.OutputLength,
+				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Length Check failed %lu %zd\n", IoBuffer.OutputLength,
 											sizeof(S_MIBS_HOST_STATS_MIBS));
 	          	return -EINVAL;
 			}
@@ -1854,7 +1854,7 @@ static INT bcm_char_ioctl(struct inode *
 				}
 				if(IoBuffer.OutputLength != sizeof(FLASH2X_BITMAP))
 				{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Structure size mismatch Lib :0x%lx Driver :0x%x ",IoBuffer.OutputLength, sizeof(FLASH2X_BITMAP));
+					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Structure size mismatch Lib :0x%lx Driver :0x%zx ",IoBuffer.OutputLength, sizeof(FLASH2X_BITMAP));
 					break;
 				}
 
@@ -2073,7 +2073,7 @@ static INT bcm_char_ioctl(struct inode *
 
 					if(IoBuffer.OutputLength < sizeof(FLASH2X_CS_INFO))
 					{
-						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0," Passed buffer size:0x%lX is insufficient for the CS structure.. \nRequired size :0x%x ",IoBuffer.OutputLength, sizeof(FLASH2X_CS_INFO));
+						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0," Passed buffer size:0x%lX is insufficient for the CS structure.. \nRequired size :0x%zx ",IoBuffer.OutputLength, sizeof(FLASH2X_CS_INFO));
 						Status = -EINVAL;
 						break;
 					}
@@ -2089,7 +2089,7 @@ static INT bcm_char_ioctl(struct inode *
 				{
 					if(IoBuffer.OutputLength < sizeof(FLASH_CS_INFO))
 					{
-						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0," Passed buffer size:0x%lX is insufficient for the CS structure.. Required size :0x%u ",IoBuffer.OutputLength, sizeof(FLASH_CS_INFO));
+						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0," Passed buffer size:0x%lX is insufficient for the CS structure.. Required size :0x%zx ",IoBuffer.OutputLength, sizeof(FLASH_CS_INFO));
 						Status = -EINVAL;
 						break;
 					}
@@ -2296,7 +2296,7 @@ static INT bcm_char_ioctl(struct inode *
 				if(IoBuffer.OutputLength < sizeof(DevInfo))
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"User Passed buffer length is less than actural buffer size");
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"user passed buffer size :0x%lX, expected size :0x%x",IoBuffer.OutputLength, sizeof(DevInfo));
+					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"user passed buffer size :0x%lX, expected size :0x%zx",IoBuffer.OutputLength, sizeof(DevInfo));
 					Status = -EINVAL;
 					break;
 				}
@@ -2324,7 +2324,7 @@ static INT bcm_char_ioctl(struct inode *
 				}
 				if(IoBuffer.OutputLength < sizeof(ST_TIME_ELAPSED))
 				{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"User Passed buffer length:0x%lx is less than expected buff size :0x%X",IoBuffer.OutputLength,sizeof(ST_TIME_ELAPSED));
+					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"User Passed buffer length:0x%lx is less than expected buff size :0x%zX",IoBuffer.OutputLength,sizeof(ST_TIME_ELAPSED));
 					Status = -EINVAL;
 					break;
 				}
--- linux-next-20100913.orig/drivers/staging/bcm/CmHost.c
+++ linux-next-20100913/drivers/staging/bcm/CmHost.c
@@ -1706,9 +1706,9 @@ static inline ULONG RestoreSFParam(PMINI
 		return 0;
 	}
 	ulAddrSFParamSet = ntohl(ulAddrSFParamSet);
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  " RestoreSFParam: Total Words of DSX Message To Read: 0x%x  From Target At : 0x%lx ",
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  " RestoreSFParam: Total Words of DSX Message To Read: 0x%zx  From Target At : 0x%lx ",
 				nBytesToRead/sizeof(ULONG),ulAddrSFParamSet);
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "sizeof(stServiceFlowParamSI) = %x", sizeof(stServiceFlowParamSI));
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "sizeof(stServiceFlowParamSI) = %zx", sizeof(stServiceFlowParamSI));
 
 	//Read out the SF Param Set At the indicated Location
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "nBytesToRead = %x", nBytesToRead);
@@ -1728,7 +1728,7 @@ static __inline ULONG StoreSFParam(PMINI
 	{
 		return 0;
 	}
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  " StoreSFParam: Total Words of DSX Message To Write: 0x%X  To Target At : 0x%lX ",(nBytesToWrite/sizeof(ULONG)),ulAddrSFParamSet);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  " StoreSFParam: Total Words of DSX Message To Write: 0x%zX  To Target At : 0x%lX ",(nBytesToWrite/sizeof(ULONG)),ulAddrSFParamSet);
 
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "WRM  with %x bytes",nBytesToWrite);
 
@@ -1926,7 +1926,7 @@ static inline stLocalSFAddIndicationAlt
 
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Dumping the whole raw packet");
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "============================================================");
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, " pstAddIndicationDest->sfActiveSet size  %x %p", sizeof(*pstAddIndicationDest), pstAddIndicationDest);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, " pstAddIndicationDest->sfActiveSet size  %zx %p", sizeof(*pstAddIndicationDest), pstAddIndicationDest);
 	//BCM_DEBUG_PRINT_BUFFER(Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, (unsigned char *)pstAddIndicationDest, sizeof(*pstAddIndicationDest));
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "============================================================");
 	return pstAddIndicationDest;
@@ -1952,7 +1952,7 @@ ULONG SetUpTargetDsxBuffers(PMINI_ADAPTE
 		 return 0;
 	 }
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Size of Each DSX Buffer(Also size of ServiceFlowParamSI): %x ",sizeof(stServiceFlowParamSI));
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Size of Each DSX Buffer(Also size of ServiceFlowParamSI): %zx ",sizeof(stServiceFlowParamSI));
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "Reading DSX buffer From Target location %x ",DSX_MESSAGE_EXCHANGE_BUFFER);
 
  	Status = rdmalt(Adapter, DSX_MESSAGE_EXCHANGE_BUFFER,
