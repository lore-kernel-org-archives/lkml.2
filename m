Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1H2Wc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:32:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58298 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab1H2WcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:32:25 -0400
Date: Tue, 30 Aug 2011 08:32:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: linux-next: build failure in Linus' tree
Message-Id: <20110830083218.1819a5d73c3a33e5053e8312@canb.auug.org.au>
In-Reply-To: <20110829104451.1c777e24ff72823d1e399f12@canb.auug.org.au>
References: <20110829104451.1c777e24ff72823d1e399f12@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 29 Aug 2011 10:44:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the fixes tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/kernel/built-in.o: In function `.sys_call_table':
> (.text+0xbd00): undefined reference to `.sys_nfsservctl'
> arch/powerpc/kernel/built-in.o: In function `.sys_call_table':
> (.text+0xbd08): undefined reference to `.compat_sys_nfsservctl'
> 
> Caused by commit f5b940997397 ("All Arch: remove linkage for
> sys_nfsservctl system call") which also missed parisc.
> 
> I will apply this patch for today:

Will you please appply this?  (repeated for ease of inclusion)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Aug 2011 10:38:57 +1000
Subject: [PATCH] remove remaining references to nfsservctl

These were missed in commit f5b940997397 "All Arch: remove linkage
for sys_nfsservctl system call" due to them having no sys_ prefix
(presumably).

Cc: NeilBrown <neilb@suse.de>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/parisc/kernel/syscall_table.S |    2 +-
 arch/powerpc/include/asm/systbl.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index e66366f..3735abd 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -259,7 +259,7 @@
 	ENTRY_SAME(ni_syscall)		/* query_module */
 	ENTRY_SAME(poll)
 	/* structs contain pointers and an in_addr... */
-	ENTRY_COMP(nfsservctl)
+	ENTRY_SAME(ni_syscall)		/* was nfsservctl */
 	ENTRY_SAME(setresgid)		/* 170 */
 	ENTRY_SAME(getresgid)
 	ENTRY_SAME(prctl)
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index f6736b7..fa0d27a 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -171,7 +171,7 @@ SYSCALL_SPU(setresuid)
 SYSCALL_SPU(getresuid)
 SYSCALL(ni_syscall)
 SYSCALL_SPU(poll)
-COMPAT_SYS(nfsservctl)
+SYSCALL(ni_syscall)
 SYSCALL_SPU(setresgid)
 SYSCALL_SPU(getresgid)
 COMPAT_SYS_SPU(prctl)
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
