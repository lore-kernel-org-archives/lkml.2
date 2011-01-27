Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1A0DO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:14:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1A0DOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gCkV9sfG2I4q2vz53T4QTwjXo3j/6k1zBicBkBRlRkuXs3iwE6QwI/oB3gysQYJopi
         lj/Y17jdnowW9GD2trLw==
Date: Wed, 26 Jan 2011 19:14:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/4] x86: only compile floppy driver if CONFIG_ISA_DMA_API
 is enabled
In-Reply-To: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1101261913400.7809@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic floppy disk driver utilizies the interface provided by
CONFIG_ISA_DMA_API, specifically claim_dma_lock(), release_dma_lock(),
request_dma(), and free_dma().  Thus, there's a strict dependency on the
config option and the driver should only be loaded if the kernel supports
ISA-style DMA.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -139,7 +139,7 @@ config GENERIC_GPIO
 	bool
 
 config ARCH_MAY_HAVE_PC_FDC
-	def_bool y
+	def_bool ISA_DMA_API
 
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
