Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0LIPLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:40 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0LIPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PrcKYLsLusKEnLTbpw3EbSET6Ecg3UDjjwHRcPzt330QeMyXTA5sOscblu2r8u6THx
         qtjJRRLDI9gFUXHcHXFYhho01gQrNqatbi+/5iJbiKj0vgRElpUg4GUyz0xN/zmvAl1a
         wrNK+Z9IJa0FrmdFtVk9+vRJgUW1620gFPm08=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/8] staging: ft1000: Coding style fix in ft1000ReadProc.
Date: Thu,  9 Dec 2010 16:13:51 +0100
Message-Id: <1291907634-22437-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |  216 +++++++++++------------
 1 files changed, 106 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index c3fca23..773316f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -43,126 +43,122 @@ u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
 
 
 static int
-ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
+ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 		void *data)
 {
-  struct net_device *dev;
-  int len;
-  int i;
-  unsigned short ledStat;
-  unsigned short conStat;
+	struct net_device *dev;
+	int len;
+	int i;
+	unsigned short ledStat;
+	unsigned short conStat;
 
 	struct ft1000_info *info;
 
-  char *status[] = { "Idle (Disconnect)", "Searching", "Active (Connected)",
-    "Waiting for L2", "Sleep", "No Coverage", "", ""
-  };
-
-  char *signal[] = { "", "*", "**", "***", "****" };
-  int strength;
-  int quality;
-  struct timeval tv;
-  time_t delta;
-
-  dev = (struct net_device *) data;
+	char *status[] = { 
+		"Idle (Disconnect)", 
+		"Searching",
+		"Active (Connected)",
+		"Waiting for L2",
+		"Sleep",
+		"No Coverage",
+		"",
+		"",
+	};
+
+	char *signal[] = { "", "*", "**", "***", "****" };
+	int strength;
+	int quality;
+	struct timeval tv;
+	time_t delta;
+
+	dev = (struct net_device *) data;
 	info = netdev_priv(dev);
 
-  if (off > 0)
-    {
-      *eof = 1;
-      return 0;
-    }
+	if (off > 0) {
+		*eof = 1;
+		return 0;
+	}
 
 
-  if (info->ProgConStat != 0xFF)
-    {
-      ft1000_read_dpram16 (info->pFt1000Dev, FT1000_MAG_DSP_LED,
+	if (info->ProgConStat != 0xFF) {
+		ft1000_read_dpram16(info->pFt1000Dev, FT1000_MAG_DSP_LED,
 			   (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
-      info->LedStat = ntohs (ledStat);
-
-      ft1000_read_dpram16 (info->pFt1000Dev, FT1000_MAG_DSP_CON_STATE,
-			   (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
-      info->ConStat = ntohs (conStat);
-      do_gettimeofday (&tv);
-      delta = (tv.tv_sec - info->ConTm);
-    }
-  else
-    {
-      info->ConStat = 0xf;
-      delta = 0;
-    }
-
-
-
-  i = (info->LedStat) & 0xf;
-  switch (i)
-    {
-    case 0x1:
-      strength = 1;
-      break;
-    case 0x3:
-      strength = 2;
-      break;
-    case 0x7:
-      strength = 3;
-      break;
-    case 0xf:
-      strength = 4;
-      break;
-    default:
-      strength = 0;
-    }
-
-  i = (info->LedStat >> 8) & 0xf;
-  switch (i)
-    {
-    case 0x1:
-      quality = 1;
-      break;
-    case 0x3:
-      quality = 2;
-      break;
-    case 0x7:
-      quality = 3;
-      break;
-    case 0xf:
-      quality = 4;
-      break;
-    default:
-      quality = 0;
-    }
-
-
-  len = 0;
-  PUTM_TO_PAGE (len, page, "Connection Time: %02ld:%02ld:%02ld\n",
-		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
-  PUTM_TO_PAGE (len, page, "Connection Time[s]: %ld\n", delta);
-  PUTM_TO_PAGE (len, page, "Asic ID: %s\n",
-		(info->AsicID) ==
-		ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
-  PUTX_TO_PAGE (len, page, "SKU: ", SKUSZ, info->Sku);
-  PUTX_TO_PAGE (len, page, "EUI64: ", EUISZ, info->eui64);
-  PUTD_TO_PAGE (len, page, "DSP version number: ", DSPVERSZ, info->DspVer);
-  PUTX_TO_PAGE (len, page, "Hardware Serial Number: ", HWSERNUMSZ,
-		info->HwSerNum);
-  PUTX_TO_PAGE (len, page, "Caliberation Version: ", CALVERSZ,
-		info->RfCalVer);
-  PUTD_TO_PAGE (len, page, "Caliberation Date: ", CALDATESZ, info->RfCalDate);
-  PUTM_TO_PAGE (len, page, "Media State: %s\n",
-		(info->mediastate) ? "link" : "no link");
-  PUTM_TO_PAGE (len, page, "Connection Status: %s\n",
-		status[((info->ConStat) & 0x7)]);
-  PUTM_TO_PAGE (len, page, "RX packets: %ld\n", info->stats.rx_packets);
-  PUTM_TO_PAGE (len, page, "TX packets: %ld\n", info->stats.tx_packets);
-  PUTM_TO_PAGE (len, page, "RX bytes: %ld\n", info->stats.rx_bytes);
-  PUTM_TO_PAGE (len, page, "TX bytes: %ld\n", info->stats.tx_bytes);
-  PUTM_TO_PAGE (len, page, "Signal Strength: %s\n", signal[strength]);
-  PUTM_TO_PAGE (len, page, "Signal Quality: %s\n", signal[quality]);
-
-
-
-
-  return len;
+		info->LedStat = ntohs(ledStat);
+
+		ft1000_read_dpram16(info->pFt1000Dev, FT1000_MAG_DSP_CON_STATE,
+			(u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
+		info->ConStat = ntohs(conStat);
+		do_gettimeofday(&tv);
+		delta = (tv.tv_sec - info->ConTm);
+	} else {
+		info->ConStat = 0xf;
+		delta = 0;
+	}
+
+	i = (info->LedStat) & 0xf;
+	switch (i) {
+	case 0x1:
+		strength = 1;
+		break;
+	case 0x3:
+		strength = 2;
+		break;
+	case 0x7:
+		strength = 3;
+		break;
+	case 0xf:
+		strength = 4;
+		break;
+	default:
+		strength = 0;
+	}
+
+	i = (info->LedStat >> 8) & 0xf;
+	switch (i) {
+	case 0x1:
+		quality = 1;
+		break;
+	case 0x3:
+		quality = 2;
+		break;
+	case 0x7:
+		quality = 3;
+		break;
+	case 0xf:
+		quality = 4;
+		break;
+	default:
+		quality = 0;
+	}
+
+	len = 0;
+	PUTM_TO_PAGE(len, page, "Connection Time: %02ld:%02ld:%02ld\n",
+      		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
+	PUTM_TO_PAGE(len, page, "Connection Time[s]: %ld\n", delta);
+	PUTM_TO_PAGE(len, page, "Asic ID: %s\n",
+      	(info->AsicID) ==
+      	ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
+	PUTX_TO_PAGE(len, page, "SKU: ", SKUSZ, info->Sku);
+	PUTX_TO_PAGE(len, page, "EUI64: ", EUISZ, info->eui64);
+	PUTD_TO_PAGE(len, page, "DSP version number: ", DSPVERSZ, info->DspVer);
+	PUTX_TO_PAGE(len, page, "Hardware Serial Number: ", HWSERNUMSZ,
+      		info->HwSerNum);
+	PUTX_TO_PAGE(len, page, "Caliberation Version: ", CALVERSZ,
+      		info->RfCalVer);
+	PUTD_TO_PAGE(len, page, "Caliberation Date: ", CALDATESZ,
+		info->RfCalDate);
+	PUTM_TO_PAGE(len, page, "Media State: %s\n",
+      		(info->mediastate) ? "link" : "no link");
+	PUTM_TO_PAGE(len, page, "Connection Status: %s\n",
+      		status[((info->ConStat) & 0x7)]);
+	PUTM_TO_PAGE(len, page, "RX packets: %ld\n", info->stats.rx_packets);
+	PUTM_TO_PAGE(len, page, "TX packets: %ld\n", info->stats.tx_packets);
+	PUTM_TO_PAGE(len, page, "RX bytes: %ld\n", info->stats.rx_bytes);
+	PUTM_TO_PAGE(len, page, "TX bytes: %ld\n", info->stats.tx_bytes);
+	PUTM_TO_PAGE(len, page, "Signal Strength: %s\n", signal[strength]);
+	PUTM_TO_PAGE(len, page, "Signal Quality: %s\n", signal[quality]);
+
+	return len;
 }
 
 static int
-- 
1.7.1

