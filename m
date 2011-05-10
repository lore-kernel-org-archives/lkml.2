Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1EJPiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:38:09 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:45416 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1EJPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:38:07 -0400
X-Greylist: delayed 817 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 11:38:06 EDT
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mikew@google.com" <mikew@google.com>,
        Greg KH <greg@kroah.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 10 May 2011 11:00:44 -0400
Subject: [RFC][PATCH] pstore: EFI Support
Thread-Topic: [RFC][PATCH] pstore: EFI Support
Thread-Index: AcwPISM1GEJXxhgLR5+GANJ5FUBsAgAAAedA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {DD4352D3-9989-4222-AF78-B4DC4C57AC57}
x-cr-hashedpuzzle: DEMw MEQy WRXr WgER iDo+ jCV8 mfvz nNNI nrEq vFNw
 ABxqXQ== AC8kRQ== AI2UWQ== AMc+aA== AR8WNQ==
 ASR/tQ==;12;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGEAawBwAG0AQABsAGkAbgB1AHgALQBmAG8AdQBuAGQAYQB0AGkAbwBuAC4AbwByAGcAOwBkAGwAZQAtAGQAZQB2AGUAbABvAHAAQABsAGkAcwB0AHMALgBzAG8AdQByAGMAZQBmAG8AcgBnAGUALgBuAGUAdAA7AGYAdwBlAGkAcwBiAGUAYwBAAGcAbQBhAGkAbAAuAGMAbwBtADsAZwByAGUAZwBAAGsAcgBvAGEAaAAuAGMAbwBtADsAaABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAawBlAHcAQABnAG8AbwBnAGwAZQAuAGMAbwBtADsAdABqAEAAawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwBuAHkALgBsAHUAYwBrAEAAaQBuAHQAZQBsAC4AYwBvAG0AOwB4ADgANgBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwB4AGkAeQBvAHUALgB3AGEAbgBnAGMAbwBuAGcAQABnAG0AYQBpAGwALgBjAG8AbQA=;Sosha1_v1;7;{DD4352D3-9989-4222-AF78-B4DC4C57AC57};cwBlAGkAagBpAC4AYQBnAHUAYwBoAGkAQABoAGQAcwAuAGMAbwBtAA==;Tue,
 10 May 2011 15:00:44
 GMT;WwBSAEYAQwBdAFsAUABBAFQAQwBIAF0AIABwAHMAdABvAHIAZQA6ACAARQBGAEkAIABTAHUAcABwAG8AcgB0AA==
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4AFcHGJ031716

Hi,

This prototype patch enables EFI support of pstore.

This patch hasn't been implemented contents of pstore callback functions 
,writer/reader/eraser, yet because testing is needed more.

I would appreciate it if you could review usage of pstore on this patch. 

[Advantage of EFI]
 Pstore has APEI method to save kernel messages into some persistent storages such as NVRAM.
 In addition to APEI method, I suggest UEFI method because it has advantage from a point of 
 view of protection of data in NVRAM.

  - APEI 
    APEI driver maps NVRAM to virtual memory address for accessing to data of NVRAM. So, there 
    is a possibility that kernel corrupts data of NVRAM due to its bugs. That's less likely to 
    corrupt data of NVRAM
  - EFI
    When using EFI for accessing to data of NVRAM, we don't need to maps NVRAM to virtual memory 
    address because EFI allows to access to NVRAM with EFI runtime service only. 
    So, we have a small chance to corrupt data of NVRAM due to kernel's bug, compared to APEI.

[Patch Description]

This patch is updated from previous one.

- previous patch
  [RFC][PATCH]kmsg_dumper for NVRAM
  http://www.spinics.net/lists/linux-doc/msg02208.html

Changelog
 - added pstore structure for using pstore filesystem. 
 - deleted implementation of set_variables services.
 - changed kernel parameters name as follows.
    - nvram_kmsg_dump_enable ->  efi_pstore_enable
    - nvram_kmsg_dump_len -> efi_pstore_len
 - removed definition of efi_pstore_enable in case of CONFIG_EFI=y and CONFIG_X86=n
   in accordance with Cong Wangs's comments.

Description of boot paremeters is following.

 - efi_pstore_enable
   enable EFI support of pstore.

 - efi_pstore_len
   Sets the buffer size of EFI variable space used by pstore.

[TODO]
 - Implement pstore callback functions ,writer/reader/eraser.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 Documentation/kernel-parameters.txt |   10 ++++
 arch/x86/platform/efi/efi.c         |  100 +++++++++++++++++++++++++++++++++++
 include/linux/efi.h                 |    3 +
 init/main.c                         |    5 ++-
 4 files changed, 117 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..531597e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -705,6 +705,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efi_pstore_enable [X86]
