Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1DMQAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:00:52 -0400
Received: from kroah.org ([198.145.64.141]:54503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab1DMPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:48 2011
Message-Id: <20110413155148.846619861@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [55/74] x86, amd-ucode: Remove needless log messages
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Andreas Herrmann <herrmann.der.user@googlemail.com>

Upstream commit: 6e18da75c28b592594fd632cf3e6eb09d3d078de

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20091029134742.GD30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/microcode_amd.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -109,12 +109,8 @@ static int get_matching_microcode(int cp
 		return 0;
 	}
 
-	if (mc_header->processor_rev_id != equiv_cpu_id) {
-		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
-		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
-		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
+	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;
-	}
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
@@ -185,9 +181,6 @@ get_next_ucode(const u8 *buf, unsigned i
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
-	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
-	       size, total_size);
-
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
 		printk(KERN_ERR "microcode: error: size mismatch\n");
 		return NULL;


