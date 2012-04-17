Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2DQDLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:11:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2DQDLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:11:42 -0400
X-IronPort-AV: E=Sophos;i="4.75,432,1330876800"; 
   d="scan'208,223";a="4768084"
Message-ID: <4F8CE026.1050205@cn.fujitsu.com>
Date: Tue, 17 Apr 2012 11:14:46 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com> <4F6854F4.3060703@cn.fujitsu.com> <20120320154517.GG27928@redhat.com>
In-Reply-To: <20120320154517.GG27928@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 11:10:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 11:10:48,
	Serialize complete at 2012/04/17 11:10:48
Content-Type: multipart/mixed;
 boundary="------------020707050400000107060308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707050400000107060308
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

At 03/20/2012 11:45 PM, Gleb Natapov Wrote:
> On Tue, Mar 20, 2012 at 05:59:16PM +0800, Wen Congyang wrote:
>> At 03/19/2012 03:33 PM, Wen Congyang Wrote:
>>> At 03/08/2012 03:57 PM, Wen Congyang Wrote:
>>>> We can know the guest is paniced when the guest runs on xen.
>>>> But we do not have such feature on kvm.
>>>>
>>>> Another purpose of this feature is: management app(for example:
>>>> libvirt) can do auto dump when the guest is crashed. If management
>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>> he sees the guest is paniced.
>>>>
>>>> I touch the hypervisor instead of using virtio-serial, because
>>>> 1. it is simple
>>>> 2. the virtio-serial is an optional device, and the guest may
>>>>    not have such device.
>>>>
>>>> Changes from v2 to v3:
>>>> 1. correct spelling
>>>>
>>>> Changes from v1 to v2:
>>>> 1. split up host and guest-side changes
>>>> 2. introduce new request flag to avoid changing return values.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>> Hi all:
>>>
>>> we neet this feature, but we don't decide how to implement it.
>>> We have two solution:
>>> 1. use vmcall
>>> 2. use virtio-serial.
>>>
>>> I will not change this patch set before we decide how to do it.
>>> Can we make a decision recent days?
>>
>> Anybody can decide which solution to use?
>>
> To make an informed decision we need to have at least raw idea how
> virtio-serial variant will look.

We have three solutions now:
1. use vmcall
2. use I/O port
3. use virtio-serial

I write a sample patch of solution 2 and 3:
    patch 1: solution 2
    patch 2: solution 3

Note, ther are only sample patches, and it can work. I send them, so we
can decide which solution will be used.

Thanks
Wen Congyang



> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


--------------020707050400000107060308
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0001-kvm-notify-host-when-guest-panicked.patch"
Content-Disposition: attachment;
 filename="0001-kvm-notify-host-when-guest-panicked.patch"

>From 2c819655982a0b3043892e994fb87fd44fdca686 Mon Sep 17 00:00:00 2001
From: Wen Congyang <wency@cn.fujitsu.com>
Date: Tue, 17 Apr 2012 10:44:40 +0800
Subject: [PATCH] kvm: notify host when guest panicked

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/ia64/include/asm/kvm_para.h    |    5 +++++
 arch/powerpc/include/asm/kvm_para.h |    5 +++++
 arch/s390/include/asm/kvm_para.h    |    5 +++++
 arch/x86/include/asm/kvm_para.h     |    7 +++++++
 arch/x86/kernel/kvm.c               |   14 ++++++++++++++
 include/linux/kvm_para.h            |   13 +++++++++++++
 6 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
index 1588aee..a890096 100644
--- a/arch/ia64/include/asm/kvm_para.h
+++ b/arch/ia64/include/asm/kvm_para.h
@@ -26,6 +26,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 7b754e7..b5f7c35 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -206,6 +206,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return r;
 }
 
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* __POWERPC_KVM_PARA_H__ */
diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index 6964db2..21a8d18 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -149,6 +149,11 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* __S390_KVM_PARA_H */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..02e214a 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -208,6 +208,13 @@ static inline void kvm_disable_steal_time(void)
 }
 #endif
 
