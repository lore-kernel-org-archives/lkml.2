Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2LAAVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:21:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab2LAAVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:21:04 -0500
Date: Fri, 30 Nov 2012 16:20:50 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-31ae1d90c127310c67618b8bd79f01c394116187@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354290351-20988-1-git-send-email-fenghua.yu@intel.com>
References: <1354290351-20988-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, doc: Early microcode loading
Git-Commit-ID: 31ae1d90c127310c67618b8bd79f01c394116187
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:20:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31ae1d90c127310c67618b8bd79f01c394116187
Gitweb:     http://git.kernel.org/tip/31ae1d90c127310c67618b8bd79f01c394116187
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Fri, 30 Nov 2012 07:45:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Nov 2012 15:18:14 -0800

x86, doc: Early microcode loading

Documenation for early microcode loading.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1354290351-20988-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/x86/early-microcode.txt | 43 +++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/x86/early-microcode.txt b/Documentation/x86/early-microcode.txt
new file mode 100644
index 0000000..4aaf0df
--- /dev/null
+++ b/Documentation/x86/early-microcode.txt
@@ -0,0 +1,43 @@
+Early load microcode
+====================
+By Fenghua Yu <fenghua.yu@intel.com>
+
+Kernel can update microcode in early phase of boot time. Loading microcode early
+can fix CPU issues before they are observed during kernel boot time.
+
+Microcode is stored in an initrd file. The microcode is read from the initrd
+file and loaded to CPUs during boot time.
+
+The format of the combined initrd image is microcode in cpio format followed by
+the initrd image (maybe compressed). Kernel parses the combined initrd image
+during boot time. The microcode file in cpio name space is:
+kernel/x86/microcode/GenuineIntel.bin
+
+During BSP boot (before SMP starts), if the kernel finds the microcode file in
+the initrd file, it parses the microcode and saves matching microcode in memory.
+If matching microcode is found, it will be uploaded in BSP and later on in all
+APs.
+
+The cached microcode patch is applied when CPUs resume from a sleep state.
+
+There are two legacy user space interfaces to load microcode, either through
+/dev/cpu/microcode or through /sys/devices/system/cpu/microcode/reload file
+in sysfs.
+
+In addition to these two legacy methods, the early loading method described
+here is the third method with which microcode can be uploaded to a system's
+CPUs.
+
+The following example script shows how to generate a new combined initrd file in
+/boot/initrd-3.5.0.ucode.img with original microcode microcode.bin and
+original initrd image /boot/initrd-3.5.0.img.
+
+mkdir initrd
+cd initrd
+mkdir kernel
+mkdir kernel/x86
+mkdir kernel/x86/microcode
+cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
+find .|cpio -oc >../ucode.cpio
+cd ..
+cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
