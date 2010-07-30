Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0G3IW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:22:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33552 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0G3IW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w8rmRs/3MsEVgqOxCXKbCYQ5l8kCveneraqvThe0O9bczVPTOn3lp4LTEYQX7WYVqG
         i7SggmIKkygUxSCxGs8F3ebtuSiFxIJuu2S9VH5jdILAdlACtzf6yXaywVyzUwaRNrVF
         f7IuEvdr0D6+/gprDIa7EI70iAFgEyRmafAOM=
Date: Fri, 30 Jul 2010 10:22:19 +0200
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Remove PUINT from ttype.h
Message-ID: <4c528bbe.887b0e0a.3c98.5bcb@mx.google.com>
References: <1278973682-25540-1-git-send-email-roel.vannyen@gmail.com>
 <20100722184435.GB32116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722184435.GB32116@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:44:35AM -0700, Greg KH wrote:
> On Tue, Jul 13, 2010 at 12:28:02AM +0200, Roel Van Nyen wrote:
> > Remove PUINT from ttype.h and change it to unsigned int *
> > 
> > Signed-of-by Roel Van Nyen <roel.vannyen@gmail.com>
> > ---
> 
> Please run your patches through the scripts/checkpatch.pl script before
> sending them to me.  I can't add new warnings to the drivers, sorry.
> 
> thanks,
> 
> greg k-hi
Hi Greg,

I have re-done the patch, this time without any checkpatch.pl warnings.

Remove PUINT from ttype.h

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |    4 ++--
 drivers/staging/vt6656/bssdb.h |    4 ++--
 drivers/staging/vt6656/dpc.c   |    8 ++++----
 drivers/staging/vt6656/ttype.h |    1 -
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 830dd23..4c604db 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -736,7 +736,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
 BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
-		       PUINT puNodeIndex)
+		       unsigned int *puNodeIndex)
 {
     PSDevice        pDevice = (PSDevice)hDeviceContext;
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
@@ -768,7 +768,7 @@ BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
  *    None
  *
 -*/
-void BSSvCreateOneNode(void *hDeviceContext, PUINT puNodeIndex)
+void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
 {
 
     PSDevice     pDevice = (PSDevice)hDeviceContext;
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index c3aaefe..f1bd38b 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -278,9 +278,9 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
 BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
-		       PUINT puNodeIndex);
+		       unsigned int *puNodeIndex);
 
-void BSSvCreateOneNode(void *hDeviceContext, PUINT puNodeIndex);
+void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex);
 
 void BSSvUpdateAPNode(void *hDeviceContext,
 		      PWORD pwCapInfo,
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 81ce46f..4f7e778 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -80,7 +80,7 @@ static
 void
 s_vGetDASA(
       PBYTE pbyRxBufferAddr,
-     PUINT pcbHeaderSize,
+     unsigned int *pcbHeaderSize,
      PSEthernetHeader psEthHeader
     );
 
@@ -92,7 +92,7 @@ s_vProcessRxMACHeader (
       unsigned int cbPacketSize,
       BOOL bIsWEP,
       BOOL bExtIV,
-     PUINT pcbHeadSize
+     unsigned int *pcbHeadSize
     );
 
 static BOOL s_bAPModeRxCtl(
@@ -167,7 +167,7 @@ s_vProcessRxMACHeader (
       unsigned int cbPacketSize,
       BOOL bIsWEP,
       BOOL bExtIV,
-     PUINT pcbHeadSize
+     unsigned int *pcbHeadSize
     )
 {
     PBYTE           pbyRxBuffer;
@@ -261,7 +261,7 @@ static
 void
 s_vGetDASA (
       PBYTE pbyRxBufferAddr,
-     PUINT pcbHeaderSize,
+     unsigned int *pcbHeaderSize,
      PSEthernetHeader psEthHeader
     )
 {
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 3425773..fd78135 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -87,7 +87,6 @@ typedef unsigned long   ULONG_PTR;      // 32-bit
 typedef unsigned long   DWORD_PTR;      // 32-bit
 
 // boolean pointer
-typedef unsigned int *   PUINT;
 
 typedef BYTE *           PBYTE;
 
-- 
1.7.0.4


