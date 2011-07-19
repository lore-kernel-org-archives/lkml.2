Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab1GSNRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:17:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab1GSNRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:17:31 -0400
From: Marcus Meissner <meissner@novell.com>
To: avi@redhat.com, mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marcus Meissner <meissner@novell.com>, Marcus Meissner <meissner@suse.de>
Subject: [PATCH] kvm: Initialize all struct members to avoid stack information leak
Date: Tue, 19 Jul 2011 15:17:18 +0200
Message-Id: <1311081438-1731-1-git-send-email-meissner@novell.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reported to us by Stephan Mueller of atsec.

Several .pad struct members are not set to something, so they
will leak stack content back to user space.

Ciao, Marcus

Reported-by: Stephan Mueller <smueller@atsec.com>
Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77c9d86..621ffb6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3002,6 +3002,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		memset(&events, 0, sizeof(events));
 		kvm_vcpu_ioctl_x86_get_vcpu_events(vcpu, &events);
 
 		r = -EFAULT;
-- 
1.7.6

