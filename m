Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1DJVag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:30:36 -0400
Received: from mail.perches.com ([173.55.12.10]:4615 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab1DJVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:30:17 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 2/4] treewide: Remove unnecessary semicolons when while (foo) {...};
Date: Sun, 10 Apr 2011 14:30:14 -0700
Message-Id: <47e04ea8fd2c6a3402f9f843c94c385c37972c8f.1302470775.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470773.git.joe@perches.com>
References: <cover.1302470773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_while.pl
my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
my $match_balanced_braces      = qr/(\{(?:[^\{\}]++|(?-1))*\})/;

foreach my $file (@ARGV) {
    my $f;
    my $text;
    my $oldtext;

    next if ((-d $file));

    open($f, '<', $file)
	or die "$P: Can't open $file for read\n";
    $oldtext = do { local($/) ; <$f> };
    close($f);

    next if ($oldtext eq "");

    $text = $oldtext;

    my $count = 0;
    do {
	$count = 0;
	$count += $text =~ s@\b(while\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
    } while ($count > 0);

    if ($text ne $oldtext) {
	my $newfile = $file;

	open($f, '>', $newfile)
	    or die "$P: Can't open $newfile for write\n";
	print $f $text;
	close($f);
    }
}

$

One false positive removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c |    2 +-
 arch/arm/plat-mxc/ulpi.c                 |    2 +-
 arch/x86/pci/mmconfig-shared.c           |    2 +-
 block/blk-core.c                         |    2 +-
 drivers/acpi/acpica/nsalloc.c            |    2 +-
 drivers/char/nwbutton.c                  |    2 +-
 drivers/ide/ide-taskfile.c               |    2 +-
 drivers/input/serio/serio_raw.c          |    2 +-
 drivers/media/dvb/b2c2/flexcop-sram.c    |    6 +++---
 drivers/media/dvb/frontends/si21xx.c     |    2 +-
 drivers/media/dvb/frontends/stv0299.c    |    4 ++--
 drivers/media/dvb/frontends/tda8083.c    |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c           |    2 +-
 drivers/net/netxen/netxen_nic_init.c     |    2 +-
 drivers/net/tokenring/3c359.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/fw.c   |    2 +-
 drivers/net/wireless/orinoco/main.c      |    2 +-
 drivers/net/znet.c                       |    2 +-
 drivers/s390/net/qeth_core_main.c        |    2 +-
 drivers/scsi/aha1542.c                   |    2 +-
 drivers/scsi/scsi_tgt_if.c               |    2 +-
 drivers/scsi/sgiwd93.c                   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_fw.c        |    2 +-
 drivers/tty/serial/ucc_uart.c            |    2 +-
 drivers/usb/misc/rio500.c                |    2 +-
 drivers/usb/otg/ulpi_viewport.c          |    2 +-
 drivers/uwb/i1480/dfu/mac.c              |    2 +-
 drivers/video/sis/sis_accel.h            |   14 +++++++-------
 fs/ntfs/super.c                          |    4 ++--
 kernel/trace/ftrace.c                    |    2 +-
 lib/decompress_bunzip2.c                 |    2 +-
 net/bluetooth/hci_core.c                 |    4 ++--
 tools/perf/builtin-lock.c                |    2 +-
 tools/perf/util/trace-event-read.c       |    2 +-
 34 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index f6ac9ba..11913c9 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -192,7 +192,7 @@ static int evm_led_setup(struct i2c_client *client, int gpio,
 	while (ngpio--) {
 		leds->gpio = gpio++;
 		leds++;
-	};
+	}
 
 	evm_led_dev = platform_device_alloc("leds-gpio", 0);
 	platform_device_add_data(evm_led_dev, &evm_led_data,
diff --git a/arch/arm/plat-mxc/ulpi.c b/arch/arm/plat-mxc/ulpi.c
index 477e45b..b55196a 100644
--- a/arch/arm/plat-mxc/ulpi.c
+++ b/arch/arm/plat-mxc/ulpi.c
@@ -51,7 +51,7 @@ static int ulpi_poll(void __iomem *view, u32 bit)
 			return 0;
 
 		cpu_relax();
-	};
+	}
 
 	printk(KERN_WARNING "timeout polling for ULPI device\n");
 
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index e282886..5cd89de 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -553,7 +553,7 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
 	while (i >= sizeof(struct acpi_mcfg_allocation)) {
 		entries++;
 		i -= sizeof(struct acpi_mcfg_allocation);
-	};
+	}
 	if (entries == 0) {
 		printk(KERN_ERR PREFIX "MMCONFIG has no entries\n");
 		return -ENODEV;
diff --git a/block/blk-core.c b/block/blk-core.c
index 725091d..1627fa6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -836,7 +836,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		finish_wait(&rl->wait[is_sync], &wait);
 
 		rq = get_request(q, rw_flags, bio, GFP_NOIO);
-	};
+	}
 
 	return rq;
 }
