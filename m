Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1G0Q1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:27:45 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56107 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754748Ab1G0Q1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:27:43 -0400
Date: Wed, 27 Jul 2011 09:27:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        J Freyensee <james_p_freyensee@linux.intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: [patch] Re: linux-next: Tree for July 27 (misc/pti)
Message-Id: <20110727092740.2228dd94.rdunlap@xenotime.net>
In-Reply-To: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 14:11:51 +1000 Stephen Rothwell wrote:

> Hi all,


I am still applying the drivers/misc/ patch below that was posted on July 7.
Is there a drivers/misc/ maintainer?  Andrew?

Hm, this patch needs to be applied to mainline.

---
From: J Freyensee <james_p_freyensee@linux.intel.com>

Intel-Atom implementation of PTI will not work with PCI
configured off, so the pti driver should not be compiled
in the event someone does not enable PCI in the linux kernel.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e349cd..7fd32a6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
-- 
