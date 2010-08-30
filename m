Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0H3Ihq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:37:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:54255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0H3Iho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:37:44 -0400
Date: Mon, 30 Aug 2010 08:36:26 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
        mingo@redhat.com, vegardno@ifi.uio.no, penberg@cs.helsinki.fi,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
        linux-kernel@vger.kernel.org, vegardno@ifi.uio.no,
        penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1283010066-20935-5-git-send-email-julia@diku.dk>
References: <1283010066-20935-5-git-send-email-julia@diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, kmemcheck: Remove double test
Message-ID: <tip-9fbaf49c7f717740002d49eee1bbd03d89d8766a@git.kernel.org>
Git-Commit-ID: 9fbaf49c7f717740002d49eee1bbd03d89d8766a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:36:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fbaf49c7f717740002d49eee1bbd03d89d8766a
Gitweb:     http://git.kernel.org/tip/9fbaf49c7f717740002d49eee1bbd03d89d8766a
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Sat, 28 Aug 2010 17:41:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Aug 2010 09:19:28 +0200

x86, kmemcheck: Remove double test

The opcodes 0x2e and 0x3e are tested for in the first Group 2
line as well.

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
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
LKML-Reference: <1283010066-20935-5-git-send-email-julia@diku.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/kmemcheck/opcode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
