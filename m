Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab0HLPzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760356Ab0HLPzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] MN10300: Fix size_t and ssize_t
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:54:41 +0100
Message-ID: <20100812155441.17015.89963.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
References: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the newer compilers, size_t and ssize_t are expected to be (un)signed int
rather than (un)signed long.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/posix_types.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/include/asm/posix_types.h b/arch/mn10300/include/asm/posix_types.h
index 077567c..56ffbc1 100644
--- a/arch/mn10300/include/asm/posix_types.h
+++ b/arch/mn10300/include/asm/posix_types.h
@@ -25,8 +25,13 @@ typedef int		__kernel_pid_t;
 typedef unsigned short	__kernel_ipc_pid_t;
 typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
+#if __GNUC__ == 4
+typedef unsigned int	__kernel_size_t;
+typedef signed int	__kernel_ssize_t;
+#else
 typedef unsigned long	__kernel_size_t;
-typedef long		__kernel_ssize_t;
+typedef signed long	__kernel_ssize_t;
+#endif
 typedef int		__kernel_ptrdiff_t;
 typedef long		__kernel_time_t;
 typedef long		__kernel_suseconds_t;

