Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0HXWxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:53:41 -0400
Received: from kroah.org ([198.145.64.141]:52084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab0HXWxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:39 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:23 2010
Message-Id: <20100824222523.628108472@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Kiper <dkiper@net-space.pl>, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, jeremy@goop.org, Ingo Molnar <mingo@elte.hu>
Subject: [14/59] x86, apic: Fix apic=debug boot crash
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Kiper <dkiper@net-space.pl>

commit 05e407603e527f9d808dd3866d3a17c2ce4dfcc5 upstream.

Fix a boot crash when apic=debug is used and the APIC is
not properly initialized.

This issue appears during Xen Dom0 kernel boot but the
fix is generic and the crash could occur on real hardware
as well.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: jeremy@goop.org
LKML-Reference: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1736,6 +1736,8 @@ __apicdebuginit(void) print_IO_APIC(void
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;


