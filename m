Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1I1XMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:12:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab1I1Wos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.187660209@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [141/244] ARM: Dove: fix second SPI initialization call
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 72cc205611879525db0374d9831f84f787112b25 upstream.

Commit 980f9f601a "ARM: orion: Consolidate SPI initialization."
broke it by overwriting the SPI0 registration.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-dove/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -160,7 +160,7 @@ void __init dove_spi0_init(void)
 
 void __init dove_spi1_init(void)
 {
-	orion_spi_init(DOVE_SPI1_PHYS_BASE, get_tclk());
+	orion_spi_1_init(DOVE_SPI1_PHYS_BASE, get_tclk());
 }
 
 /*****************************************************************************


