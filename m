Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0H1Plr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:41:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42064 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0H1PlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:41:20 -0400
From: Julia Lawall <julia@diku.dk>
To: Vegard Nossum <vegardno@ifi.uio.no>
Cc: kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] arch/x86/mm/kmemcheck: Remove double test
Date: Sat, 28 Aug 2010 17:41:03 +0200
Message-Id: <1283010066-20935-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283010066-20935-1-git-send-email-julia@diku.dk>
References: <1283010066-20935-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opcodes 0x2e and 0x3e are tested for in the first Group 2 line as well.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is a guess as to what the code should be.  Perhaps something else
should have been tested instead.

 arch/x86/mm/kmemcheck/opcode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
index 63c19e2..324aa3f 100644
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -9,7 +9,7 @@ static bool opcode_is_prefix(uint8_t b)
 		b == 0xf0 || b == 0xf2 || b == 0xf3
 		/* Group 2 */
 		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
-		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
+		|| b == 0x64 || b == 0x65
 		/* Group 3 */
 		|| b == 0x66
 		/* Group 4 */

