Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0KDKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:09:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:56695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab0KDKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:09:16 -0400
Date: Thu, 4 Nov 2010 11:09:14 +0100
From: Marcus Meissner <meissner@suse.de>
To: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org
Cc: security@kernel.org
Subject: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104100914.GC25118@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Making /proc/kallsyms readable only for root makes it harder
for attackers to write generic kernel exploits by removing
one source of knowledge where things are in the kernel.

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 kernel/kallsyms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..a8db257 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -546,7 +546,7 @@ static const struct file_operations kallsyms_operations = {
 
 static int __init kallsyms_init(void)
 {
-	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
+	proc_create("kallsyms", 0400, NULL, &kallsyms_operations);
 	return 0;
 }
 device_initcall(kallsyms_init);
-- 
1.7.1

