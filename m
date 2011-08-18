Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1HRDF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:05:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab1HRDF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:05:26 -0400
Message-ID: <4E4C81ED.1070609@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 11:07:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] kvm tools: remove count in io emulation callbacks
References: <4E4C81CE.8030508@cn.fujitsu.com>
In-Reply-To: <4E4C81CE.8030508@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:04:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:04:13,
	Serialize complete at 2011-08-18 11:04:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'count' parameter in io emulation callbacks is useless, just remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/kvm/hw/i8042.c           |    4 ++--
 tools/kvm/hw/rtc.c             |    6 +++---
 tools/kvm/hw/serial.c          |    6 +++---
 tools/kvm/hw/vesa.c            |    4 ++--
 tools/kvm/include/kvm/ioport.h |    4 ++--
 tools/kvm/ioport.c             |   10 +++++-----
 tools/kvm/pci.c                |    8 ++++----
 tools/kvm/virtio/9p.c          |   10 +++++-----
 tools/kvm/virtio/balloon.c     |   16 ++++++++--------
 tools/kvm/virtio/blk.c         |   10 +++++-----
 tools/kvm/virtio/console.c     |   10 +++++-----
 tools/kvm/virtio/net.c         |   10 +++++-----
 tools/kvm/virtio/rng.c         |    4 ++--
 13 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/tools/kvm/hw/i8042.c b/tools/kvm/hw/i8042.c
index 262368e..3a36425 100644
--- a/tools/kvm/hw/i8042.c
+++ b/tools/kvm/hw/i8042.c
@@ -294,7 +294,7 @@ static void kbd_reset(void)
 /*
  * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
  */
-static bool kbd_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool kbd_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	switch (port) {
 	case I8042_COMMAND_REG: {
@@ -314,7 +314,7 @@ static bool kbd_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data,
 	return true;
 }
 
-static bool kbd_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool kbd_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	switch (port) {
 	case I8042_COMMAND_REG: {
diff --git a/tools/kvm/hw/rtc.c b/tools/kvm/hw/rtc.c
index 146f660..c6879cc 100644
--- a/tools/kvm/hw/rtc.c
+++ b/tools/kvm/hw/rtc.c
@@ -19,7 +19,7 @@ static inline unsigned char bin2bcd(unsigned val)
 	return ((val / 10) << 4) + val % 10;
 }
 
-static bool cmos_ram_data_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool cmos_ram_data_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct tm *tm;
 	time_t ti;
@@ -52,7 +52,7 @@ static bool cmos_ram_data_in(struct ioport *ioport, struct kvm *kvm, u16 port, v
 	return true;
 }
 
-static bool cmos_ram_data_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool cmos_ram_data_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	return true;
 }
@@ -62,7 +62,7 @@ static struct ioport_operations cmos_ram_data_ioport_ops = {
 	.io_in		= cmos_ram_data_in,
 };
 
-static bool cmos_ram_index_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool cmos_ram_index_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	u8 value;
 
diff --git a/tools/kvm/hw/serial.c b/tools/kvm/hw/serial.c
index 1199264..c9da7f1 100644
--- a/tools/kvm/hw/serial.c
+++ b/tools/kvm/hw/serial.c
@@ -164,7 +164,7 @@ static struct serial8250_device *find_device(u16 port)
 	return NULL;
 }
 
-static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct serial8250_device *dev;
 	u16 offset;
@@ -214,7 +214,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port, voi
 			char *addr = data;
 
 			if (!(dev->mcr & UART_MCR_LOOP))
-				term_putc(CONSOLE_8250, addr, size * count);
+				term_putc(CONSOLE_8250, addr, size);
 
 			dev->iir		= UART_IIR_NO_INT;
 			break;
@@ -252,7 +252,7 @@ out_unlock:
 	return ret;
 }
 
-static bool serial8250_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool serial8250_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct serial8250_device *dev;
 	u16 offset;
diff --git a/tools/kvm/hw/vesa.c b/tools/kvm/hw/vesa.c
index 9caa6c4..22b1652 100644
--- a/tools/kvm/hw/vesa.c
+++ b/tools/kvm/hw/vesa.c
@@ -15,12 +15,12 @@
 #include <inttypes.h>
 #include <unistd.h>
 
