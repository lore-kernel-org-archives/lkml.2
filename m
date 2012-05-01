Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2EANGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab2EANGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:06:10 -0400
Date: Tue, 1 May 2012 16:06:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [PATCH] kvm: update eax documentation in signature cpuid
Message-ID: <20120501130611.GA8357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Pls apply on top of kvm cpuid bit.

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 8820685..c6e85d8 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -10,11 +10,15 @@ a guest.
 KVM cpuid functions are:
 
 function: KVM_CPUID_SIGNATURE (0x40000000)
-returns : eax = 0,
+returns : eax = 0x40000001,
           ebx = 0x4b4d564b,
           ecx = 0x564b4d56,
           edx = 0x4d.
 Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
+The value in eax corresponds to the maximim cpuid function present in this leaf,
+and will be updated if more functions are added in the future.
+Note also that old hosts set eax value to 0x0. This should
+be interpreted as if the value was 0x40000001.
 This function queries the presence of KVM cpuid leafs.
 
 
