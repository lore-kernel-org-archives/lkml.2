Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab0JVTNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:21 -0400
Received: from kroah.org ([198.145.64.141]:34108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759323Ab0JVS4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.026088299@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [041/103] x86, hpet: Fix bogus error check in hpet_assign_irq()
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 021989622810b02aab4b24f91e1f5ada2b654579 upstream.

create_irq() returns -1 if the interrupt allocation failed, but the
code checks for irq == 0.

Use create_irq_nr() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.LFD.2.00.1009282310360.2416@localhost6.localdomain6>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -507,7 +507,7 @@ static int hpet_assign_irq(struct hpet_d
 {
 	unsigned int irq;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 


