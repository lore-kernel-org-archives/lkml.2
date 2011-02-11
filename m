Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1BKSVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1BKSVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:18 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] Describe KVM_MSR_STEAL_TIME
Date: Fri, 11 Feb 2011 13:19:24 -0500
Message-Id: <1297448364-14051-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-1-git-send-email-glommer@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation about usage of the newly
introduced KVM_MSR_STEAL_TIME.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 Documentation/kvm/msr.txt |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/kvm/msr.txt b/Documentation/kvm/msr.txt
index d079aed..79c12a7 100644
--- a/Documentation/kvm/msr.txt
+++ b/Documentation/kvm/msr.txt
@@ -185,3 +185,36 @@ MSR_KVM_ASYNC_PF_EN: 0x4b564d02
 
 	Currently type 2 APF will be always delivered on the same vcpu as
 	type 1 was, but guest should not rely on that.
+
+MSR_KVM_STEAL_TIME: 0x4b564d03
+
+	data: 64-byte alignment physical address of a memory area which must be
+	in guest RAM, plus an enable bit in bit 0. This memory is expected to
+	hold a copy of the following structure:
+
+	struct kvm_steal_time {
+	  	__u64 steal;
+ 		__u32 version;
+ 		__u32 flags;
+	 	__u32 pad[6];
+	}
+
+	whose data will be filled in by the hypervisor periodically. Only one
+	write, or registration, is needed for each VCPU. The interval between
+	updates of this structure is arbitrary and implementation-dependent.
+	The hypervisor may update this structure at any time it sees fit until
+	anything with bit0 == 0 is written to it. Guest is required to make sure
+	this structure is initialized to zero.
+
+	Fields have the following meanings:
+
+		version: guest has to check version before and after grabbing
+		time information and check that they are both equal and even.
+		An odd version indicates an in-progress update.
+
+		flags: At this point, always zero. May be used to indicate
+		changes in this structure in the future.
+
+		steal: the amount of time in which this vCPU did not run, in
+		nanoseconds.
+
-- 
1.7.2.3

