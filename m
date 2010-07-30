Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab0G3STb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:19:31 -0400
Received: from kroah.org ([198.145.64.141]:58800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022Ab0G3R4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175144.850129306@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [120/205] x86: Do not try to disable hpet if it hasnt been initialized before
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit ff4878089e1eaeac79d57878ad4ea32910fb4037 upstream.

hpet_disable is called unconditionally on machine reboot if hpet support
is compiled in the kernel.
hpet_disable only checks if the machine is hpet capable but doesn't make
sure that hpet has been initialized.

[ tglx: Made it a one liner and removed the redundant hpet_address check ]

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.DEB.2.00.1007211726240.22235@kaball-desktop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -959,7 +959,7 @@ fs_initcall(hpet_late_init);
 
 void hpet_disable(void)
 {
-	if (is_hpet_capable()) {
+	if (is_hpet_capable() && hpet_virt_address) {
 		unsigned int cfg = hpet_readl(HPET_CFG);
 
 		if (hpet_legacy_int_enabled) {