-static bool vesa_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool vesa_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	return true;
 }
 
-static bool vesa_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool vesa_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	return true;
 }
diff --git a/tools/kvm/include/kvm/ioport.h b/tools/kvm/include/kvm/ioport.h
index 59f118f..45c3856 100644
--- a/tools/kvm/include/kvm/ioport.h
+++ b/tools/kvm/include/kvm/ioport.h
@@ -23,8 +23,8 @@ struct ioport {
 };
 
 struct ioport_operations {
-	bool (*io_in)(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count);
-	bool (*io_out)(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count);
+	bool (*io_in)(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size);
+	bool (*io_out)(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size);
 };
 
 void ioport__setup_legacy(void);
diff --git a/tools/kvm/ioport.c b/tools/kvm/ioport.c
index 6b0bd30..7cbc44e 100644
--- a/tools/kvm/ioport.c
+++ b/tools/kvm/ioport.c
@@ -52,7 +52,7 @@ static int ioport_insert(struct rb_root *root, struct ioport *data)
 	return rb_int_insert(root, &data->node);
 }
 
-static bool debug_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool debug_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	exit(EXIT_SUCCESS);
 }
@@ -61,12 +61,12 @@ static struct ioport_operations debug_ops = {
 	.io_out		= debug_io_out,
 };
 
-static bool dummy_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool dummy_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	return true;
 }
 
-static bool dummy_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool dummy_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	return true;
 }
@@ -141,10 +141,10 @@ bool kvm__emulate_io(struct kvm *kvm, u16 port, void *data, int direction, int s
 	while (count--) {
 		if (direction == KVM_EXIT_IO_IN) {
 			if (ops->io_in)
-				ret = ops->io_in(entry, kvm, port, ptr, size, count);
+				ret = ops->io_in(entry, kvm, port, ptr, size);
 		} else {
 			if (ops->io_out)
-				ret = ops->io_out(entry, kvm, port, ptr, size, count);
+				ret = ops->io_out(entry, kvm, port, ptr, size);
 		}
 
 		ptr += size;
diff --git a/tools/kvm/pci.c b/tools/kvm/pci.c
index 0449aca..f72f513 100644
--- a/tools/kvm/pci.c
+++ b/tools/kvm/pci.c
@@ -35,7 +35,7 @@ static void *pci_config_address_ptr(u16 port)
 	return base + offset;
 }
 
-static bool pci_config_address_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool pci_config_address_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	void *p = pci_config_address_ptr(port);
 
@@ -44,7 +44,7 @@ static bool pci_config_address_out(struct ioport *ioport, struct kvm *kvm, u16 p
 	return true;
 }
 
-static bool pci_config_address_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool pci_config_address_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	void *p = pci_config_address_ptr(port);
 
@@ -76,7 +76,7 @@ static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_numbe
 	return dev != NULL;
 }
 
-static bool pci_config_data_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool pci_config_data_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long start;
 	u8 dev_num;
@@ -122,7 +122,7 @@ static bool pci_config_data_out(struct ioport *ioport, struct kvm *kvm, u16 port
 	return true;
 }
 
-static bool pci_config_data_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool pci_config_data_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long start;
 	u8 dev_num;
