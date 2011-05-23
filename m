Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1EWAia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:38:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23001 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1EWAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:38:28 -0400
Date: Sun, 22 May 2011 17:32:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH -next] ata: PATA_ARASAN_CF depends on DMADEVICES
Message-Id: <20110522173227.5ba18817.randy.dunlap@oracle.com>
In-Reply-To: <20110520165507.cba539d5.sfr@canb.auug.org.au>
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4DD9AC7C.003C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig unmet dependency warning:

warning: (PATA_ARASAN_CF && VIDEO_TIMBERDALE && SND_SOC_SH4_SIU) selects DMA_ENGINE which has unmet direct dependencies (DMADEVICES)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/ata/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110520.orig/drivers/ata/Kconfig
+++ linux-next-20110520/drivers/ata/Kconfig
@@ -313,6 +313,7 @@ config PATA_AMD
 
 config PATA_ARASAN_CF
 	tristate "ARASAN CompactFlash PATA Controller Support"
+	depends on DMADEVICES
 	select DMA_ENGINE
 	help
 	  Say Y here to support the ARASAN CompactFlash PATA controller
