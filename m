Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab2CBXIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:08:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46342 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab2CBXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:08:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mcgrof@gmail.com designates 10.68.231.133 as permitted sender) smtp.mail=mcgrof@gmail.com; dkim=pass header.i=mcgrof@gmail.com
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH] compat: makes all compat symbols EXPORT_SYMBOL_GPL()
Date: Fri,  2 Mar 2012 15:08:26 -0800
Message-Id: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.4.15.g7811d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel is being backported here and a lot of code
is completely derivative works of the the Linux kernel, as such
only GPL-Compatible modules are intended to be used with this
framework, given that users of this framework are considered
completely derivative works of the Linux kernel.

Only upstream Linux kernel modules or kernel modules on their
way upstream are intended to be used by this.
Tested with ckmake:

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic	[OK]
Trying kernel                     3.2.2-030202-generic	[OK]
Trying kernel                    3.1.10-030110-generic	[OK]
Trying kernel                    3.0.18-030018-generic	[OK]
Trying kernel                  2.6.39-02063904-generic	[OK]
Trying kernel                        2.6.38-13-generic	[OK]
Trying kernel                  2.6.38-02063808-generic	[OK]
Trying kernel                  2.6.37-02063706-generic	[OK]
Trying kernel                  2.6.36-02063604-generic	[OK]
Trying kernel                  2.6.35-02063512-generic	[OK]
Trying kernel                  2.6.34-02063410-generic	[OK]
Trying kernel                  2.6.33-02063305-generic	[OK]
Trying kernel                  2.6.32-02063255-generic	[OK]
Trying kernel                        2.6.31-22-generic	[OK]
Trying kernel                  2.6.31-02063113-generic	[OK]
Trying kernel                  2.6.30-02063010-generic	[OK]
Trying kernel                  2.6.29-02062906-generic	[OK]
Trying kernel                  2.6.28-02062810-generic	[OK]
Trying kernel                    2.6.27-020627-generic	[OK]
Trying kernel                    2.6.26-020626-generic	[OK]
Trying kernel                    2.6.25-020625-generic	[OK]
Trying kernel                    2.6.24-020624-generic	[OK]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat-2.6.23.c         |   10 ++++----
 compat/compat-2.6.24.c         |   10 ++++----
 compat/compat-2.6.25.c         |    4 +-
 compat/compat-2.6.27.c         |    4 +-
 compat/compat-2.6.28.c         |    8 +++---
 compat/compat-2.6.29.c         |    8 +++---
 compat/compat-2.6.32.c         |    2 +-
 compat/compat-2.6.33.c         |    4 +-
 compat/compat-2.6.35.c         |    4 +-
 compat/compat-2.6.37.c         |   12 +++++-----
 compat/compat-2.6.38.c         |    4 +-
 compat/compat-3.0.c            |    4 +-
 compat/compat-3.2.c            |    2 +-
 compat/compat_atomic.c         |    4 +-
 compat/compat_firmware_class.c |    6 ++--
 compat/cordic.c                |    2 +-
 compat/crc8.c                  |    6 ++--
 compat/kfifo.c                 |   42 ++++++++++++++++++++--------------------
 compat/kstrtox.c               |   20 +++++++++---------
 19 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index 67d0075..bc49e98 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -36,7 +36,7 @@ int __dev_addr_delete(struct dev_addr_list **list, int *count,
 	}
 	return -ENOENT;
 }
-EXPORT_SYMBOL(__dev_addr_delete);
+EXPORT_SYMBOL_GPL(__dev_addr_delete);
 
 /* On net/core/dev.c as of 2.6.24. This is not yet used by mac80211 but
  * might as well add it */
@@ -71,7 +71,7 @@ int __dev_addr_add(struct dev_addr_list **list, int *count,
 	(*count)++;
 	return 0;
 }
