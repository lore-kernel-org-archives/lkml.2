Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0C3X6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:58:25 -0400
Received: from kroah.org ([198.145.64.141]:45566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab0C3XTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:07 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:13 2010
Message-Id: <20100330225712.949574310@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Paul Mundt <lethal@linux-sh.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [111/116] [PATCH] sh: Fix zImage boot using fixed PMB.
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 319c2cc761505ee54a9536c5d0b9c2ee3fb33866 upstream.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Signed-off-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -132,7 +132,7 @@ void decompress_kernel(void)
 	output_addr = (CONFIG_MEMORY_START + 0x2000);
 #else
 	output_addr = PHYSADDR((unsigned long)&_text+PAGE_SIZE);
-#ifdef CONFIG_29BIT
+#if defined(CONFIG_29BIT) || defined(CONFIG_PMB_FIXED)
 	output_addr |= P2SEG;
 #endif
 #endif


