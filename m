Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242Ab0KPKqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:46:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:47300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0KPKqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:46:05 -0500
Date: Tue, 16 Nov 2010 11:46:03 +0100
From: Marcus Meissner <meissner@suse.de>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@osdl.org, hpa@zytor.com, mingo@elte.hu, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101116104600.GA24015@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG
 Nuernberg)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Making /proc/kallsyms readable only for root makes it harder
for attackers to write generic kernel exploits by removing
one source of knowledge where things are in the kernel.

This is the second submit, discussion happened on this on first submit
and mostly concerned that this is just one hole of the sieve ... but
one of the bigger ones.

Changing the permissions of at least System.map and vmlinux is
also required to fix the same set, but a packaging issue.

Target of this starter patch and follow ups is removing any kind of
kernel space address information leak from the kernel.

Ciao, Marcus

Signed-off-by: Marcus Meissner <meissner@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Eugene Teo <eugeneteo@kernel.org>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
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