diff --git a/tools/kvm/virtio/9p.c b/tools/kvm/virtio/9p.c
index 365c08e..79c4354 100644
--- a/tools/kvm/virtio/9p.c
+++ b/tools/kvm/virtio/9p.c
@@ -29,11 +29,11 @@ static const char *rel_to_abs(struct p9_dev *p9dev,
 
 static bool virtio_p9_dev_in(struct p9_dev *p9dev, void *data,
 			     unsigned long offset,
-			     int size, u32 count)
+			     int size)
 {
 	u8 *config_space = (u8 *) p9dev->config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	ioport__write8(data, config_space[offset - VIRTIO_MSI_CONFIG_VECTOR]);
@@ -42,7 +42,7 @@ static bool virtio_p9_dev_in(struct p9_dev *p9dev, void *data,
 }
 
 static bool virtio_p9_pci_io_in(struct ioport *ioport, struct kvm *kvm,
-				u16 port, void *data, int size, u32 count)
+				u16 port, void *data, int size)
 {
 	bool ret = true;
 	unsigned long offset;
@@ -76,7 +76,7 @@ static bool virtio_p9_pci_io_in(struct ioport *ioport, struct kvm *kvm,
 		p9dev->isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_p9_dev_in(p9dev, data, offset, size, count);
+		ret = virtio_p9_dev_in(p9dev, data, offset, size);
 		break;
 	};
 
@@ -740,7 +740,7 @@ static void ioevent_callback(struct kvm *kvm, void *param)
 }
 
 static bool virtio_p9_pci_io_out(struct ioport *ioport, struct kvm *kvm,
-				 u16 port, void *data, int size, u32 count)
+				 u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
diff --git a/tools/kvm/virtio/balloon.c b/tools/kvm/virtio/balloon.c
index 854d04b..2619a10 100644
--- a/tools/kvm/virtio/balloon.c
+++ b/tools/kvm/virtio/balloon.c
@@ -47,11 +47,11 @@ struct bln_dev {
 static struct bln_dev bdev;
 extern struct kvm *kvm;
 
-static bool virtio_bln_dev_in(void *data, unsigned long offset, int size, u32 count)
+static bool virtio_bln_dev_in(void *data, unsigned long offset, int size)
 {
 	u8 *config_space = (u8 *) &bdev.config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	ioport__write8(data, config_space[offset - VIRTIO_MSI_CONFIG_VECTOR]);
@@ -59,11 +59,11 @@ static bool virtio_bln_dev_in(void *data, unsigned long offset, int size, u32 co
 	return true;
 }
 
-static bool virtio_bln_dev_out(void *data, unsigned long offset, int size, u32 count)
+static bool virtio_bln_dev_out(void *data, unsigned long offset, int size)
 {
 	u8 *config_space = (u8 *) &bdev.config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	config_space[offset - VIRTIO_MSI_CONFIG_VECTOR] = *(u8 *)data;
@@ -71,7 +71,7 @@ static bool virtio_bln_dev_out(void *data, unsigned long offset, int size, u32 c
 	return true;
 }
 
-static bool virtio_bln_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_bln_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
@@ -102,7 +102,7 @@ static bool virtio_bln_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 por
 		bdev.isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_bln_dev_in(data, offset, size, count);
+		ret = virtio_bln_dev_in(data, offset, size);
 		break;
 	};
 
@@ -152,7 +152,7 @@ static void ioevent_callback(struct kvm *kvm, void *param)
 	thread_pool__do_job(param);
 }
 
-static bool virtio_bln_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_bln_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
@@ -206,7 +206,7 @@ static bool virtio_bln_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 po
 		bdev.config_vector	= VIRTIO_MSI_NO_VECTOR;
 		break;
 	default:
-		ret = virtio_bln_dev_out(data, offset, size, count);
+		ret = virtio_bln_dev_out(data, offset, size);
 		break;
 	};
 
diff --git a/tools/kvm/virtio/blk.c b/tools/kvm/virtio/blk.c
index f5ecdd9..343c540 100644
--- a/tools/kvm/virtio/blk.c
+++ b/tools/kvm/virtio/blk.c
@@ -60,11 +60,11 @@ struct blk_dev {
 
 static LIST_HEAD(bdevs);
 
-static bool virtio_blk_dev_in(struct blk_dev *bdev, void *data, unsigned long offset, int size, u32 count)
+static bool virtio_blk_dev_in(struct blk_dev *bdev, void *data, unsigned long offset, int size)
 {
 	u8 *config_space = (u8 *) &bdev->blk_config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	ioport__write8(data, config_space[offset - VIRTIO_MSI_CONFIG_VECTOR]);
@@ -72,7 +72,7 @@ static bool virtio_blk_dev_in(struct blk_dev *bdev, void *data, unsigned long of
 	return true;
 }
 
-static bool virtio_blk_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_blk_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct blk_dev *bdev;
 	u16 offset;
@@ -112,7 +112,7 @@ static bool virtio_blk_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 por
 		ioport__write16(data, bdev->config_vector);
 		break;
 	default:
-		ret = virtio_blk_dev_in(bdev, data, offset, size, count);
+		ret = virtio_blk_dev_in(bdev, data, offset, size);
 		break;
 	};
 
@@ -189,7 +189,7 @@ static void virtio_blk_do_io(struct kvm *kvm, struct virt_queue *vq, struct blk_
 	}
 }
 
