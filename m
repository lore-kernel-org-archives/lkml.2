Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0CZQhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:37:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3807 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0CZQhl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 26 Mar 2010 12:37:41 -0400
Message-Id: <4BACF0E60200007800037373@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Mar 2010 16:37:42 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <yinghai@kernel.org>, <hpa@zytor.com>
Cc: <teheo@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] free_early_partial() should permit start == end
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per-CPU allocator, when using atom_size == PAGE_SIZE, may call
free_area_init_partial() this way.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 kernel/early_res.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc2/kernel/early_res.c	2010-03-25 15:23:45.000000000 +0100
+++ 2.6.34-rc2-free_early_partial-zero-size/kernel/early_res.c	2010-03-26 14:49:41.000000000 +0100
@@ -335,10 +335,10 @@ void __init free_early_partial(u64 start
 
 try_next:
 	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
+	r = &early_res[i];
+	if (i >= max_early_res || !r->end)
 		return;
 
-	r = &early_res[i];
 	/* hole ? */
 	if (r->end >= end && r->start <= start) {
 		drop_range_partial(i, start, end);



