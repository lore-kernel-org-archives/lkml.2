Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab1DJVab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:30:31 -0400
Received: from mail.perches.com ([173.55.12.10]:4618 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1DJVaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:30:18 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 3/4] treewide: Remove unnecessary semicolons when for (foo) {...};
Date: Sun, 10 Apr 2011 14:30:15 -0700
Message-Id: <5c01023b3810f32361699df83cf6966d52655b2d.1302470775.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470773.git.joe@perches.com>
References: <cover.1302470773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_for.pl
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
	$count += $text =~ s@\b(for\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
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
 arch/arm/mach-at91/gpio.c               |    2 +-
 arch/arm/mach-omap1/devices.c           |    2 +-
 arch/arm/plat-stmp3xxx/clock.c          |    2 +-
 arch/ia64/kvm/vtlb.c                    |    4 ++--
 arch/powerpc/boot/cuboot-c2k.c          |    2 +-
 arch/s390/mm/extmem.c                   |    2 +-
 arch/x86/kernel/alternative.c           |    4 ++--
 drivers/acpi/apei/erst.c                |    2 +-
 drivers/block/drbd/drbd_receiver.c      |    2 +-
 drivers/isdn/hisax/netjet.c             |    2 +-
 drivers/media/dvb/frontends/cx24110.c   |    2 +-
 drivers/media/video/cx88/cx88-mpeg.c    |    2 +-
 drivers/media/video/cx88/cx88-video.c   |    2 +-
 drivers/net/ixgbe/ixgbe_common.c        |    4 ++--
 drivers/net/myri10ge/myri10ge.c         |    2 +-
 drivers/net/ps3_gelic_net.c             |    2 +-
 drivers/net/slhc.c                      |    2 +-
 drivers/rtc/rtc-isl12022.c              |    2 +-
 drivers/rtc/rtc-pcf8563.c               |    2 +-
 drivers/s390/char/monreader.c           |    2 +-
 drivers/scsi/aha1542.c                  |    2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c        |    2 +-
 drivers/scsi/nsp32.c                    |    2 +-
 drivers/uwb/ie.c                        |    2 +-
 drivers/video/matrox/matroxfb_DAC1064.c |    4 ++--
 drivers/video/matrox/matroxfb_Ti3026.c  |    2 +-
 sound/isa/wavefront/wavefront_synth.c   |    2 +-
 sound/pci/mixart/mixart_hwdep.c         |    2 +-
 28 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index 4615528..a8e603e 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -432,7 +432,7 @@ static int at91_gpio_show(struct seq_file *s, void *unused)
 	seq_printf(s, "Pin\t");
 	for (bank = 0; bank < gpio_banks; bank++) {
 		seq_printf(s, "PIO%c\t", 'A' + bank);
-	};
+	}
 	seq_printf(s, "\n\n");
 
 	/* print pin status */
diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index b0f4c23..e12069a 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -157,7 +157,7 @@ void __init omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
 		size = OMAP1_MMC_SIZE;
 
 		omap_mmc_add("mmci-omap", i, base, size, irq, mmc_data[i]);
-	};
+	}
 }
 
 #endif
diff --git a/arch/arm/plat-stmp3xxx/clock.c b/arch/arm/plat-stmp3xxx/clock.c
index 2e712e1..c79fd77 100644
--- a/arch/arm/plat-stmp3xxx/clock.c
+++ b/arch/arm/plat-stmp3xxx/clock.c
@@ -332,7 +332,7 @@ static int cpu_set_rate(struct clk *clk, u32 rate)
 			}
 			if (s2 == 0)
 				break;
-		};
+		}
 		pr_debug("%s: clkctrl_cpu %d, clkctrl_frac %d\n", __func__,
 				clkctrl_cpu, clkctrl_frac);
 		if (c == 0x40) {
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4332f7e..3577f7b 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -489,7 +489,7 @@ void thash_purge_all(struct kvm_vcpu *v)
 		head->itir = 0;
 		head->next = 0;
 		head++;
-	};
+	}
 
 	head = vhpt->hash;
 	for (i = 0; i < vhpt->num; i++) {
@@ -498,7 +498,7 @@ void thash_purge_all(struct kvm_vcpu *v)
 		head->itir = 0;
 		head->next = 0;
 		head++;
-	};
+	}
 
 	local_flush_tlb_all();
 }
diff --git a/arch/powerpc/boot/cuboot-c2k.c b/arch/powerpc/boot/cuboot-c2k.c
index e435949..b60032b 100644
--- a/arch/powerpc/boot/cuboot-c2k.c
+++ b/arch/powerpc/boot/cuboot-c2k.c
@@ -116,7 +116,7 @@ static void c2k_bridge_setup(u32 mem_size)
 						cpu->pci<bus> mem0 */
 		out_le32((u32 *)(bridge_base + MV64x60_CPU_BAR_ENABLE),
 			enables);
