Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2ISO1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:27:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2ISO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:27:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC PATCH 2/2] binfmt_elf: Uninitialized variable
To: linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 15:45:01 +0100
Message-ID: <20120919144446.16893.24530.stgit@localhost.localdomain>
In-Reply-To: <20120919144410.16893.57933.stgit@localhost.localdomain>
References: <20120919144410.16893.57933.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

load_elf_interp has interp_map_addr carefully described as
"uninitialized_var" and marked so as to avoid a warning. However
if you trace the code it is passed into load_elf_interp and then
this value is checked against NULL.

As this return value isn't used this is actually safe but it freaks
various analysis tools that see un-initialized memory addresses
being read before their value is ever defined.

Set it to NULL as a matter of programming good taste if nothing else

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bf6d82b..5fb4801 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -880,7 +880,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		unsigned long uninitialized_var(interp_map_addr);
+		unsigned long interp_map_addr = 0;
 
 		elf_entry = load_elf_interp(&loc->interp_elf_ex,
 					    interpreter,

