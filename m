Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0EKQVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0EKQVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:31 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 9/9] Add cpuid.txt file
Date: Tue, 11 May 2010 12:17:47 -0400
Message-Id: <1273594667-17175-10-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-9-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <1273594667-17175-2-git-send-email-glommer@redhat.com>
 <1273594667-17175-3-git-send-email-glommer@redhat.com>
 <1273594667-17175-4-git-send-email-glommer@redhat.com>
 <1273594667-17175-5-git-send-email-glommer@redhat.com>
 <1273594667-17175-6-git-send-email-glommer@redhat.com>
 <1273594667-17175-7-git-send-email-glommer@redhat.com>
 <1273594667-17175-8-git-send-email-glommer@redhat.com>
 <1273594667-17175-9-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file documents cpuid bits used by KVM.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 Documentation/kvm/cpuid.txt |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/kvm/cpuid.txt

diff --git a/Documentation/kvm/cpuid.txt b/Documentation/kvm/cpuid.txt
new file mode 100644
index 0000000..ca1e89f
--- /dev/null
+++ b/Documentation/kvm/cpuid.txt
@@ -0,0 +1,44 @@
+KVM CPUID bits
+Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
+=====================================================
+
+A guest running on a kvm host, can check some of its features using
+cpuid. This is not always guaranteed to work, since userspace can
+mask-out some, or even all KVM-related cpuid features before launching
+a guest.
+
+KVM cpuid functions are:
+
+function: KVM_CPUID_SIGNATURE (0x40000000)
+returns : eax = 0,
+          ebx = 0x4b4d564b,
+          ecx = 0x564b4d56,
+          edx = 0x4d.
+Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
+This function queries the presence of KVM cpuid leafs.
+
+
+function: define KVM_CPUID_FEATURES (0x40000001)
+returns : ebx, ecx, edx = 0
+          eax = and OR'ed group of (1 << flag), where each flags is:
+
+
+flag                               || value || meaning
+=============================================================================
+KVM_FEATURE_CLOCKSOURCE            ||     0 || kvmclock available at msrs
+                                   ||       || 0x11 and 0x12. 
+------------------------------------------------------------------------------
+KVM_FEATURE_NOP_IO_DELAY           ||     1 || not necessary to perform delays
+                                   ||       || on PIO operations.
+------------------------------------------------------------------------------
+KVM_FEATURE_MMU_OP                 ||     2 || deprecated.
+------------------------------------------------------------------------------
+KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
+                                   ||       || 0x4b564d00 and 0x4b564d01
+------------------------------------------------------------------------------
+KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will wanr if no guest-side
+                                   ||       || per-cpu warps are expected in
+                                   ||       || kvmclock.
+------------------------------------------------------------------------------
+
+
-- 
1.6.2.2

