Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0CYWjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:39:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0CYWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:39:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=td1EyxXJHWn7mpMG4JtenqgFLZK0kA6p/VXAR5gQY0K+4DWZzTrwOlnca9UQ7RqXw
	xbvoqefoscgv+iXfocrKA==
Date: Thu, 25 Mar 2010 15:39:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch v2] x86: increase CONFIG_NODES_SHIFT max to 10
In-Reply-To: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1003251538060.8589@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some larger systems require more than 512 nodes, so increase the maximum
CONFIG_NODES_SHIFT to 10 for a new max of 1024 nodes.

This was tested with numa=fake=64M on systems with more than 64GB of RAM.
A total of 1022 nodes were initialized.

Successfully builds with no additional warnings on x86_64 allyesconfig.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 The BUILD_BUG_ON() in drivers/base/node.c has been fixed in Linus' -git
 (see 12ee3c0), so CONFIG_NODES_SHIFT of 10 no longer fails to compile for
 x86_64 allyesconfig.

 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1213,8 +1213,8 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 9
-	default "9" if MAXSMP
+	range 1 10
+	default "10" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
