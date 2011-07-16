Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1GPTZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:25:53 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:33969 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754645Ab1GPTZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:25:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jAgSRCMnsMUZQyasKR98SjwXiheDED172ImQ4UQaFcosVTCnICE/SWhCeth74ea7Y5oq/Cp6+jNpke9mebkG3c4S+AKjav+TW+BEIPoMfoYRMlsixdF8FYxgtV5KGRji;
Date: Sat, 16 Jul 2011 12:25:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] watchdog: hpwdt depends on PCI
Message-Id: <20110716122549.2406a0f9.rdunlap@xenotime.net>
In-Reply-To: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

hpwdt is a PCI driver so it should depend on PCI.
Fixes these build errors:

drivers/watchdog/hpwdt.c:762: error: implicit declaration of function 'pci_iomap'
drivers/watchdog/hpwdt.c:762: warning: assignment makes pointer from integer without a cast
drivers/watchdog/hpwdt.c:797: error: implicit declaration of function 'pci_iounmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
---
 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110716.orig/drivers/watchdog/Kconfig
+++ linux-next-20110716/drivers/watchdog/Kconfig
@@ -619,7 +619,7 @@ config IT87_WDT
 
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
-	depends on X86
+	depends on X86 && PCI
 	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