-EXPORT_SYMBOL(__dev_addr_add);
+EXPORT_SYMBOL_GPL(__dev_addr_add);
 
 
 /* Part of net/core/dev_mcast.c as of 2.6.23. This is a slightly different version.
@@ -128,7 +128,7 @@ int dev_mc_sync(struct net_device *to, struct net_device *from)
 
 	return err;
 }
-EXPORT_SYMBOL(dev_mc_sync);
+EXPORT_SYMBOL_GPL(dev_mc_sync);
 
 
 /* Part of net/core/dev_mcast.c as of 2.6.23. This is a slighty different version.
@@ -179,7 +179,7 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 	netif_tx_unlock_bh(to);
 	netif_tx_unlock_bh(from);
 }
-EXPORT_SYMBOL(dev_mc_unsync);
+EXPORT_SYMBOL_GPL(dev_mc_unsync);
 
 /* Added as of 2.6.23 on net/core/dev.c. Slightly modifed, no dev->set_rx_mode on
  * 2.6.22 so ignore that. */
@@ -234,6 +234,6 @@ int pci_try_set_mwi(struct pci_dev *dev)
 #endif
 	return rc;
 }
-EXPORT_SYMBOL(pci_try_set_mwi);
+EXPORT_SYMBOL_GPL(pci_try_set_mwi);
 #endif
 
diff --git a/compat/compat-2.6.24.c b/compat/compat-2.6.24.c
index b9ae16b..977db0c 100644
--- a/compat/compat-2.6.24.c
+++ b/compat/compat-2.6.24.c
@@ -16,7 +16,7 @@
  * for usage with tons of code that makes mention to it.
  */
 struct net init_net;
-EXPORT_SYMBOL(init_net);
+EXPORT_SYMBOL_GPL(init_net);
 
 /* 2.6.22 and 2.6.23 have eth_header_cache_update defined as extern in include/linux/etherdevice.h
  * and actually defined in net/ethernet/eth.c but 2.6.24 exports it. Lets export it here */
@@ -36,7 +36,7 @@ void eth_header_cache_update(struct hh_cache *hh,
 	memcpy(((u8 *) hh->hh_data) + HH_DATA_OFF(sizeof(struct ethhdr)),
 		haddr, ETH_ALEN);
 }
-EXPORT_SYMBOL(eth_header_cache_update);
+EXPORT_SYMBOL_GPL(eth_header_cache_update);
 
 /* 2.6.22 and 2.6.23 have eth_header_cache defined as extern in include/linux/etherdevice.h
  * and actually defined in net/ethernet/eth.c but 2.6.24 exports it. Lets export it here */
@@ -65,7 +65,7 @@ int eth_header_cache(struct neighbour *neigh, struct hh_cache *hh)
 	hh->hh_len = ETH_HLEN;
 	return 0;
 }
-EXPORT_SYMBOL(eth_header_cache);
+EXPORT_SYMBOL_GPL(eth_header_cache);
 
 /* 2.6.22 and 2.6.23 have eth_header() defined as extern in include/linux/etherdevice.h
  * and actually defined in net/ethernet/eth.c but 2.6.24 exports it. Lets export it here */
@@ -118,7 +118,7 @@ int eth_header(struct sk_buff *skb, struct net_device *dev, unsigned short type,
 	return -ETH_HLEN;
 }
 
-EXPORT_SYMBOL(eth_header);
+EXPORT_SYMBOL_GPL(eth_header);
 
 /* 2.6.22 and 2.6.23 have eth_rebuild_header defined as extern in include/linux/etherdevice.h
  * and actually defined in net/ethernet/eth.c but 2.6.24 exports it. Lets export it here */
@@ -154,5 +154,5 @@ int eth_rebuild_header(struct sk_buff *skb)
 
 	return 0;
 }
-EXPORT_SYMBOL(eth_rebuild_header);
+EXPORT_SYMBOL_GPL(eth_rebuild_header);
 
diff --git a/compat/compat-2.6.25.c b/compat/compat-2.6.25.c
index 7cb996b..2e9c3a8 100644
--- a/compat/compat-2.6.25.c
+++ b/compat/compat-2.6.25.c
@@ -92,6 +92,6 @@ int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
 define_strict_strtoux(l, unsigned long)
 define_strict_strtox(l, long)
 
