Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1FESCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:02:46 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:45241 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab1FESCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:45 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-34-4debc481a506
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 1/9] x86-64: Fix alignment of jiffies variable
Date: Sun,  5 Jun 2011 13:50:17 -0400
Message-Id: <5f3bc5542e9aaa9382d53f153f54373165cdef89.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3VSWUwTURT1daZvpg0j49DKA5eYBkPEVNQQ8xKXuPyMieCW+CEfOtKRVttC
	ZgoBP3BBETdcEqNW4pKIKJAUCwTQRLGCFVnEDXCpVZGARRDlwwUUZ1Tky79z7zn3nNzcSxNc
	UBtN25wuUXIKdhPUkxy1JMa8u74vce5VD4kLPWUQFzxpoHB9+xcKu9sZPFT+E+IWH8J137sh
	/vi0GuLH1wshrnn5BOJ3uR0AVz7K1eKush4CDx4vh7jCe5LAbwv6Kfzo4yCJv5Z3aZdy/Jd9
	BSR/t/kO4J/njRD8+dpPgL+U/5Xia90Biq+4EsePvq+H/PEPnYD3lhyA/EBrK8XfOz1M8v7m
	FfyQdzrvq/4A14Rv1C+yiHZbpijFL9mst7b6BzTpA9qs3cE6uAuMkAeBjkZsAjpduEfzB09G
	ba888CDQ0xx7E6C8YPBv4QGoM3Tkb9GtQaPDeZQ6AtkYlF/0WhmnaQMbj54OAVVDsOe1yNt0
	6HdEBLsMlVYUESom2ZnoW+VLUtUz7Do00pCsQsTOQA9K0lSFjp2L2jpatCrmFEdffyP8X/8Y
	YC+ACSVgmsWxw+wQbHZZTDHLKYLTKUrm+XMcNtcc0ZLhBertdFFMDRi4bfIBlgamMKayrC+R
	0wqZcrbDB6JojcnIXLijtCZuSbNkWwXZuknKsIuyDyCaMBmYHEMokWMsQvYOUUobo6bQpCmS
	ORMVm8ixqYJL3C6K6aI0xk6laRNigqrpJElMFbO22uyucVpD61TzMMX8h6ph5HTBIdtS//D3
	gZmuutd/G3CkM80pRkcyIVXEqiJrhvOfz9hfhkCkslYEo1PekwtTvvafU0gJ0Sgh/uXqBrJL
	GKeid4GcW88yR5cPr5ZWnrocm7V+m+Es8zn3Rm940oni5MWrzF05G3oG3eL8FwnkysABXn94
	Zzx8vCzQGZg9cXjRm80NsT8ioi8edYXvmfQt+fNeY6U3trdnVlUp5Qav2IXniCNJJ/35az32
	Yn9ChLWxKdBsdD8sNV5bcGhCW8vP/dMEqDGRslWYF0dIsvALIkDIu3IDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's declared __attribute__((aligned(16)) but it's explicitly not
aligned.  This is probably harmless but it's a bit embarrassing.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..a4eaca4 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,7 +45,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-- 
1.7.5.2

