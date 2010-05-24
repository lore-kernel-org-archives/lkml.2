Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab0EXXJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:09:52 -0400
Received: from kroah.org ([198.145.64.141]:36570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab0EXXJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:42 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:52 2010
Message-Id: <20100524230352.365900919@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:00:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [34/34] Revert "parisc: Set PCI CLS early in boot."
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

This reverts the following patch, which shouldn't have been applied
to the .32 stable tree as it causes problems.


  commit 5fd4514bb351b5ecb0da3692fff70741e5ed200c upstream.

  Set the PCI CLS early in the boot process to prevent
  device failures. In pcibios_set_master use the new
  pci_cache_line_size instead of a hard-coded value.

  Signed-off-by: Carlos O'Donell <carlos@codesourcery.com>
  Reviewed-by: Grant Grundler <grundler@google.com>
  Signed-off-by: Kyle McMartin <kyle@redhat.com>
  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/kernel/pci.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -18,6 +18,7 @@
 
 #include <asm/io.h>
 #include <asm/system.h>
+#include <asm/cache.h>		/* for L1_CACHE_BYTES */
 #include <asm/superio.h>
 
 #define DEBUG_RESOURCES 0
@@ -122,10 +123,6 @@ static int __init pcibios_init(void)
 	} else {
 		printk(KERN_WARNING "pci_bios != NULL but init() is!\n");
 	}
-
-	/* Set the CLS for PCI as early as possible. */
-	pci_cache_line_size = pci_dfl_cache_line_size;
-
 	return 0;
 }
 
@@ -174,7 +171,7 @@ void pcibios_set_master(struct pci_dev *
 	** upper byte is PCI_LATENCY_TIMER.
 	*/
 	pci_write_config_word(dev, PCI_CACHE_LINE_SIZE,
-			      (0x80 << 8) | pci_cache_line_size);
+				(0x80 << 8) | (L1_CACHE_BYTES / sizeof(u32)));
 }
 
 


