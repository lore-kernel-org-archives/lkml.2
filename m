Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1HCX3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:29:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab1HCX2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.683379952@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Philip A. Prindeville" <philipp@redfish-solutions.com>,
        "Alexandros C. Couloumbis" <alex@ozo.com>,
        Andres Salomon <dilinger@queued.net>
Subject: [066/102] geode: reflect mfgpt dependency on mfd
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -245,8 +245,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI
-	depends on X86
+	depends on PCI && X86 && MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other


