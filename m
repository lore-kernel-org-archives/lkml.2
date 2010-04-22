Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0DVUfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:35:48 -0400
Received: from kroah.org ([198.145.64.141]:37526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab0DVT2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:15 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.846934919@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [061/197] KVM: x86: disable paravirt mmu reporting
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Marcelo Tosatti <mtosatti@redhat.com>

commit a68a6a7282373bedba8a2ed751b6384edb983a64 upstream

Disable paravirt MMU capability reporting, so that new (or rebooted)
guests switch to native operation.

Paravirt MMU is a burden to maintain and does not bring significant
advantages compared to shadow anymore.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1242,8 +1242,8 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_MEMORY_SLOTS;
 		break;
-	case KVM_CAP_PV_MMU:
-		r = !tdp_enabled;
+	case KVM_CAP_PV_MMU:	/* obsolete */
+		r = 0;
 		break;
 	case KVM_CAP_IOMMU:
 		r = iommu_found();


