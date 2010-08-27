Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0H0CAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0H0CAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/22] h8300: Fix missing consts in kernel_execve()
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 02:59:57 +0100
Message-ID: <20100827015957.27277.175.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
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

