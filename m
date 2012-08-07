Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2HGHnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:43:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39645 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2HGHnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:43:13 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 <x86@kernel.org>
Date: Tue, 07 Aug 2012 13:10:26 +0530
Message-Id: <20120807074026.20169.93816.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
References: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH 2/3] Documentation/ppc: Add ppc hypercall documentation
x-cbid: 12080707-5490-0000-0000-000001EA8286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 Documentation/virtual/kvm/ppc-pv.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/ppc-pv.txt b/Documentation/virtual/kvm/ppc-pv.txt
index 4911cf9..4cd076f 100644
--- a/Documentation/virtual/kvm/ppc-pv.txt
+++ b/Documentation/virtual/kvm/ppc-pv.txt
@@ -174,3 +174,25 @@ following:
 That way we can inject an arbitrary amount of code as replacement for a single
 instruction. This allows us to check for pending interrupts when setting EE=1
 for example.
+
+Hypercall ABIs in KVM on PowerPC
+=================================
+1) KVM hypercalls (ePAPR)
+
+These are ePAPR compliant hypercall implementation (mentioned above). Even
+generic hypercalls are implemented here, like the ePAPR idle hcall. These are
+available on all targets.
+
+2) PAPR hypercalls
+
+PAPR hypercalls are needed to run server PowerPC PAPR guests (-M pseries in QEMU).
+These are the same hypercalls that pHyp, the POWER hypervisor implements. Some of
+them are handled in the kernel, some are handled in user space. This is only
+available on book3s_64.
+
+3) OSI hypercalls
+
+Mac-on-Linux is another user of KVM on PowerPC, which has its own hypercall (long
+before KVM). This is supported to maintain compatibility. All these hypercalls get
+forwarded to user space. This is only useful on book3s_32, but can be used with
+book3s_64 as well.

