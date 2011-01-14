Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1ANVKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:10:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37501 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1ANVKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:10:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: BUG: spinlock bad magic on CPU#0
Date: Fri, 14 Jan 2011 22:09:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110114140803.GA4003@swordfish>
In-Reply-To: <20110114140803.GA4003@swordfish>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101142209.35892.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 14, 2011, Sergey Senozhatsky wrote:
> Hello,

Hi,

> Acer Aspire  5741g
> 2.6.37-git11
> 
> Got this trace today:
> 
> [    0.814609] ACPI: EC: Look up EC in DSDT
> [    0.825556] BUG: spinlock bad magic on CPU#0, swapper/1
> [    0.825639]  lock: ffffffff8242fa90, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> [    0.825741] Pid: 1, comm: swapper Not tainted 2.6.37-dbg-git11-07456-gdbc61c6-dirty #359
> [    0.825841] Call Trace:
> [    0.825923]  [<ffffffff81247919>] ? spin_bug+0x9c/0xa3
> [    0.826004]  [<ffffffff812479e9>] ? do_raw_spin_lock+0x29/0x122
> [    0.826093]  [<ffffffff814867e5>] ? _raw_spin_lock_irqsave+0x56/0x60
> [    0.826181]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
> [    0.826264]  [<ffffffff81275e8a>] ? acpi_os_acquire_lock+0x9/0xb
> [    0.826350]  [<ffffffff81288fad>] ? acpi_ev_acquire_global_lock+0x10b/0x206
> [    0.826438]  [<ffffffff8129620c>] ? acpi_ex_acquire_mutex_object+0xa3/0x11d
> [    0.826525]  [<ffffffff812952e3>] ? acpi_ex_acquire_global_lock+0x61/0xa2
> [    0.826613]  [<ffffffff8128def7>] ? acpi_ex_read_data_from_field+0x293/0x2f1
> [    0.826701]  [<ffffffff81296e88>] ? acpi_ex_resolve_node_to_value+0x320/0x444
> [    0.826789]  [<ffffffff812a8587>] ? acpi_ut_trace_ptr+0x58/0x65
> [    0.826874]  [<ffffffff8128efb1>] ? acpi_ex_resolve_to_value+0x379/0x406
> [    0.826961]  [<ffffffff81284efb>] ? acpi_ds_evaluate_name_path+0x9e/0x143
> [    0.827048]  [<ffffffff812824c5>] ? acpi_ds_exec_end_op+0xda/0x641
> [    0.827131]  [<ffffffff812a844c>] ? acpi_ut_status_exit+0x6f/0x80
> [    0.827216]  [<ffffffff812a2e5c>] ? acpi_ps_parse_loop+0xc65/0xf45
> [    0.827302]  [<ffffffff812a1acf>] ? acpi_ps_parse_aml+0x162/0x467
> [    0.827385]  [<ffffffff812a8691>] ? acpi_ut_ptr_exit+0x33/0x3b
> [    0.827470]  [<ffffffff812a3b5a>] ? acpi_ps_execute_method+0x26d/0x393
> [    0.827558]  [<ffffffff8129c14d>] ? acpi_ns_evaluate+0x235/0x3b7
> [    0.827643]  [<ffffffff812ab605>] ? acpi_ut_add_reference+0xb1/0xb8
> [    0.827730]  [<ffffffff8129c42a>] ? acpi_ns_exec_module_code_list+0x15b/0x25d
> [    0.827818]  [<ffffffff812a9dbb>] ? acpi_initialize_objects+0x88/0x17d
> [    0.827907]  [<ffffffff81ad43ff>] ? acpi_init+0x0/0x10a
> [    0.827990]  [<ffffffff81ad42c1>] ? acpi_bus_init+0x9f/0x1dd
> [    0.828076]  [<ffffffff8123c24b>] ? kobject_create_and_add+0x37/0x68
> [    0.828162]  [<ffffffff81ad4470>] ? acpi_init+0x71/0x10a
> [    0.828248]  [<ffffffff810002ee>] ? do_one_initcall+0x7a/0x13c
> [    0.828334]  [<ffffffff81aacda0>] ? kernel_init+0x16c/0x1f0
> [    0.828420]  [<ffffffff81002fa4>] ? kernel_thread_helper+0x4/0x10
> [    0.828506]  [<ffffffff81031ab3>] ? finish_task_switch+0x78/0xec
> [    0.828592]  [<ffffffff81487318>] ? restore_args+0x0/0x30
> [    0.828677]  [<ffffffff81aacc34>] ? kernel_init+0x0/0x1f0
> [    0.828760]  [<ffffffff81002fa0>] ? kernel_thread_helper+0x0/0x10
> [    0.828935] ACPI: Executed 1 blocks of module-level executable AML code

Does the appended patch help?

Rafael


---
 drivers/acpi/acpica/acglobal.h |    2 ++
 drivers/acpi/acpica/evmisc.c   |    2 --
 drivers/acpi/acpica/utmutex.c  |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/acglobal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/acglobal.h
+++ linux-2.6/drivers/acpi/acpica/acglobal.h
@@ -228,8 +228,10 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pres
  */
 ACPI_EXTERN spinlock_t _acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
 ACPI_EXTERN spinlock_t _acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN spinlock_t _acpi_ev_global_lock_pending_lock; /* For global lock */
 #define acpi_gbl_gpe_lock	&_acpi_gbl_gpe_lock
 #define acpi_gbl_hardware_lock	&_acpi_gbl_hardware_lock
+#define acpi_ev_global_lock_pending_lock &_acpi_ev_global_lock_pending_lock
 
 /*****************************************************************************
  *
Index: linux-2.6/drivers/acpi/acpica/evmisc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evmisc.c
+++ linux-2.6/drivers/acpi/acpica/evmisc.c
@@ -293,8 +293,6 @@ static void ACPI_SYSTEM_XFACE acpi_ev_no
  *
  ******************************************************************************/
 static u8 acpi_ev_global_lock_pending;
-static spinlock_t _acpi_ev_global_lock_pending_lock;
-#define acpi_ev_global_lock_pending_lock &_acpi_ev_global_lock_pending_lock
 
 static u32 acpi_ev_global_lock_handler(void *context)
 {
Index: linux-2.6/drivers/acpi/acpica/utmutex.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/utmutex.c
+++ linux-2.6/drivers/acpi/acpica/utmutex.c
@@ -85,6 +85,7 @@ acpi_status acpi_ut_mutex_initialize(voi
 
 	spin_lock_init(acpi_gbl_gpe_lock);
 	spin_lock_init(acpi_gbl_hardware_lock);
+	spin_lock_init(acpi_ev_global_lock_pending_lock);
 
 	/* Mutex for _OSI support */
 	status = acpi_os_create_mutex(&acpi_gbl_osi_mutex);
