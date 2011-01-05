Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1AEXIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:08:42 -0500
Received: from kroah.org ([198.145.64.141]:50818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1AEXGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:36 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.279663414@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [28/49] x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 086e8ced65d9bcc4a8e8f1cd39b09640f2883f90 upstream.

In x2apic mode, we need to set the upper address register of the fault
handling interrupt register of the vt-d hardware. Without this
irq migration of the vt-d fault handling interrupt is broken.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
LKML-Reference: <1291225233.2648.39.camel@sbsiddha-MOBL3>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3567,6 +3567,7 @@ static int dmar_msi_set_affinity(unsigne
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 


