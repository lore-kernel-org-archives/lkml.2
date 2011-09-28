Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1I1Wkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1I1Wko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.106431233@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Martin <dave.martin@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [074/244] ARM: davinci: fix cache flush build error
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 897a6a1a14837d6d582bfd1fd7aba00be44b6469 upstream.

The TNET variant of DaVinci compiles some code that it shares
with other DaVinci variants, however it has a V6 CPU rather than
an ARM926T, thus the hardcoded call to arm926_flush_kern_cache_all()
in sleep.S will obviously fail, and we need to build with the
v6_flush_kern_cache_all() call instead. This was triggered by
manually altering the DaVinci config to build the TNET version.

Cc: Dave Martin <dave.martin@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-davinci/sleep.S |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-davinci/sleep.S
+++ b/arch/arm/mach-davinci/sleep.S
@@ -217,7 +217,11 @@ ddr2clk_stop_done:
 ENDPROC(davinci_ddr_psc_config)
 
 CACHE_FLUSH:
-	.word	arm926_flush_kern_cache_all
+#ifdef CONFIG_CPU_V6
+	.word	v6_flush_kern_cache_all
+#else
+	.word   arm926_flush_kern_cache_all
+#endif
 
 ENTRY(davinci_cpu_suspend_sz)
 	.word	. - davinci_cpu_suspend