+#define KVM_PV_PORT	(0x505UL)
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return inl(KVM_PV_PORT);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ba6e4..adfde45 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -335,6 +335,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
+static int
+kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
+{
+	outl(KVM_PV_PANICKED, KVM_PV_PORT);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_panic_nb = {
+	.notifier_call = kvm_pv_panic_notify,
+};
+
 static u64 kvm_steal_clock(int cpu)
 {
 	u64 steal;
@@ -421,6 +432,9 @@ void __init kvm_guest_init(void)
 
 	paravirt_ops_setup();
 	register_reboot_notifier(&kvm_pv_reboot_nb);
+	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
+		atomic_notifier_chain_register(&panic_notifier_list,
+			&kvm_pv_panic_nb);
 	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
 		spin_lock_init(&async_pf_sleepers[i].lock);
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index ff476dd..e73efcf 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+/* The bit of the value read from KVM_PV_PORT */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The value writen to KVM_PV_PORT */
+#define KVM_PV_PANICKED		1
+
 /*
  * hypercalls use architecture specific
  */
@@ -33,5 +39,12 @@ static inline int kvm_para_has_feature(unsigned int feature)
 		return 1;
 	return 0;
 }
+
+static inline int kvm_pv_has_feature(unsigned int feature)
+{
+	if (kvm_arch_pv_features() & (1UL << feature))
+		return 1;
+	return 0;
+}
 #endif /* __KERNEL__ */
 #endif /* __LINUX_KVM_PARA_H */
-- 
1.7.1


--------------020707050400000107060308
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0002-kvm-notify-host-when-guest-panicked.patch"
Content-Disposition: attachment;
 filename="0002-kvm-notify-host-when-guest-panicked.patch"

>From cb39cb1f36d4c37b3dc7942413550bb4b7c79a84 Mon Sep 17 00:00:00 2001
From: Wen Congyang <wency@cn.fujitsu.com>
Date: Tue, 17 Apr 2012 11:01:01 +0800
Subject: [PATCH] kvm: nofity thost when guest is panicked

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/char/virtio_console.c |   49 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index ddf86b6..ecccd30 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -225,8 +225,14 @@ struct port {
 
 	/* We should allow only one process to open a port */
 	bool guest_connected;
+
+	/* We use this port to tell the host that the guest is panicked */
+	bool panicked_port;
+	char *panicked_buf;
 };
 
+static struct port *panicked_port;
+
 /* This is the very early arch-specified put chars function. */
 static int (*early_put_chars)(u32, const char *, int);
 
@@ -806,6 +812,15 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
+	/*
+	 * Don't allow opening of panicked port devices -- that's reserved
+	 * for kernel space
+	 */
+	if (port->panicked_port) {
+		ret = -ENXIO;
+		goto out;
+	}
+
 	/* Allow only one process to open a particular port at a time */
 	spin_lock_irq(&port->inbuf_lock);
 	if (port->guest_connected) {
@@ -1126,6 +1141,20 @@ static void send_sigio_to_port(struct port *port)
 		kill_fasync(&port->async_queue, SIGIO, POLL_OUT);
 }
 
+static int
+kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
+{
+	send_control_msg(panicked_port, VIRTIO_CONSOLE_PORT_OPEN, 1);
+	memcpy(panicked_port->panicked_buf, "Kernel panicked\n", 16);
+	send_buf(panicked_port, panicked_port->panicked_buf, 16, true);
+	send_control_msg(panicked_port, VIRTIO_CONSOLE_CONSOLE_PORT, 0);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_panic_nb = {
+	.notifier_call = kvm_pv_panic_notify,
+};
+
 static int add_port(struct ports_device *portdev, u32 id)
 {
 	char debugfs_name[16];
@@ -1262,6 +1291,10 @@ static void remove_port(struct kref *kref)
 
 	debugfs_remove(port->debugfs_file);
 
+	if (port->panicked_port)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &kvm_pv_panic_nb);
+
 	kfree(port);
 }
 
@@ -1433,6 +1466,22 @@ static void handle_control_message(struct ports_device *portdev,
 			name_size - 1);
 		port->name[name_size - 1] = 0;
 
+		if (!panicked_port && !strcmp(port->name, "status")) {
+			port->panicked_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+			if (!port->panicked_buf) {
+				dev_warn(port->dev,
+					 "Not enough space to store panicked"
+					 " message");
+				goto skip;
+			}
+			send_sigio_to_port(port);
+			port->panicked_port = true;
+			panicked_port = port;
+			atomic_notifier_chain_register(&panic_notifier_list,
+						       &kvm_pv_panic_nb);
+		}
+
+skip:
 		/*
 		 * Since we only have one sysfs attribute, 'name',
 		 * create it only if we have a name for the port.
-- 
1.7.1


--------------020707050400000107060308--
