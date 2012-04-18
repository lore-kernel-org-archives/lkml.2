Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2DRPF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:05:58 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35075 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752179Ab2DRPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:05:56 -0400
Message-ID: <4F8ED879.9090606@xenotime.net>
Date: Wed, 18 Apr 2012 08:06:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH -next] w1: fix ds28e04 build, select CRC16
References: <20120418150056.0c6057320a29b3b482a63cc7@canb.auug.org.au>
In-Reply-To: <20120418150056.0c6057320a29b3b482a63cc7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error by selecting CRC16:

ERROR: "crc16" [drivers/w1/slaves/w1_ds28e04.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/slaves/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120418.orig/drivers/w1/slaves/Kconfig
+++ linux-next-20120418/drivers/w1/slaves/Kconfig
@@ -97,6 +97,7 @@ config W1_SLAVE_DS2781
 config W1_SLAVE_DS28E04
 	tristate "4096-Bit Addressable 1-Wire EEPROM with PIO (DS28E04-100)"
 	depends on W1
+	select CRC16
 	help
 	  Say Y here if you want to use a 1-wire
 	  4kb EEPROM with PIO family device (DS28E04).
