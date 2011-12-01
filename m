Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1LAR3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:29:32 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:49200 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab1LAR3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:29:31 -0500
From: Eric B Munson <emunson@mgebm.net>
To: qemu-devel@nongnu.org
Cc: Eric B Munson <emunson@mgebm.net>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2] Guest stop notification
Date: Thu,  1 Dec 2011 12:29:22 -0500
Message-Id: <1322760562-9856-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often when a guest is stopped from the qemu console, it will report spurious
soft lockup warnings on resume.  There are kernel patches being discussed that
will give the host the ability to tell the guest that it is being stopped and
should ignore the soft lockup warning that generates.  This patch uses the qemu
Notifier system to tell the guest it is about to be stopped.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 target-i386/kvm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/target-i386/kvm.c b/target-i386/kvm.c
index 5bfc21f..12ac91a 100644
--- a/target-i386/kvm.c
+++ b/target-i386/kvm.c
@@ -342,6 +342,7 @@ static void cpu_update_state(void *opaque, int running, RunState state)
 
     if (running) {
         env->tsc_valid = false;
+        kvm_vcpu_ioctl(env, KVM_GUEST_PAUSED, 0);
     }
 }
 
-- 
1.7.5.4

