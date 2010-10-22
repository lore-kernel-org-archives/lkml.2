Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab0JVS4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:07 -0400
Received: from kroah.org ([198.145.64.141]:33986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab0JVS4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.208443840@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        John Stultz <johnstul@us.ibm.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [021/103] ARM: 6400/1: at91: fix arch_gettimeoffset fallout
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 79e27dc0677b969e2d53b76fa0fa58467cce946a upstream.

5cfc8ee0bb51 (ARM: convert arm to arch_gettimeoffset()) marked all of
at91 AND at91x40 as needing ARCH_USES_GETTIMEOFFSET, and hence no high
res timer support / accurate clock_gettime() - But only at91x40 needs it.

Signed-off-by: Peter Korsgaard <peter.korsgaard@barco.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -273,7 +273,6 @@ config ARCH_AT91
 	bool "Atmel AT91"
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
-	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.


