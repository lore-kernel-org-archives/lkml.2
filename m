Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab0FJXnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:43:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:37052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab0FJXnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:43:12 -0400
Date: Thu, 10 Jun 2010 23:42:44 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20100610111040.F1781B1A2B@basil.firstfloor.org>
References: <20100610111040.F1781B1A2B@basil.firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, setup: Set ax register in boot vga query
Message-ID: <tip-cf3bdc29fcbf2cb4cfa238591021d41ea8f8431f@git.kernel.org>
Git-Commit-ID: cf3bdc29fcbf2cb4cfa238591021d41ea8f8431f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 23:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf3bdc29fcbf2cb4cfa238591021d41ea8f8431f
Gitweb:     http://git.kernel.org/tip/cf3bdc29fcbf2cb4cfa238591021d41ea8f8431f
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Thu, 10 Jun 2010 13:10:40 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Jun 2010 15:24:29 -0700

x86, setup: Set ax register in boot vga query

Catch missing conversion to the register structure "glove box" scheme.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20100610111040.F1781B1A2B@basil.firstfloor.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/video-vga.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index ed7aeff..45bc940 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -41,13 +41,12 @@ static __videocard video_vga;
 static u8 vga_set_basic_mode(void)
 {
 	struct biosregs ireg, oreg;
-	u16 ax;
 	u8 mode;
 
 	initregs(&ireg);
 
 	/* Query current mode */
-	ax = 0x0f00;
+	ireg.ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
 