diff --git a/drivers/acpi/acpica/nsalloc.c b/drivers/acpi/acpica/nsalloc.c
index 1d0ef15..6f56f1d 100644
--- a/drivers/acpi/acpica/nsalloc.c
+++ b/drivers/acpi/acpica/nsalloc.c
@@ -316,7 +316,7 @@ void acpi_ns_delete_children(struct acpi_namespace_node *parent_node)
 		node_to_delete = next_node;
 		next_node = next_node->peer;
 		acpi_ns_delete_node(node_to_delete);
-	};
+	}
 
 	/* Clear the parent's child pointer */
 
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 1ce5b52..0de519b 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -95,7 +95,7 @@ int button_del_callback (void (*callback) (void))
 			return 0;
 		}
 		lp--;
-	};
+	}
 	return -EINVAL;
 }
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 34b9872..3578cd7 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -160,7 +160,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 		if ((stat & ATA_BUSY) == 0 || retries-- == 0)
 			break;
 		udelay(10);
-	};
+	}
 
 	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
 		if (custom && tf->command == ATA_CMD_SET_MULTI) {
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index b7ba459..4047de8 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -215,7 +215,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer, siz
 			goto out;
 		}
 		written++;
-	};
+	}
 
 out:
 	mutex_unlock(&serio_raw_mutex);
diff --git a/drivers/media/dvb/b2c2/flexcop-sram.c b/drivers/media/dvb/b2c2/flexcop-sram.c
index f2199e4..185c285 100644
--- a/drivers/media/dvb/b2c2/flexcop-sram.c
+++ b/drivers/media/dvb/b2c2/flexcop-sram.c
@@ -85,7 +85,7 @@ static void flexcop_sram_write(struct adapter *adapter, u32 bank, u32 addr, u8 *
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
@@ -110,7 +110,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
@@ -122,7 +122,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index 4b0c99a..9d943dc 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -343,7 +343,7 @@ static int si21xx_wait_diseqc_idle(struct si21xx_state *state, int timeout)
 			return -ETIMEDOUT;
 		}
 		msleep(10);
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 4e3db3a..a971613 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -198,7 +198,7 @@ static int stv0299_wait_diseqc_fifo (struct stv0299_state* state, int timeout)
 			return -ETIMEDOUT;
 		}
 		msleep(10);
-	};
+	}
 
 	return 0;
 }
@@ -215,7 +215,7 @@ static int stv0299_wait_diseqc_idle (struct stv0299_state* state, int timeout)
 			return -ETIMEDOUT;
 		}
 		msleep(10);
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 9369f74..6fe89a3 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -175,7 +175,7 @@ static void tda8083_wait_diseqc_fifo (struct tda8083_state* state, int timeout)
 	       !(tda8083_readreg(state, 0x02) & 0x80))
 	{
 		msleep(50);
-	};
+	}
 }
 
 static int tda8083_set_tone (struct tda8083_state* state, fe_sec_tone_mode_t tone)
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 0b81b5b..41a3d008 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -454,7 +454,7 @@ static void mpc5121_nfc_copy_spare(struct mtd_info *mtd, uint offset,
 		buffer += blksize;
 		offset += blksize;
 		size -= blksize;
-	};
+	}
 }
 
 /* Copy data from/to NFC main and spare buffers */
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 7f99967..ca59b4f 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -1279,7 +1279,7 @@ void netxen_free_dummy_dma(struct netxen_adapter *adapter)
 
 			if (--i == 0)
 				break;