-EXPORT_SYMBOL(strict_strtoul);
-EXPORT_SYMBOL(strict_strtol);
+EXPORT_SYMBOL_GPL(strict_strtoul);
+EXPORT_SYMBOL_GPL(strict_strtol);
 
diff --git a/compat/compat-2.6.27.c b/compat/compat-2.6.27.c
index 25bee28..762f0ca 100644
--- a/compat/compat-2.6.27.c
+++ b/compat/compat-2.6.27.c
@@ -64,7 +64,7 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
 
 	return !!(pme_support & (1 << state));
 }
-EXPORT_SYMBOL(pci_pme_capable);
+EXPORT_SYMBOL_GPL(pci_pme_capable);
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 /**
@@ -92,7 +92,7 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
 
 	return sz;
 }
-EXPORT_SYMBOL(mmc_align_data_size);
+EXPORT_SYMBOL_GPL(mmc_align_data_size);
 
 /*
  * Calculate the maximum byte mode transfer size
diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 72c9e09..235dbfa 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -161,7 +161,7 @@ next_entry:
 
 	return ret;
 }
-EXPORT_SYMBOL(pcmcia_loop_config);
+EXPORT_SYMBOL_GPL(pcmcia_loop_config);
 
 #endif /* CONFIG_PCMCIA */
 
@@ -311,7 +311,7 @@ void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 	skb->data_len += size;
 	skb->truesize += size;
 }
-EXPORT_SYMBOL(skb_add_rx_frag);
+EXPORT_SYMBOL_GPL(skb_add_rx_frag);
 
 void tty_write_unlock(struct tty_struct *tty)
 {
@@ -437,7 +437,7 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
-EXPORT_SYMBOL(n_tty_ioctl_helper);
+EXPORT_SYMBOL_GPL(n_tty_ioctl_helper);
 
 /**
  * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
@@ -459,5 +459,5 @@ int pci_wake_from_d3(struct pci_dev *dev, bool enable)
 			pci_enable_wake(dev, PCI_D3cold, enable) :
 			pci_enable_wake(dev, PCI_D3hot, enable);
 }
-EXPORT_SYMBOL(pci_wake_from_d3);
+EXPORT_SYMBOL_GPL(pci_wake_from_d3);
 
diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 14f5e90..1beb718 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -46,7 +46,7 @@ void netdev_attach_ops(struct net_device *dev,
 	dev->select_queue = ops->ndo_select_queue;
 #endif
 }
-EXPORT_SYMBOL(netdev_attach_ops);
+EXPORT_SYMBOL_GPL(netdev_attach_ops);
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 #if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
@@ -93,7 +93,7 @@ int eth_mac_addr(struct net_device *dev, void *p)
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
 	return 0;
 }
-EXPORT_SYMBOL(eth_mac_addr);
+EXPORT_SYMBOL_GPL(eth_mac_addr);
 
 /**
  * eth_change_mtu - set new MTU size
@@ -110,7 +110,7 @@ int eth_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 	return 0;
 }
-EXPORT_SYMBOL(eth_change_mtu);
+EXPORT_SYMBOL_GPL(eth_change_mtu);
 
 int eth_validate_addr(struct net_device *dev)
 {
@@ -119,7 +119,7 @@ int eth_validate_addr(struct net_device *dev)
 
 	return 0;
 }
-EXPORT_SYMBOL(eth_validate_addr);
+EXPORT_SYMBOL_GPL(eth_validate_addr);
 /* Source: net/ethernet/eth.c */
 
 #define NETREG_DUMMY 5
diff --git a/compat/compat-2.6.32.c b/compat/compat-2.6.32.c
index 0b3af07..b5a66a8 100644
--- a/compat/compat-2.6.32.c
+++ b/compat/compat-2.6.32.c
@@ -211,6 +211,6 @@ void time_to_tm(time_t totalsecs, int offset, struct tm *result)
 	result->tm_mon = y;
 	result->tm_mday = days + 1;
 }
-EXPORT_SYMBOL(time_to_tm);
+EXPORT_SYMBOL_GPL(time_to_tm);
 /* source: kernel/time/timeconv.c*/
 
