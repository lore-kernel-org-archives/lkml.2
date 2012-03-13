Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab2CMR03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:26:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34077 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab2CMR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <201203130900.41993.arnd@arndb.de>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	<20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
	<201203130900.41993.arnd@arndb.de>
Date: Tue, 13 Mar 2012 18:26:24 +0100
Message-ID: <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #2]
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux@openrisc.net,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        hpa@zytor.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 13 March 2012 10:00, Arnd Bergmann <arnd@arndb.de> wrote:
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> I would suggest we merge this one through the openrisc tree, along with the
> other asm-generic patches in your series.
>
> asm-generic patches tend to have dependencies on other stuff and they
> rarely conflict with one another, so generally my preference is to have
> them sent by whoever needs them, with my ack.
>

I pulled patches 17-22 from your series into the openrisc tree to give
this a test.  In order to keep the series bisectable, I would need to
make the two changes below between patches 19 and 20.

Aside from this it looks good and I'd be happy to take this via the
OpenRISC tree.  If it's ok with you, I could just squash the two
changes below into patch 19 of your series... or if you think those
changes belong elsewhere, just let me know.  Building the OpenRISC
arch actually fails first after patch 20, but the modifications seem
to me to belong semantically to patch 19.

I did a build test for x86 with the changes below and it was fine...
didn't try any other arches.

/Jonas

diff --git a/include/asm-generic/bitops/atomic.h
b/include/asm-generic/bitops/atomic.h
index ecc44a8..8054ef5 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_BITOPS_ATOMIC_H_

 #include <asm/types.h>
-#include <asm/system.h>

 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
index 8a36183..8be9a37 100644
--- a/include/asm-generic/cmpxchg.h
+++ b/include/asm-generic/cmpxchg.h
@@ -11,6 +11,7 @@
 #endif

 #include <linux/irqflags.h>
+#include <linux/types.h>

 #ifndef xchg
