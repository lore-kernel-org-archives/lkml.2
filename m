Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1FVRKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:10:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26576 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1FVRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:09:58 -0400
Date: Wed, 22 Jun 2011 10:08:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH -next] bluetooth: uses crypto interfaces, select CRYPTO
Message-Id: <20110622100811.258091ff.randy.dunlap@oracle.com>
In-Reply-To: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
References: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E0221E0.0010:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Recent changes to hci_core.c use crypto interfaces, so select CRYPTO
to make sure that those interfaces are present.

Fixes these build errors when CRYPTO is not enabled:

net/built-in.o: In function `hci_register_dev':
(.text+0x4cf86): undefined reference to `crypto_alloc_base'
net/built-in.o: In function `hci_unregister_dev':
(.text+0x4f912): undefined reference to `crypto_destroy_tfm'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/bluetooth/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110622.orig/net/bluetooth/Kconfig
+++ linux-next-20110622/net/bluetooth/Kconfig
@@ -6,6 +6,7 @@ menuconfig BT
 	tristate "Bluetooth subsystem support"
 	depends on NET && !S390
 	depends on RFKILL || !RFKILL
+	select CRYPTO
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
 	  It was designed as a replacement for cables and other short-range
