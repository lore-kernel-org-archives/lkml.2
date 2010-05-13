Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab0EMUGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:06:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40579 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515Ab0EMUGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:06:46 -0400
Date: Thu, 13 May 2010 22:06:40 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/20] arch/x86/kernel: Use kcalloc
Message-ID: <Pine.LNX.4.64.1005132206210.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kcalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y,flags;
statement S;
type T;
@@

x = 
-   kmalloc
+   kcalloc
           (
-           y * sizeof(T),
+           y, sizeof(T),
                flags);
 if (x == NULL) S
-memset(x, 0, y * sizeof(T));
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/kernel/uv_time.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -149,10 +149,9 @@ static __init int uv_rtc_allocate_timers
 {
 	int cpu;
 
-	blade_info = kmalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
+	blade_info = kcalloc(uv_possible_blades, sizeof(void *), GFP_KERNEL);
 	if (!blade_info)
 		return -ENOMEM;
-	memset(blade_info, 0, uv_possible_blades * sizeof(void *));
 
 	for_each_present_cpu(cpu) {
 		int nid = cpu_to_node(cpu);