-	};
+	}
 }
 
 static void c2k_fixups(void)
diff --git a/arch/s390/mm/extmem.c b/arch/s390/mm/extmem.c
index 075ddad..b2fd77c 100644
--- a/arch/s390/mm/extmem.c
+++ b/arch/s390/mm/extmem.c
@@ -159,7 +159,7 @@ dcss_mkname(char *name, char *dcss_name)
 		if (name[i] == '\0')
 			break;
 		dcss_name[i] = toupper(name[i]);
-	};
+	}
 	for (; i < 8; i++)
 		dcss_name[i] = ' ';
 	ASCEBC(dcss_name, 8);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..556bf55 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -250,7 +250,7 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 		/* turn DS segment override prefix into lock prefix */
 		if (*ptr == 0x3e)
 			text_poke(ptr, ((unsigned char []){0xf0}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
@@ -271,7 +271,7 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 		/* turn lock prefix into DS segment override prefix */
 		if (*ptr == 0xf0)
 			text_poke(ptr, ((unsigned char []){0x3E}), 1);
-	};
+	}
 	mutex_unlock(&text_mutex);
 }
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index d6cb0ff..7094323 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -704,7 +704,7 @@ static int __erst_read_from_storage(u64 record_id, u64 offset)
 			break;
 		if (erst_timedout(&timeout, SPIN_UNIT))
 			return -EIO;
-	};
+	}
 	rc = apei_exec_run(&ctx, ACPI_ERST_GET_COMMAND_STATUS);
 	if (rc)
 		return rc;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index fe1564c..ad3e533 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -537,7 +537,7 @@ static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
 			/* D_ASSERT(signal_pending(current)); */
 			break;
 		}
-	};
+	}
 
 	set_fs(oldfs);
 
diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
index 644891e..1f9c681 100644
--- a/drivers/isdn/hisax/netjet.c
+++ b/drivers/isdn/hisax/netjet.c
@@ -332,7 +332,7 @@ static int make_raw_data_56k(struct BCState *bcs) {
 			bitcnt = 0;
 		}
 		val >>= 1;
-	};
+	}
 	fcs = PPP_INITFCS;
 	for (i=0; i<bcs->tx_skb->len; i++) {
 		val = bcs->tx_skb->data[i];
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 7a1a5bc..20f781f 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -362,7 +362,7 @@ static int cx24110_initfe(struct dvb_frontend* fe)
 
 	for(i = 0; i < ARRAY_SIZE(cx24110_regdata); i++) {
 		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 9b500e6..e30fcba 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -448,7 +448,7 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 			cx88_core_irq(core,status);
 		if (status & PCI_INT_TSINT)
 			cx8802_mpeg_irq(dev);
-	};
+	}
 	if (MAX_IRQ_LOOP == loop) {
 		dprintk( 0, "clearing mask\n" );
 		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index b1f734d..406b317 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1679,7 +1679,7 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 			cx88_core_irq(core,status);
 		if (status & PCI_INT_VIDINT)
 			cx8800_vid_irq(dev);
-	};
+	}
 	if (10 == loop) {
 		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
 		       core->name);
diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
index bcd9529..3e3adca 100644
--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -927,7 +927,7 @@ static s32 ixgbe_ready_eeprom(struct ixgbe_hw *hw)
 
 		udelay(5);
 		ixgbe_standby_eeprom(hw);
-	};
+	}
 
 	/*
 	 * On some parts, SPI write time could vary from 0-20mSec on 3.3V
@@ -1009,7 +1009,7 @@ static void ixgbe_shift_out_eeprom_bits(struct ixgbe_hw *hw, u16 data,
 		 * EEPROM
 		 */
 		mask = mask >> 1;
-	};
+	}
 
 	/* We leave the "DI" bit set to "0" when we leave this routine. */
 	eec &= ~IXGBE_EEC_DI;
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 673dc60..dd35661 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -1013,7 +1013,7 @@ static int myri10ge_reset(struct myri10ge_priv *mgp)
 		cmd.data2 = i;
 		status |= myri10ge_send_cmd(mgp, MXGEFW_CMD_SET_INTRQ_DMA,
 					    &cmd, 0);
-	};
+	}
 
 	status |=
 	    myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_IRQ_ACK_OFFSET, &cmd, 0);
diff --git a/drivers/net/ps3_gelic_net.c b/drivers/net/ps3_gelic_net.c
index 5ecfa4b..cfea041 100644
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -1009,7 +1009,7 @@ static int gelic_card_decode_one_descr(struct gelic_card *card)
 				netdev = card->netdev[i];
 				break;
 			}
