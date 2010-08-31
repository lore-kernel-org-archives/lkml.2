Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0HaPwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab0HaPwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:52:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] h8300: Fix missing consts in kernel_execve()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: ysato@users.sourceforge.jp, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Aug 2010 16:52:21 +0100
Message-ID: <20100831155221.10885.22326.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100831155211.10885.62967.stgit@warthog.procyon.org.uk>
References: <20100831155211.10885.62967.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing consts in h8300's kernel_execve():

arch/h8300/kernel/sys_h8300.c: In function 'kernel_execve':
arch/h8300/kernel/sys_h8300.c:59: warning: initialization from incompatible pointer type
arch/h8300/kernel/sys_h8300.c:60: warning: initialization from incompatible pointer type

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/h8300/kernel/sys_h8300.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index dc1ac02..aaf5e5a 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -56,8 +56,8 @@ int kernel_execve(const char *filename,
 		  const char *const envp[])
 {
 	register long res __asm__("er0");
-	register char *const *_c __asm__("er3") = envp;
-	register char *const *_b __asm__("er2") = argv;
+	register const char *const *_c __asm__("er3") = envp;
+	register const char *const *_b __asm__("er2") = argv;
 	register const char * _a __asm__("er1") = filename;
 	__asm__ __volatile__ ("mov.l %1,er0\n\t"
 			"trapa	#0\n\t"