-		};
+		}
 	}
 
 	if (i) {
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 77b8ad2..cde55dc 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -1773,7 +1773,7 @@ static void xl_wait_misr_flags(struct net_device *dev)
 	if (readb(xl_mmio + MMIO_MACDATA) != 0) {  /* Misr not clear */
 		for (i=0; i<6; i++) { 
 			writel(MEM_BYTE_READ | 0xDFFE0 | i, xl_mmio + MMIO_MAC_ACCESS_CMD) ; 
-			while (readb(xl_mmio + MMIO_MACDATA) != 0 ) {} ; /* Empty Loop */
+			while (readb(xl_mmio + MMIO_MACDATA) != 0 ) {} /* Empty Loop */
 		} 
 	}
 
diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index 4906709..6f1afe6 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -187,7 +187,7 @@ static int iwm_load_img(struct iwm_priv *iwm, const char *img_name)
 		if (ret < 0)
 			goto err_release_fw;
 		opcode_idx++;
-	};
+	}
 
 	/* Read firmware version */
 	fw_offset = iwm_fw_op_offset(iwm, fw, IWM_HDR_REC_OP_SW_VER, 0);
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 62c6b2b..b0f233f 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1958,7 +1958,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 
 		evstat = hermes_read_regn(hw, EVSTAT);
 		events = evstat & hw->inten;
-	};
+	}
 
 	orinoco_unlock(priv, &flags);
 	return IRQ_HANDLED;
diff --git a/drivers/net/znet.c b/drivers/net/znet.c
index ae07b3d..cfe1e4f 100644
--- a/drivers/net/znet.c
+++ b/drivers/net/znet.c
@@ -731,7 +731,7 @@ static void znet_rx(struct net_device *dev)
 		cur_frame_end_offset -= ((count + 1)>>1) + 3;
 		if (cur_frame_end_offset < 0)
 		  cur_frame_end_offset += RX_BUF_SIZE/2;
-	};
+	}
 
 	/* Now step  forward through the list. */
 	do {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d242d6c..30d71b6 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1734,7 +1734,7 @@ int qeth_send_control_data(struct qeth_card *card, int len,
 			if (time_after(jiffies, timeout))
 				goto time_err;
 			cpu_relax();
-		};
+		}
 	}
 
 	if (reply->rc == -EIO)
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index b8e915b..3aea61d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -555,7 +555,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 							   far as queuecommand is concerned */
 		my_done(SCtmp);
 		number_serviced++;
-	};
+	}
 }
 
 static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 0172de1..7d932c7 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -252,7 +252,7 @@ static ssize_t tgt_write(struct file *file, const char __user * buffer,
 		tgt_ring_idx_inc(ring);
 		event_recv_msg(ev);
 		ev->hdr.status = 0;
-	};
+	}
 
 	return count;
 }
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 3a9d85c..212e20e 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -187,7 +187,7 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
 		hcp++;
 		dma += sizeof(struct hpc_chunk);
 		start += sizeof(struct hpc_chunk);
-	};
+	}
 	hcp--;
 	hcp->desc.pnext = hdata->dma;
 }
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 55100c9..37e8eac 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -550,5 +550,5 @@ void sym_fw_bind_script(struct sym_hcb *np, u32 *start, int len)
 
 			*cur++ = cpu_to_scr(new);
 		}
-	};
+	}
 }
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index c327218..467a7d4 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -267,7 +267,7 @@ static unsigned int qe_uart_tx_empty(struct uart_port *port)
 			return 1;
 
 		bdp++;
