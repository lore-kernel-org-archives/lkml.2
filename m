Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0LQIKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:10:53 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54099 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0LQIKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=t6Usx2PQn34sQ9z3LVFhYy7pGsn4FN0TsOB9L3nII3m7xTV8CRATznPeAX5jkR2A1x
         bBQxbFlyPj7m474h1kmFaFZnda5nicEqpr+tnk/kA1tm0j0TnuweaLKBrJDXgFln6mjz
         8qSnn2SX0i3hrJtbVVQH8JAq8OtQoZ0hIFbwM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        chl.pixo@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/2] staging: ft1000-pcmcia: Fix compilation warning.
Date: Fri, 17 Dec 2010 09:13:12 +0100
Message-Id: <1292573592-3624-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
References: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation warning:
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:
In function ‘ft1000_reset_card’:

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:525:2:
warning: passing argument 2 of ‘card_download’ discards qualifiers from pointer target type

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:56:5:
note: expected ‘void *’ but argument is of type ‘const u8 * const’

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 0bf398d..c56f588 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -310,7 +310,7 @@ USHORT hdr_checksum(PPSEUDO_HDR pHdr)
 	return chksum;
 }
 
-int card_download(struct net_device *dev, void *pFileStart, UINT FileLength)
+int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 {
 	FT1000_INFO *info = (PFT1000_INFO) netdev_priv(dev);
 	int Status = SUCCESS;
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 588afd5..813e184 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -53,7 +53,7 @@
 #include "ft1000_dev.h"
 #include "ft1000.h"
 
-int card_download(struct net_device *dev, void *pFileStart, UINT FileLength);
+int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength);
 
 void ft1000InitProc(struct net_device *dev);
 void ft1000CleanupProc(struct net_device *dev);
-- 
1.7.1

