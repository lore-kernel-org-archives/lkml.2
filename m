Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab1HFAOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:14:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab1HFAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:15 2011
Message-Id: <20110806000414.938486760@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Philip A. Prindeville" <philipp@redfish-solutions.com>,
        "Alexandros C. Couloumbis" <alex@ozo.com>,
        Andres Salomon <dilinger@queued.net>
Subject: [33/50] geode: reflect mfgpt dependency on mfd
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Philip A. Prindeville" <philipp@redfish-solutions.com>

commit 703f03c896fdbd726b809066ae279df513992f0e upstream.

As stated in drivers/mfd/cs5535-mfd.c, the mfd driver exposes the BARs
which then make the GPIO, MFGPT, ACPI, etc.  all visible to the system.

So the dependencies of the MFGPT stuff have changed, and most people
expect Kconfig to bring in the necessary dependencies.  Without them, the
module fails to load and most people don't understand why because the
details of the rewrite aren't captured anywhere most people who know to
look.

This dependency needs to be reflected in Kconfig.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Alexandros C. Couloumbis <alex@ozo.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -189,8 +189,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI
-	depends on X86
+	depends on PCI && X86 && MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other


