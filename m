Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1HAXZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1HAXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.405830902@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lei Wen <leiwen@marvell.com>, Eric Miao <eric.y.miao@gmail.com>
Subject: [18/70] ARM: pxa168: correct nand pmu setting
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lei Wen <leiwen@marvell.com>

commit 6662498e132dfa758925a160fd5ef80a083651c3 upstream.

The original pair of <0x01db, 208000000> is invalid. Correct it to
the valid value.

The 6th bit of the NFC APMU register indicates NFC works whether
at 156Mhz or 78Mhz. So 0x19b indicates NFC works at 156Mhz, and
0x1db indicates it works at 78Mhz.

Signed-off-by: Lei Wen <leiwen@marvell.com>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-mmp/pxa168.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -79,7 +79,7 @@ static APBC_CLK(ssp4, PXA168_SSP4, 4, 0)
 static APBC_CLK(ssp5, PXA168_SSP5, 4, 0);
 static APBC_CLK(keypad, PXA168_KPC, 0, 32000);
 
-static APMU_CLK(nand, NAND, 0x01db, 208000000);
+static APMU_CLK(nand, NAND, 0x19b, 156000000);
 static APMU_CLK(lcd, LCD, 0x7f, 312000000);
 
 /* device and clock bindings */


