Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1IUSCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:02:41 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:41506 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753501Ab1IUSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:02:39 -0400
Message-ID: <4E7A26BD.1090202@xenotime.net>
Date: Wed, 21 Sep 2011 11:02:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH -next] nfc: NFC_WILINK depends on NFC_NCI
References: <20110921155850.09c858bb38205bb2cc0c8f0a@canb.auug.org.au>
In-Reply-To: <20110921155850.09c858bb38205bb2cc0c8f0a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

nwcwilink.c uses nci_*() interfaces, so it should depend on
NFC_NCI.

Fixes these build errors:
ERROR: "nci_register_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_allocate_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_recv_frame" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_free_device" [drivers/nfc/nfcwilink.ko] undefined!
ERROR: "nci_unregister_device" [drivers/nfc/nfcwilink.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/nfc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-0921.orig/drivers/nfc/Kconfig
+++ next-2011-0921/drivers/nfc/Kconfig
@@ -29,7 +29,7 @@ config NFC_PN533
 
 config NFC_WILINK
 	tristate "Texas Instruments NFC WiLink driver"
-	depends on TI_ST
+	depends on TI_ST && NFC_NCI
 	help
 	  This enables the NFC driver for Texas Instrument's BT/FM/GPS/NFC
 	  combo devices. This makes use of shared transport line discipline
