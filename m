Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1C1Fa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:30:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40224 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1C1Faz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:30:55 -0400
Date: Mon, 28 Mar 2011 16:30:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] MFD: allow cs5535-mfd to build on X86 only
Message-Id: <20110328163053.44c49931.sfr@canb.auug.org.au>
In-Reply-To: <20110327212603.209ad054@queued.net>
References: <20110328145212.8ed636e8.sfr@canb.auug.org.au>
	<20110327212603.209ad054@queued.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is relevant to one of the trees that you merged today:

On Sun, 27 Mar 2011 21:26:03 -0700 Andres Salomon <dilinger@queued.net> wrote:
>

Stephen ran into the following build error:

drivers/mfd/cs5535-mfd.c:30:22: error: asm/olpc.h: No such file or
directory

olpc.h exists only on x86 (and in the future, ARM).  Rather than
wrapping the include in an #ifdef, just change cs5535-mfd to only build
on x86.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---

On Mon, 28 Mar 2011 14:52:12 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/cs5535-mfd.c:30:22: error: asm/olpc.h: No such file or
> directory
> 
> Caused by commit fa1df691688f ("mfd: Add mfd_clone_cell(), convert
> cs5535-mfd/olpc-xo1 to it").
> 
> I have reverted that commit (and commit adfa4bd4a8bf "mfd: OLPC:
> Clean up names to match what OLPC actually uses" that conflicted with
> the revert).

Whoops, this should fix it.  One could argue that we should allow this
to build on MIPS as well, but.. we'll cross that bridge later.  Thanks!


 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a9a1af4..3fbeb3b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -591,7 +591,7 @@ config AB3550_CORE
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && X86
 	---help---
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
           necessary for using the board's GPIO and MFGPT functionality.
-- 
1.7.2.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