diff --git a/compat/compat-2.6.33.c b/compat/compat-2.6.33.c
index c8e568d..04e2fd0 100644
--- a/compat/compat-2.6.33.c
+++ b/compat/compat-2.6.33.c
@@ -70,7 +70,7 @@ next_entry:
 	kfree(buf);
 	return ret;
 }
-EXPORT_SYMBOL(pccard_loop_tuple);
+EXPORT_SYMBOL_GPL(pccard_loop_tuple);
 /* Source: drivers/pcmcia/cistpl.c */
 
 #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
@@ -123,7 +123,7 @@ int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 	return pccard_loop_tuple(p_dev->socket, p_dev->func, code, NULL,
 				 &loop, pcmcia_do_loop_tuple);
 }
-EXPORT_SYMBOL(pcmcia_loop_tuple);
+EXPORT_SYMBOL_GPL(pcmcia_loop_tuple);
 /* Source: drivers/pcmcia/pcmcia_resource.c */
 
 #endif /* CONFIG_PCMCIA */
diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
index 7a31a54..2455172 100644
--- a/compat/compat-2.6.35.c
+++ b/compat/compat-2.6.35.c
@@ -27,7 +27,7 @@ int compat_hex_to_bin(char ch)
 		return ch - 'a' + 10;
 	return -1;
 }
