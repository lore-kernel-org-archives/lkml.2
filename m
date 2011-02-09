Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1BIIWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:22:12 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54929 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1BIIWL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Wed, 9 Feb 2011 03:22:11 -0500
Message-Id: <4D525CE60200007800030EE5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 08:22:46 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <heukelum@fastmail.fm>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reduce back the alignment of the per-CPU data
	 section
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This complements commit 47f19a0814e80e1d4e5c17d61b70fca85ea09162,
reverting one leftover of fe8e0c25cad28e8858ecfa5863333c70685a6811.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.38-rc4/arch/x86/kernel/vmlinux.lds.S
+++ 2.6.38-rc4-x86-percpu-align/arch/x86/kernel/vmlinux.lds.S
@@ -305,7 +305,7 @@ SECTIONS
 	}
 
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
-	PERCPU(THREAD_SIZE)
+	PERCPU(PAGE_SIZE)
 #endif
 
 	. = ALIGN(PAGE_SIZE);



