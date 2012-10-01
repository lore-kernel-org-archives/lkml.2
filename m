Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2JANiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:38:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43257 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2JANiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:23 -0400
Date: Mon, 1 Oct 2012 15:38:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups changes for v3.7
Message-ID: <20121001133818.GA23567@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: 4b8073e467e6a66b6a5a8e799d28bc3b243c0d78 arch/x86: Remove unecessary semicolons

Smaller cleanups.

 Thanks,

	Ingo

------------------>
Paul Bolle (1):
      x86, boot: Remove obsolete and unused constant RAMDISK

Peter Senna Tschudin (1):
      arch/x86: Remove unecessary semicolons


 arch/x86/boot/header.S         | 4 ----
 arch/x86/kernel/alternative.c  | 4 ++--
 arch/x86/kernel/apic/apic.c    | 2 +-
 arch/x86/kvm/vmx.c             | 2 +-
 arch/x86/pci/mmconfig-shared.c | 2 +-
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index b4e15dd..2a01744 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -32,10 +32,6 @@ SYSSEG		= 0x1000		/* historical load address >> 4 */
 #define SVGA_MODE ASK_VGA
 #endif
 
-#ifndef RAMDISK
-#define RAMDISK 0
-#endif
-
 #ifndef ROOT_RDONLY
 #define ROOT_RDONLY 1
 #endif
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ced4534..3318b1e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -317,7 +317,7 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 		/* turn DS segment override prefix into lock prefix */
 		if (*ptr == 0x3e)
 			text_poke(ptr, ((unsigned char []){0xf0}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
@@ -338,7 +338,7 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 		/* turn lock prefix into DS segment override prefix */
 		if (*ptr == 0xf0)
 			text_poke(ptr, ((unsigned char []){0x3E}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..b17416e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1934,7 +1934,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
 		i++;
 		v1 >>= 1;
-	};
+	}
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b1eb202..b06737d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4543,7 +4543,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 				vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
 				return 0;
 			}
-		};
+		}
 		break;
 	case 2: /* clts */
 		handle_clts(vcpu);
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 937bcec..704b9ec 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -585,7 +585,7 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
 	while (i >= sizeof(struct acpi_mcfg_allocation)) {
 		entries++;
 		i -= sizeof(struct acpi_mcfg_allocation);
-	};
+	}
 	if (entries == 0) {
 		pr_err(PREFIX "MMCONFIG has no entries\n");
 		return -ENODEV;