+			Enable EFI support of pstore.
+
+	efi_pstore_len=n [X86]
+			Sets the buffer size of EFI variable space used
+			by pstore, in bytes.
+			Format: { n | nk | nM }
+			n must be a power of two. The default is the same
+			as default log_buf size set in the kernel config file.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0fe27d7..687ab19 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -37,6 +37,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/pstore.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -59,6 +60,25 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+int efi_pstore_enabled;
+#define __EFI_PSTORE_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
+static char __efi_pstore_buf[__EFI_PSTORE_LEN];
+static char *efi_pstore_buf = __efi_pstore_buf;
+static int efi_pstore_len = __EFI_PSTORE_LEN;
+
+static u64 efi_pstore_writer(enum pstore_type_id , size_t);
+static size_t efi_pstore_reader(u64 *, enum pstore_type_id *,
+				struct timespec *);
+static int efi_pstore_eraser(u64);
+
+static struct pstore_info efi_pstore_info = {
+	.owner		= NULL,
+	.name		= "efi_pstore",
+	.read		= efi_pstore_reader,
+	.write		= efi_pstore_writer,
+	.erase		= efi_pstore_eraser,
+};
+
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -611,3 +631,83 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+static int __init setup_efi_pstore_enable(char *arg)
+{
+	efi_pstore_enabled = 1;
+	return 0;
+}
+__setup("efi_pstore_enable", setup_efi_pstore_enable);
+
+static int __init setup_efi_pstore_len(char *str)
+{
+	unsigned size;
+
+	if (!efi_enabled) {
+		printk(KERN_INFO "setup_efi_pstore_len: EFI is disabled.\n");
+		return 1;
+	}
+
+	size = memparse(str, &str);
+	if (size)
+		size = roundup_pow_of_two(size);
+	if (size > efi_pstore_len) {
+		char *new_efi_pstore_buf;
+
+		new_efi_pstore_buf = alloc_bootmem(size);
+		if (!new_efi_pstore_buf) {
+			printk(KERN_WARNING "efi_pstore_len: "
+			       "allocation failed\n");
+			return 1;
+		}
+		efi_pstore_len = size;
+		efi_pstore_buf = new_efi_pstore_buf;
+	}
+	printk(KERN_NOTICE "efi_pstore_len: %d\n", efi_pstore_len);
+
+	return 0;
+
+}
+__setup("efi_pstore_len=", setup_efi_pstore_len);
+
+static u64 efi_pstore_writer(enum pstore_type_id type, size_t size)
+{
+
+	/* not implement */
+
+	return -EINVAL;
+}
+
+static size_t efi_pstore_reader(u64 *id, enum pstore_type_id *type,
+			 struct timespec *time)
+{
+	/* not implement */
+	printk(KERN_INFO "efi_pstore not implement\n");
+	return -EINVAL;
+}
+
+static int efi_pstore_eraser(u64 record_id)
+{
+	/* not implement */
+
+	return -EINVAL;
+}
+
+void efi_pstore_init(void)
+{
+
+	int rc = 0;
+
+	efi_pstore_info.buf = efi_pstore_buf;
+	efi_pstore_info.bufsize = efi_pstore_len;
+	mutex_init(&efi_pstore_info.buf_mutex);
+
+	rc = pstore_register(&efi_pstore_info);
+	if (rc) {
+		printk(KERN_ERR "efi_pstore_init: fail %d\n", rc);
+		return;
+	}
+	printk(KERN_NOTICE "efi_pstore initialized\n");
+
+	return;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 33fa120..7a8f900 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -290,6 +290,7 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void efi_pstore_init(void);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
@@ -333,11 +334,13 @@ extern int __init efi_setup_pcdp_console(char *);
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
    extern int efi_enabled;
+   extern int efi_pstore_enabled;
 # else
 #  define efi_enabled 1
 # endif
 #else
 # define efi_enabled 0
+# define efi_pstore_enabled 0
 #endif
 
 /*
diff --git a/init/main.c b/init/main.c
index 4a9479e..eae313b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -591,8 +591,11 @@ asmlinkage void __init start_kernel(void)
 	pidmap_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-	if (efi_enabled)
+	if (efi_enabled) {
 		efi_enter_virtual_mode();
+		if (efi_pstore_enabled)
+			efi_pstore_init();
+	}
 #endif
 	thread_info_cache_init();
 	cred_init();
-- 
1.7.1

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