-static bool virtio_blk_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_blk_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct blk_dev *bdev;
 	u16 offset;
diff --git a/tools/kvm/virtio/console.c b/tools/kvm/virtio/console.c
index e5d59c0..2bb9b50 100644
--- a/tools/kvm/virtio/console.c
+++ b/tools/kvm/virtio/console.c
@@ -96,11 +96,11 @@ void virtio_console__inject_interrupt(struct kvm *kvm)
 	thread_pool__do_job(&cdev.jobs[VIRTIO_CONSOLE_RX_QUEUE]);
 }
 
-static bool virtio_console_pci_io_device_specific_in(void *data, unsigned long offset, int size, u32 count)
+static bool virtio_console_pci_io_device_specific_in(void *data, unsigned long offset, int size)
 {
 	u8 *config_space = (u8 *) &cdev.console_config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	if ((offset - VIRTIO_MSI_CONFIG_VECTOR) > sizeof(struct virtio_console_config))
@@ -111,7 +111,7 @@ static bool virtio_console_pci_io_device_specific_in(void *data, unsigned long o
 	return true;
 }
 
-static bool virtio_console_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_console_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset = port - cdev.base_addr;
 	bool ret = true;
@@ -147,7 +147,7 @@ static bool virtio_console_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16
 		ioport__write16(data, cdev.config_vector);
 		break;
 	default:
-		ret = virtio_console_pci_io_device_specific_in(data, offset, size, count);
+		ret = virtio_console_pci_io_device_specific_in(data, offset, size);
 	};
 
 	mutex_unlock(&cdev.mutex);
@@ -179,7 +179,7 @@ static void virtio_console_handle_callback(struct kvm *kvm, void *param)
 
 }
 
-static bool virtio_console_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_console_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset = port - cdev.base_addr;
 	bool ret = true;
diff --git a/tools/kvm/virtio/net.c b/tools/kvm/virtio/net.c
index e865b7f..78024ab 100644
--- a/tools/kvm/virtio/net.c
+++ b/tools/kvm/virtio/net.c
@@ -172,11 +172,11 @@ static void *virtio_net_tx_thread(void *p)
 
 }
 
-static bool virtio_net_pci_io_device_specific_in(void *data, unsigned long offset, int size, u32 count)
+static bool virtio_net_pci_io_device_specific_in(void *data, unsigned long offset, int size)
 {
 	u8 *config_space = (u8 *)&ndev.config;
 
-	if (size != 1 || count != 1)
+	if (size != 1)
 		return false;
 
 	if ((offset - VIRTIO_MSI_CONFIG_VECTOR) > sizeof(struct virtio_net_config))
@@ -187,7 +187,7 @@ static bool virtio_net_pci_io_device_specific_in(void *data, unsigned long offse
 	return true;
 }
 
-static bool virtio_net_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_net_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long	offset	= port - ndev.base_addr;
 	bool		ret	= true;
@@ -220,7 +220,7 @@ static bool virtio_net_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 por
 		ndev.isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_net_pci_io_device_specific_in(data, offset, size, count);
+		ret = virtio_net_pci_io_device_specific_in(data, offset, size);
 	};
 
 	mutex_unlock(&ndev.mutex);
@@ -246,7 +246,7 @@ static void virtio_net_handle_callback(struct kvm *kvm, u16 queue_index)
 	}
 }
 
-static bool virtio_net_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_net_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long	offset		= port - ndev.base_addr;
 	bool		ret		= true;
diff --git a/tools/kvm/virtio/rng.c b/tools/kvm/virtio/rng.c
index 5f29ded..c8b827a 100644
--- a/tools/kvm/virtio/rng.c
+++ b/tools/kvm/virtio/rng.c
@@ -50,7 +50,7 @@ struct rng_dev {
 
 static LIST_HEAD(rdevs);
 
-static bool virtio_rng_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_rng_pci_io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
@@ -120,7 +120,7 @@ static void virtio_rng_do_io(struct kvm *kvm, void *param)
 	kvm__irq_line(kvm, rdev->pci_hdr.irq_line, VIRTIO_IRQ_HIGH);
 }
 
-static bool virtio_rng_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size, u32 count)
+static bool virtio_rng_pci_io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
-- 
1.7.5.4