-EXPORT_SYMBOL(compat_hex_to_bin);
+EXPORT_SYMBOL_GPL(compat_hex_to_bin);
 
 /**
  * noop_llseek - No Operation Performed llseek implementation
@@ -44,5 +44,5 @@ loff_t noop_llseek(struct file *file, loff_t offset, int origin)
 {
 	return file->f_pos;
 }
-EXPORT_SYMBOL(noop_llseek);
+EXPORT_SYMBOL_GPL(noop_llseek);
 
diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index d7259bb..24b267a 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -142,7 +142,7 @@ error_ops:
 	compat_genl_unregister_family(family);
 	return ret;
 }
-EXPORT_SYMBOL(compat_genl_register_family_with_ops);
+EXPORT_SYMBOL_GPL(compat_genl_register_family_with_ops);
 
 int compat_genl_unregister_family(struct genl_family *family)
 {
@@ -151,7 +151,7 @@ int compat_genl_unregister_family(struct genl_family *family)
 	list_del(&family->list);
 	return err;
 }
-EXPORT_SYMBOL(compat_genl_unregister_family);
+EXPORT_SYMBOL_GPL(compat_genl_unregister_family);
 
 #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 
@@ -304,7 +304,7 @@ void led_blink_set(struct led_classdev *led_cdev,
 
 	mod_timer(&led->blink_timer, jiffies + 1);
 }
-EXPORT_SYMBOL(led_blink_set);
+EXPORT_SYMBOL_GPL(led_blink_set);
 
 void compat_led_brightness_set(struct led_classdev *led_cdev,
 			       enum led_brightness brightness)
@@ -316,7 +316,7 @@ void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 	return led_cdev->brightness_set(led_cdev, brightness);
 }
-EXPORT_SYMBOL(compat_led_brightness_set);
+EXPORT_SYMBOL_GPL(compat_led_brightness_set);
 
 void compat_led_classdev_unregister(struct led_classdev *led_cdev)
 {
@@ -333,7 +333,7 @@ void compat_led_classdev_unregister(struct led_classdev *led_cdev)
 
 	led_classdev_unregister(led_cdev);
 }
-EXPORT_SYMBOL(compat_led_classdev_unregister);
+EXPORT_SYMBOL_GPL(compat_led_classdev_unregister);
 
 /**
  *	vzalloc - allocate virtually contiguous memory with zero fill
@@ -353,6 +353,6 @@ void *compat_vzalloc(unsigned long size)
 		memset(buf, 0, size);
 	return buf;
 }
-EXPORT_SYMBOL(compat_vzalloc);
+EXPORT_SYMBOL_GPL(compat_vzalloc);
 
 #endif
diff --git a/compat/compat-2.6.38.c b/compat/compat-2.6.38.c
index 172aa19..0074ac6 100644
--- a/compat/compat-2.6.38.c
+++ b/compat/compat-2.6.38.c
@@ -29,7 +29,7 @@ void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
 	avg->weight = weight;
 	avg->factor = factor;
 }
-EXPORT_SYMBOL(ewma_init);
+EXPORT_SYMBOL_GPL(ewma_init);
 
 /**
  * ewma_add() - Exponentially weighted moving average (EWMA)
@@ -46,5 +46,5 @@ struct ewma *ewma_add(struct ewma *avg, unsigned long val)
 		(val * avg->factor);
 	return avg;
 }
-EXPORT_SYMBOL(ewma_add);
+EXPORT_SYMBOL_GPL(ewma_add);
 
diff --git a/compat/compat-3.0.c b/compat/compat-3.0.c
index f517e9f..1da45ac 100644
--- a/compat/compat-3.0.c
+++ b/compat/compat-3.0.c
@@ -34,7 +34,7 @@ int mac_pton(const char *s, u8 *mac)
 	}
 	return 1;
 }
-EXPORT_SYMBOL(mac_pton);
+EXPORT_SYMBOL_GPL(mac_pton);
 
 #define kstrto_from_user(f, g, type)					\
 int f(const char __user *s, size_t count, unsigned int base, type *res)	\
@@ -48,7 +48,7 @@ int f(const char __user *s, size_t count, unsigned int base, type *res)	\
 	buf[count] = '\0';						\
 	return g(buf, base, res);					\
 }									\
-EXPORT_SYMBOL(f)
+EXPORT_SYMBOL_GPL(f)
 
 kstrto_from_user(kstrtoull_from_user,	kstrtoull,	unsigned long long);
 kstrto_from_user(kstrtoll_from_user,	kstrtoll,	long long);
diff --git a/compat/compat-3.2.c b/compat/compat-3.2.c
index 80f5597..55ae6af 100644
--- a/compat/compat-3.2.c
+++ b/compat/compat-3.2.c
@@ -31,4 +31,4 @@ int __netdev_printk(const char *level, const struct net_device *dev,
 
 	return r;
 }
-EXPORT_SYMBOL(__netdev_printk);
+EXPORT_SYMBOL_GPL(__netdev_printk);
diff --git a/compat/compat_atomic.c b/compat/compat_atomic.c
index 747e275..b8565aa 100644
--- a/compat/compat_atomic.c
+++ b/compat/compat_atomic.c
@@ -15,7 +15,7 @@ long long atomic64_read(const atomic64_t *v)
     spin_unlock_irqrestore(&lock, flags);
     return val;
 }
-EXPORT_SYMBOL(atomic64_read);
+EXPORT_SYMBOL_GPL(atomic64_read);
 
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
@@ -27,7 +27,7 @@ long long atomic64_add_return(long long a, atomic64_t *v)
     spin_unlock_irqrestore(&lock, flags);
     return val;
 }
-EXPORT_SYMBOL(atomic64_add_return);
+EXPORT_SYMBOL_GPL(atomic64_add_return);
 
 #endif
 
diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index eb97dfc..01eda40 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -754,6 +754,6 @@ static void __exit firmware_class_exit(void)
 fs_initcall(firmware_class_init);
 module_exit(firmware_class_exit);
 
-EXPORT_SYMBOL(release_firmware);
-EXPORT_SYMBOL(request_firmware);
-EXPORT_SYMBOL(request_firmware_nowait);
+EXPORT_SYMBOL_GPL(release_firmware);
+EXPORT_SYMBOL_GPL(request_firmware);
+EXPORT_SYMBOL_GPL(request_firmware_nowait);
diff --git a/compat/cordic.c b/compat/cordic.c
index aa27a88..a6340b6 100644
--- a/compat/cordic.c
+++ b/compat/cordic.c
@@ -94,7 +94,7 @@ struct cordic_iq cordic_calc_iq(s32 theta)
 	coord.q *= signx;
 	return coord;
 }
-EXPORT_SYMBOL(cordic_calc_iq);
+EXPORT_SYMBOL_GPL(cordic_calc_iq);
 
 MODULE_DESCRIPTION("Cordic functions");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/compat/crc8.c b/compat/crc8.c
index 87b59ca..fa8382d 100644
--- a/compat/crc8.c
+++ b/compat/crc8.c
@@ -40,7 +40,7 @@ void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
 			table[i+j] = table[j] ^ t;
 	}
 }
-EXPORT_SYMBOL(crc8_populate_msb);
+EXPORT_SYMBOL_GPL(crc8_populate_msb);
 
 /*
  * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
@@ -61,7 +61,7 @@ void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
 			table[i+j] = table[j] ^ t;
 	}
 }
-EXPORT_SYMBOL(crc8_populate_lsb);
+EXPORT_SYMBOL_GPL(crc8_populate_lsb);
 
 /*
  * crc8 - calculate a crc8 over the given input data.
@@ -79,7 +79,7 @@ u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc)
 
 	return crc;
 }
-EXPORT_SYMBOL(crc8);
+EXPORT_SYMBOL_GPL(crc8);
 
 MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/compat/kfifo.c b/compat/kfifo.c
index 01a0700..96e1bdf 100644
--- a/compat/kfifo.c
+++ b/compat/kfifo.c
@@ -65,7 +65,7 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 
 	return 0;
 }
-EXPORT_SYMBOL(__kfifo_alloc);
+EXPORT_SYMBOL_GPL(__kfifo_alloc);
 
 void __kfifo_free(struct __kfifo *fifo)
 {
@@ -76,7 +76,7 @@ void __kfifo_free(struct __kfifo *fifo)
 	fifo->data = NULL;
 	fifo->mask = 0;
 }
-EXPORT_SYMBOL(__kfifo_free);
+EXPORT_SYMBOL_GPL(__kfifo_free);
 
 int __kfifo_init(struct __kfifo *fifo, void *buffer,
 		unsigned int size, size_t esize)
@@ -99,7 +99,7 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
 
 	return 0;
 }
-EXPORT_SYMBOL(__kfifo_init);
+EXPORT_SYMBOL_GPL(__kfifo_init);
 
 static void kfifo_copy_in(struct __kfifo *fifo, const void *src,
 		unsigned int len, unsigned int off)
@@ -138,7 +138,7 @@ unsigned int __kfifo_in(struct __kfifo *fifo,
 	fifo->in += len;
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_in);
+EXPORT_SYMBOL_GPL(__kfifo_in);
 
 static void kfifo_copy_out(struct __kfifo *fifo, void *dst,
 		unsigned int len, unsigned int off)
@@ -176,7 +176,7 @@ unsigned int __kfifo_out_peek(struct __kfifo *fifo,
 	kfifo_copy_out(fifo, buf, len, fifo->out);
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_out_peek);
+EXPORT_SYMBOL_GPL(__kfifo_out_peek);
 
 unsigned int __kfifo_out(struct __kfifo *fifo,
 		void *buf, unsigned int len)
@@ -185,7 +185,7 @@ unsigned int __kfifo_out(struct __kfifo *fifo,
 	fifo->out += len;
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_out);
+EXPORT_SYMBOL_GPL(__kfifo_out);
 
 static unsigned long kfifo_copy_from_user(struct __kfifo *fifo,
 	const void __user *from, unsigned int len, unsigned int off,
@@ -246,7 +246,7 @@ int __kfifo_from_user(struct __kfifo *fifo, const void __user *from,
 	fifo->in += len;
 	return err;
 }
-EXPORT_SYMBOL(__kfifo_from_user);
+EXPORT_SYMBOL_GPL(__kfifo_from_user);
 
 static unsigned long kfifo_copy_to_user(struct __kfifo *fifo, void __user *to,
 		unsigned int len, unsigned int off, unsigned int *copied)
@@ -305,7 +305,7 @@ int __kfifo_to_user(struct __kfifo *fifo, void __user *to,
 	fifo->out += len;
 	return err;
 }
-EXPORT_SYMBOL(__kfifo_to_user);
+EXPORT_SYMBOL_GPL(__kfifo_to_user);
 
 static int setup_sgl_buf(struct scatterlist *sgl, void *buf,
 		int nents, unsigned int len)
@@ -379,7 +379,7 @@ unsigned int __kfifo_dma_in_prepare(struct __kfifo *fifo,
 
 	return setup_sgl(fifo, sgl, nents, len, fifo->in);
 }
-EXPORT_SYMBOL(__kfifo_dma_in_prepare);
+EXPORT_SYMBOL_GPL(__kfifo_dma_in_prepare);
 
 unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo,
 		struct scatterlist *sgl, int nents, unsigned int len)
@@ -392,7 +392,7 @@ unsigned int __kfifo_dma_out_prepare(struct __kfifo *fifo,
 
 	return setup_sgl(fifo, sgl, nents, len, fifo->out);
 }
-EXPORT_SYMBOL(__kfifo_dma_out_prepare);
+EXPORT_SYMBOL_GPL(__kfifo_dma_out_prepare);
 
 unsigned int __kfifo_max_r(unsigned int len, size_t recsize)
 {
@@ -447,7 +447,7 @@ unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize)
 {
 	return __kfifo_peek_n(fifo, recsize);
 }
-EXPORT_SYMBOL(__kfifo_len_r);
+EXPORT_SYMBOL_GPL(__kfifo_len_r);
 
 unsigned int __kfifo_in_r(struct __kfifo *fifo, const void *buf,
 		unsigned int len, size_t recsize)
@@ -461,7 +461,7 @@ unsigned int __kfifo_in_r(struct __kfifo *fifo, const void *buf,
 	fifo->in += len + recsize;
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_in_r);
+EXPORT_SYMBOL_GPL(__kfifo_in_r);
 
 static unsigned int kfifo_out_copy_r(struct __kfifo *fifo,
 	void *buf, unsigned int len, size_t recsize, unsigned int *n)
@@ -485,7 +485,7 @@ unsigned int __kfifo_out_peek_r(struct __kfifo *fifo, void *buf,
 
 	return kfifo_out_copy_r(fifo, buf, len, recsize, &n);
 }
-EXPORT_SYMBOL(__kfifo_out_peek_r);
+EXPORT_SYMBOL_GPL(__kfifo_out_peek_r);
 
 unsigned int __kfifo_out_r(struct __kfifo *fifo, void *buf,
 		unsigned int len, size_t recsize)
@@ -499,7 +499,7 @@ unsigned int __kfifo_out_r(struct __kfifo *fifo, void *buf,
 	fifo->out += n + recsize;
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_out_r);
+EXPORT_SYMBOL_GPL(__kfifo_out_r);
 
 void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize)
 {
@@ -508,7 +508,7 @@ void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize)
 	n = __kfifo_peek_n(fifo, recsize);
 	fifo->out += n + recsize;
 }
-EXPORT_SYMBOL(__kfifo_skip_r);
+EXPORT_SYMBOL_GPL(__kfifo_skip_r);
 
 int __kfifo_from_user_r(struct __kfifo *fifo, const void __user *from,
 	unsigned long len, unsigned int *copied, size_t recsize)
@@ -532,7 +532,7 @@ int __kfifo_from_user_r(struct __kfifo *fifo, const void __user *from,
 	fifo->in += len + recsize;
 	return 0;
 }
-EXPORT_SYMBOL(__kfifo_from_user_r);
+EXPORT_SYMBOL_GPL(__kfifo_from_user_r);
 
 int __kfifo_to_user_r(struct __kfifo *fifo, void __user *to,
 	unsigned long len, unsigned int *copied, size_t recsize)
@@ -557,7 +557,7 @@ int __kfifo_to_user_r(struct __kfifo *fifo, void __user *to,
 	fifo->out += n + recsize;
 	return 0;
 }
-EXPORT_SYMBOL(__kfifo_to_user_r);
+EXPORT_SYMBOL_GPL(__kfifo_to_user_r);
 
 unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
@@ -572,7 +572,7 @@ unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 
 	return setup_sgl(fifo, sgl, nents, len, fifo->in + recsize);
 }
-EXPORT_SYMBOL(__kfifo_dma_in_prepare_r);
+EXPORT_SYMBOL_GPL(__kfifo_dma_in_prepare_r);
 
 void __kfifo_dma_in_finish_r(struct __kfifo *fifo,
 	unsigned int len, size_t recsize)
@@ -581,7 +581,7 @@ void __kfifo_dma_in_finish_r(struct __kfifo *fifo,
 	__kfifo_poke_n(fifo, len, recsize);
 	fifo->in += len + recsize;
 }
-EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
+EXPORT_SYMBOL_GPL(__kfifo_dma_in_finish_r);
 
 unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
@@ -596,7 +596,7 @@ unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 
 	return setup_sgl(fifo, sgl, nents, len, fifo->out + recsize);
 }
-EXPORT_SYMBOL(__kfifo_dma_out_prepare_r);
+EXPORT_SYMBOL_GPL(__kfifo_dma_out_prepare_r);
 
 void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize)
 {
@@ -605,4 +605,4 @@ void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize)
 	len = __kfifo_peek_n(fifo, recsize);
 	fifo->out += len + recsize;
 }
-EXPORT_SYMBOL(__kfifo_dma_out_finish_r);
+EXPORT_SYMBOL_GPL(__kfifo_dma_out_finish_r);
diff --git a/compat/kstrtox.c b/compat/kstrtox.c
index 10aa91b..44859d1 100644
--- a/compat/kstrtox.c
+++ b/compat/kstrtox.c
@@ -86,7 +86,7 @@ int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 		s++;
 	return _kstrtoull(s, base, res);
 }
-EXPORT_SYMBOL(kstrtoull);
+EXPORT_SYMBOL_GPL(kstrtoull);
 
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
@@ -110,7 +110,7 @@ int kstrtoll(const char *s, unsigned int base, long long *res)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(kstrtoll);
+EXPORT_SYMBOL_GPL(kstrtoll);
 
 /* Internal, do not use. */
 int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
