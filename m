Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2AZNj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:39:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2AZNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:39:57 -0500
Date: Thu, 26 Jan 2012 05:39:33 -0800
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-5067cf53cac9b36d42ebb3a45bb12259d0bc1e68@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1201232332590.8772@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201232332590.8772@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/boot-image: Don't leak phdrs in arch/x86/boot
 /compressed/misc.c::Parse_elf()
Git-Commit-ID: 5067cf53cac9b36d42ebb3a45bb12259d0bc1e68
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:39:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5067cf53cac9b36d42ebb3a45bb12259d0bc1e68
Gitweb:     http://git.kernel.org/tip/5067cf53cac9b36d42ebb3a45bb12259d0bc1e68
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Mon, 23 Jan 2012 23:34:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 11:30:29 +0100

x86/boot-image: Don't leak phdrs in arch/x86/boot/compressed/misc.c::Parse_elf()

We allocate memory with malloc(), but neglect to free it before
the variable 'phdrs' goes out of scope --> leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1201232332590.8772@swampdragon.chaosbits.net
[ Mostly harmless. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/compressed/misc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
