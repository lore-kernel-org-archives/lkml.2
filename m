Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161893Ab1FAJNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:13:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161839Ab1FAIPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:16 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:49 2011
Message-Id: <20110601081048.380400378@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:32 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [002/165] m68k: Really wire up sys_pselect6 and sys_ppoll
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1019
Lines: 31

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit d6d42bb2f85d875dc0c421699de5a1401b2af6a6 upstream.

We reserved the numbers a long time ago, but never wired them up in the
syscall table as they need TIF_RESTORE_SIGMASK, which we only got last year
in commit cb6831d5d3099e772a510eb3e1ed0760ccffb45e ("m68k: Switch to saner
sigsuspend()")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/m68k/kernel/syscalltable.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -319,8 +319,8 @@ ENTRY(sys_call_table)
 	.long sys_readlinkat
 	.long sys_fchmodat
 	.long sys_faccessat		/* 300 */
-	.long sys_ni_syscall		/* Reserved for pselect6 */
-	.long sys_ni_syscall		/* Reserved for ppoll */
+	.long sys_pselect6
+	.long sys_ppoll
 	.long sys_unshare
 	.long sys_set_robust_list
 	.long sys_get_robust_list	/* 305 */