@@ -126,7 +126,7 @@ int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(_kstrtoul);
+EXPORT_SYMBOL_GPL(_kstrtoul);
 
 /* Internal, do not use. */
 int _kstrtol(const char *s, unsigned int base, long *res)
@@ -142,7 +142,7 @@ int _kstrtol(const char *s, unsigned int base, long *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(_kstrtol);
+EXPORT_SYMBOL_GPL(_kstrtol);
 
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 {
@@ -157,7 +157,7 @@ int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtouint);
+EXPORT_SYMBOL_GPL(kstrtouint);
 
 int kstrtoint(const char *s, unsigned int base, int *res)
 {
@@ -172,7 +172,7 @@ int kstrtoint(const char *s, unsigned int base, int *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtoint);
+EXPORT_SYMBOL_GPL(kstrtoint);
 
 int kstrtou16(const char *s, unsigned int base, u16 *res)
 {
@@ -187,7 +187,7 @@ int kstrtou16(const char *s, unsigned int base, u16 *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtou16);
+EXPORT_SYMBOL_GPL(kstrtou16);
 
 int kstrtos16(const char *s, unsigned int base, s16 *res)
 {
@@ -202,7 +202,7 @@ int kstrtos16(const char *s, unsigned int base, s16 *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtos16);
+EXPORT_SYMBOL_GPL(kstrtos16);
 
 int kstrtou8(const char *s, unsigned int base, u8 *res)
 {
@@ -217,7 +217,7 @@ int kstrtou8(const char *s, unsigned int base, u8 *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtou8);
+EXPORT_SYMBOL_GPL(kstrtou8);
 
 int kstrtos8(const char *s, unsigned int base, s8 *res)
 {
@@ -232,5 +232,5 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 	*res = tmp;
 	return 0;
 }
-EXPORT_SYMBOL(kstrtos8);
+EXPORT_SYMBOL_GPL(kstrtos8);
 #endif /* #ifndef strict_strtol */
-- 
1.7.4.15.g7811d

