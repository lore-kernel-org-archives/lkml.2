Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2HRIb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:31:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:4511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2HRI3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264740"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 01/11] Documentation/x86: Early load microcode
Date: Sat, 18 Aug 2012 01:15:19 -0700
Message-Id: <1345277729-8399-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Documenation for early load microcode methodology.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/x86/earlyucode.txt |   43 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/earlyucode.txt

diff --git a/Documentation/x86/earlyucode.txt b/Documentation/x86/earlyucode.txt
new file mode 100644
index 0000000..d8966d6
--- /dev/null
+++ b/Documentation/x86/earlyucode.txt
@@ -0,0 +1,43 @@
+Early load microcode
+====================
+By Fenghua Yu <fenghua.yu@intel.com>
+
+Kernel can update microcode in early phase of boot time. Loading microcode early
+can fix CPU issues before they are observed during kernel boot time.
+
+Microcode is stored in initrd file. The microcode is read from the initrd file
+and loaded to CPU's during boot time.
+
+The format of the combined initrd image is microcode in cpio format followed by
+initrd image (maybe compressed). Kernel parses the combined initrd image during
+boot time. The microcode file in cpio name space is:
+kernel/x86/microcode/GenuineIntel/microcode.hex
+
+During BSP boot (before SMP starts), if kernel finds the microcode file in the
+initrd file, it parses the microcode and saves matching microcode in memory.
+If matching microcode is found, it will be uploaded in BSP and later on in all
+AP's.
+
+The saved microcode in memory will be used to upload micorcode when system
+resumes from sleep.
+
+In the past, user can issue command to load microcode during run time. There are
+two user space interfaces to load microcode, either through /dev/cpu/microcode
+interface or through reload file in sysfs.
+
+Now user can choose any of the three methods to update microcode during boot
+time or later during run time.
+
+The following sample script shows how to generate a new combined initrd file in
+/boot/initrd-3.5.0.ucode.img with original microcode microcode.hex and
+original initrd image /boot/initrd-3.5.0.img.
+
+mkdir initrd
+cd initrd
+cp ../microcode.hex kernel/x86/microcode/GenuineIntel/microcode.hex
+find .|cpio -oc >../ucode.cpio
+cd ..
+cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
+
+The generated /boot/initrd-3.5.0.ucode.img can be used as initrd file to load
+microcode during early boot time.
-- 
1.7.2

