Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab0GAVMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:12:34 -0400
Received: from kroah.org ([198.145.64.141]:47611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab0GAUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:36 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.885162928@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Linus Walleij <linus.walleij@stericsson.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 084/164] ARM: 6144/1: TCM memory bug freeing bug
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@stericsson.com>

commit ea208f646c8fb91c39c852e952fc911e1ad045ab upstream.

This fixes a bug in mm/init.c when freeing the TCM compile memory,
this was being referred to as a char * which is incorrect: this
will dereference the pointer and feed in the value at the location
instead of the address to it. Change it to a plain char and use
&(char) to reference it.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -632,10 +632,10 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 #ifdef CONFIG_HAVE_TCM
-	extern char *__tcm_start, *__tcm_end;
+	extern char __tcm_start, __tcm_end;
 
-	totalram_pages += free_area(__phys_to_pfn(__pa(__tcm_start)),
-				    __phys_to_pfn(__pa(__tcm_end)),
+	totalram_pages += free_area(__phys_to_pfn(__pa(&__tcm_start)),
+				    __phys_to_pfn(__pa(&__tcm_end)),
 				    "TCM link");
 #endif
 