-	};
+	}
 }
 
 /*
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 4e23d38..7e686ba 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -330,7 +330,7 @@ write_rio(struct file *file, const char __user *buffer,
 				thistime -= partial;
 			} else
 				break;
-		};
+		}
 		if (result) {
 			err("Write Whoops - %x", result);
 			errn = -EIO;
diff --git a/drivers/usb/otg/ulpi_viewport.c b/drivers/usb/otg/ulpi_viewport.c
index e9a37f9..2fcc91d 100644
--- a/drivers/usb/otg/ulpi_viewport.c
+++ b/drivers/usb/otg/ulpi_viewport.c
@@ -35,7 +35,7 @@ static int ulpi_viewport_wait(void __iomem *view, u32 mask)
 			return 0;
 
 		udelay(1);
-	};
+	}
 
 	return -ETIMEDOUT;
 }
diff --git a/drivers/uwb/i1480/dfu/mac.c b/drivers/uwb/i1480/dfu/mac.c
index 6ec14f5..e347981f4 100644
--- a/drivers/uwb/i1480/dfu/mac.c
+++ b/drivers/uwb/i1480/dfu/mac.c
@@ -138,7 +138,7 @@ int fw_hdrs_load(struct i1480 *i1480, struct fw_hdr **phdr,
 		*prev_hdr = hdr;
 		prev_hdr = &hdr->next;
 		hdr_cnt++;
-	};
+	}
 	*prev_hdr = NULL;
 	return 0;
 
diff --git a/drivers/video/sis/sis_accel.h b/drivers/video/sis/sis_accel.h
index 30e03cd..d11d01c 100644
--- a/drivers/video/sis/sis_accel.h
+++ b/drivers/video/sis/sis_accel.h
@@ -153,9 +153,9 @@
 
 #define SiS300Idle \
   { \
-  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){}; \
-  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){}; \
-  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){}; \
+  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){} \
+  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){} \
+  	while((MMIO_IN16(ivideo->mmio_vbase, BR(16)+2) & 0xE000) != 0xE000){} \
   	CmdQueLen = MMIO_IN16(ivideo->mmio_vbase, 0x8240); \
   }
 /* (do three times, because 2D engine seems quite unsure about whether or not it's idle) */
@@ -283,10 +283,10 @@
 
 #define SiS310Idle \
   { \
-  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){}; \
-  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){}; \
-	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){}; \
-  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){}; \
+  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){} \
+  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){} \
+	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){} \
+  	while( (MMIO_IN16(ivideo->mmio_vbase, Q_STATUS+2) & 0x8000) != 0x8000){} \
   	CmdQueLen = 0; \
   }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 29099a0..75c564c 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1600,7 +1600,7 @@ read_partial_attrdef_page:
 		memcpy((u8*)vol->attrdef + (index++ << PAGE_CACHE_SHIFT),
 				page_address(page), size);
 		ntfs_unmap_page(page);
-	};
+	}
 	if (size == PAGE_CACHE_SIZE) {
 		size = i_size & ~PAGE_CACHE_MASK;
 		if (size)
@@ -1669,7 +1669,7 @@ read_partial_upcase_page:
 		memcpy((char*)vol->upcase + (index++ << PAGE_CACHE_SHIFT),
 				page_address(page), size);
 		ntfs_unmap_page(page);
-	};
+	}
 	if (size == PAGE_CACHE_SIZE) {
 		size = i_size & ~PAGE_CACHE_MASK;
 		if (size)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c075f4e..e8e80b7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -102,7 +102,7 @@ static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 	while (op != &ftrace_list_end) {
 		op->func(ip, parent_ip);
 		op = rcu_dereference_raw(op->next); /*see above*/
-	};
+	}
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a7b80c1..cd6c7ce 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -385,7 +385,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 			bd->inbufBits =
 				(bd->inbufBits << 8)|bd->inbuf[bd->inbufPos++];
 			bd->inbufBitCount += 8;
-		};
+		}
 		bd->inbufBitCount -= hufGroup->maxLen;
 		j = (bd->inbufBits >> bd->inbufBitCount)&
 			((1 << hufGroup->maxLen)-1);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a80bc1c..4f18d1e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1463,7 +1463,7 @@ int hci_recv_fragment(struct hci_dev *hdev, int type, void *data, int count)
 
 		data += (count - rem);
 		count = rem;
-	};
+	}
 
 	return rem;
 }
@@ -1498,7 +1498,7 @@ int hci_recv_stream_fragment(struct hci_dev *hdev, void *data, int count)
 
 		data += (count - rem);
 		count = rem;
-	};
+	}
 
 	return rem;
 }
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..da099ae 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -819,7 +819,7 @@ static void dump_threads(void)
 		t = perf_session__findnew(session, st->tid);
 		pr_info("%10d: %s\n", st->tid, t->comm);
 		node = rb_next(node);
-	};
+	}
 }
 
 static void dump_map(void)
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f55cc3a..3949e31 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -102,7 +102,7 @@ static void skip(int size)
 		r = size > BUFSIZ ? BUFSIZ : size;
 		read_or_die(buf, r);
 		size -= r;
-	};
+	}
 }
 
 static unsigned int read4(void)
-- 
1.7.4.2.g597a6.dirty

