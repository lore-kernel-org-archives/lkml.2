Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2KXVRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 16:17:21 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61690 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2KXVRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 16:17:20 -0500
Date: Sun, 25 Nov 2012 01:17:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] mm, percpu: Make sure percpu_alloc early parameter has an
 argument
Message-ID: <20121124211713.GA22236@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we are getting a nil dereference

 | [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
 | [    0.000000] IP: [<ffffffff81391360>] strcmp+0x10/0x30

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/percpu.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.git/mm/percpu.c
===================================================================
--- linux-2.6.git.orig/mm/percpu.c
+++ linux-2.6.git/mm/percpu.c
@@ -1380,6 +1380,9 @@ enum pcpu_fc pcpu_chosen_fc __initdata =
 
 static int __init percpu_alloc_setup(char *str)
 {
+	if (!str)
+		return -EINVAL;
+
 	if (0)
 		/* nada */;
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
