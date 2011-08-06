Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1HFL0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:26:37 -0400
Received: from www17.your-server.de ([213.133.104.17]:34517 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1HFL0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:26:36 -0400
Subject: [PATCH] x86: UV: use kzalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 13:26:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312629967.5589.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
--- a/arch/x86/platform/uv/uv_time.c 2011-06-07 00:56:19.823210498 +0200
+++ b/arch/x86/platform/uv/uv_time.c 2011-08-01 20:37:27.360951099 +0200
@@ -158,10 +158,9 @@ static __init int uv_rtc_allocate_timers
 {
 	int cpu;
 
-	blade_info = kmalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
+	blade_info = kzalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
 	if (!blade_info)
 		return -ENOMEM;
-	memset(blade_info, 0, uv_possible_blades * sizeof(void *));
 
 	for_each_present_cpu(cpu) {
 		int nid = cpu_to_node(cpu);