-		};
+		}
 		if (GELIC_PORT_MAX <= i) {
 			pr_info("%s: unknown packet vid=%x\n", __func__, vid);
 			goto refill;
diff --git a/drivers/net/slhc.c b/drivers/net/slhc.c
index ab9e3b7..0a0a664 100644
--- a/drivers/net/slhc.c
+++ b/drivers/net/slhc.c
@@ -297,7 +297,7 @@ slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
 		lcs = cs;
 		cs = cs->next;
 		comp->sls_o_searches++;
-	};
+	}
 	/*
 	 * Didn't find it -- re-use oldest cstate.  Send an
 	 * uncompressed packet that tells the other side what
diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index ddbc797..1d844fa 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -226,7 +226,7 @@ static int isl12022_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 					 buf[ISL12022_REG_SC + i]);
 		if (ret)
 			return -EIO;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index b42c0c6..9519fd3 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -167,7 +167,7 @@ static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 				__func__, err, data[0], data[1]);
 			return -EIO;
 		}
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index 5b8b859..65e8203 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -95,7 +95,7 @@ static void dcss_mkname(char *ascii_name, char *ebcdic_name)
 		if (ascii_name[i] == '\0')
 			break;
 		ebcdic_name[i] = toupper(ascii_name[i]);
-	};
+	}
 	for (; i < 8; i++)
 		ebcdic_name[i] = ' ';
 	ASCEBC(ebcdic_name, 8);
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 3aea61d..fce00ca 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -735,7 +735,7 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
 		any2scsi(mb[i].ccbptr, SCSI_BUF_PA(&ccb[i]));
-	};
+	}
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
 	any2scsi((cmd + 2), SCSI_BUF_PA(mb));
 	aha1542_out(bse, cmd, 5);
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2256bab..879c23a 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -275,7 +275,7 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 					return -EIO;
 				}
 			}
-		};
+		}
 
 		rest -= mlen;
 	}
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index a2f54bc..ad3b42f 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1883,7 +1883,7 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 
 		nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR, "bus: 0x%x\n",
 			  nsp32_read1(base, SCSI_BUS_MONITOR));
-	};
+	}
 
 	data->msgout_len = 0;
 
diff --git a/drivers/uwb/ie.c b/drivers/uwb/ie.c
index 30acec7..e9bf6a0 100644
--- a/drivers/uwb/ie.c
+++ b/drivers/uwb/ie.c
@@ -90,7 +90,7 @@ int uwb_ie_dump_hex(const struct uwb_ie_hdr *ies, size_t len,
 			r += scnprintf(buf + r, size - r, " %02x", (unsigned)*d++);
 		if (r < size)
 			buf[r++] = '\n';
-	};
+	}
 
 	return r;
 }
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index 1717623..a01147f 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -494,7 +494,7 @@ static int m1064_compute(void* out, struct my_timming* m) {
 			if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 				break;
 			udelay(10);
-		};
+		}
 
 		CRITEND
 
@@ -639,7 +639,7 @@ static void MGAG100_progPixClock(const struct matrox_fb_info *minfo, int flags,
 		if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 			break;
 		udelay(10);
-	};
+	}
 	if (!clk)
 		printk(KERN_ERR "matroxfb: Pixel PLL%c not locked after usual time\n", (reg-M1064_XPIXPLLAM-2)/4 + 'A');
 	selClk = inDAC1064(minfo, M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_SRC_MASK;
diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/matrox/matroxfb_Ti3026.c
index 835aaaa..427d6c2 100644
--- a/drivers/video/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/matrox/matroxfb_Ti3026.c
@@ -473,7 +473,7 @@ static void ti3026_setMCLK(struct matrox_fb_info *minfo, int fout)
 		if (inTi3026(minfo, TVP3026_XPIXPLLDATA) & 0x40)
 			break;
 		udelay(10);
-	};
+	}
 	if (!tmout)
 		printk(KERN_ERR "matroxfb: Temporary pixel PLL not locked after 5 secs\n");
 
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index 4fb7b19..c91e493 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -537,7 +537,7 @@ munge_int32 (unsigned int src,
 	                            /* Note: we leave the upper bits in place */ 
 
 		dst++;
- 	};
+	}
 	return dst;
 };
 
diff --git a/sound/pci/mixart/mixart_hwdep.c b/sound/pci/mixart/mixart_hwdep.c
index bf2696a..58400e9 100644
--- a/sound/pci/mixart/mixart_hwdep.c
+++ b/sound/pci/mixart/mixart_hwdep.c
@@ -537,7 +537,7 @@ static int mixart_dsp_load(struct mixart_mgr* mgr, int index, const struct firmw
 
 		if ((err = snd_card_register(chip->card)) < 0)
 			return err;
-	};
+	}
 
 	snd_printdd("miXart firmware downloaded and successfully set up\n");
 
-- 
1.7.4.2.g597a6.dirty

