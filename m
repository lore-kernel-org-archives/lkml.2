Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2AWWe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:34:59 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24475 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:34:58 -0500
Date: Mon, 23 Jan 2012 23:34:59 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Don't leak in arch/x86/boot/compressed/misc.c::parse_elf()
Message-ID: <alpine.LNX.2.00.1201232332590.8772@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate memory with malloc(), but neglect to free it before the
variable 'phdrs' goes out of scope --> leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/boot/compressed/misc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

 Note: Only compile tested.

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a19d04..7116dcb 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -321,6 +321,8 @@ static void parse_elf(void *output)
 		default: /* Ignore other PT_* */ break;
 		}
 	}
+
+	free(phdrs);
 }
 
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

