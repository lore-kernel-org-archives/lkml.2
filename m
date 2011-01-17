Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1AQBij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:38:39 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43621 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751975Ab1AQBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:38:35 -0500
Date: Sun, 16 Jan 2011 20:38:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Nicolas Pitre <nico@cam.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] arm 32v6k fix 2-byte cmpxchg comment
Message-ID: <20110117013832.GA7882@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:35:21 up 54 days,  6:38,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code comment fix

commit ecd322c9b3e4ac70f9f108badde3eb6b99c7993d introduced a 2-byte cmpxchg with
a comment mismatch (labeled __cmpxchg1).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Nicolas Pitre <nico@cam.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Alexander Shishkin <virtuoso@slind.org>
---
 arch/arm/include/asm/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/arm/include/asm/system.h
===================================================================
--- linux-2.6-lttng.orig/arch/arm/include/asm/system.h	2010-08-20 17:13:18.000000000 -0400
+++ linux-2.6-lttng/arch/arm/include/asm/system.h	2010-08-20 17:17:12.000000000 -0400
@@ -375,7 +375,7 @@ static inline unsigned long __cmpxchg(vo
 		break;
 	case 2:
 		do {
-			asm volatile("@ __cmpxchg1\n"
+			asm volatile("@ __cmpxchg2\n"
 			"	ldrexh	%1, [%2]\n"
 			"	mov	%0, #0\n"
 			"	teq	%1, %3\n"

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
