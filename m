Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1DJVah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:30:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4614 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab1DJVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:30:17 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 1/4] treewide: Remove unnecessary semicolons when if (foo) {...};
Date: Sun, 10 Apr 2011 14:30:13 -0700
Message-Id: <0747b433cc70d66f39c68085a2f8518ee1186bb4.1302470774.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470773.git.joe@perches.com>
References: <cover.1302470773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_if.pl
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
	$count += $text =~ s@\b(if\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
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
 arch/arm/mach-omap2/clkt_clksel.c                  |    2 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |    8 ++++----
 arch/powerpc/kernel/prom_init.c                    |    2 +-
 arch/powerpc/kvm/booke.h                           |    2 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    2 +-
 arch/powerpc/sysdev/tsi108_dev.c                   |    2 +-
 arch/sparc/kernel/pci_sun4v.c                      |    2 +-
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c          |    2 +-
 drivers/char/nwbutton.c                            |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |    2 +-
 drivers/gpu/drm/i915/dvo_sil164.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |    2 +-
 drivers/hwmon/adm1026.c                            |    6 +++---
 drivers/hwmon/asc7621.c                            |   12 ++++++------
 drivers/isdn/hisax/q931.c                          |    2 +-
 drivers/isdn/i4l/isdn_net.c                        |    2 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   10 +++++-----
 drivers/media/dvb/frontends/drxd_hard.c            |    2 +-
 drivers/media/dvb/frontends/stv0900_core.c         |    2 +-
 drivers/media/video/cx23885/altera-ci.c            |    4 ++--
 drivers/media/video/cx23885/cimax2.c               |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    2 +-
 drivers/message/i2o/iop.c                          |    2 +-
 drivers/mtd/maps/bcm963xx-flash.c                  |   10 +++++-----
 drivers/mtd/ubi/cdev.c                             |    2 +-
 drivers/net/amd8111e.c                             |    2 +-
 drivers/net/cxgb4/cxgb4_main.c                     |    2 +-
 drivers/net/tokenring/3c359.c                      |    2 +-
 drivers/net/via-velocity.c                         |    2 +-
 drivers/s390/net/qeth_core_main.c                  |    2 +-
 drivers/scsi/aha1542.c                             |   14 +++++++-------
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                   |    2 +-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/sym53c8xx_2/sym_fw.c                  |    2 +-
 drivers/scsi/ultrastor.c                           |    2 +-
 drivers/usb/host/uhci-hcd.c                        |    2 +-
 drivers/video/cfbimgblt.c                          |    2 +-
 drivers/video/sysimgblt.c                          |    2 +-
 fs/befs/btree.c                                    |    2 +-
 fs/ext4/super.c                                    |    2 +-
 fs/jffs2/wbuf.c                                    |    2 +-
 fs/ntfs/lcnalloc.c                                 |    2 +-
 fs/partitions/msdos.c                              |    2 +-
 fs/reiserfs/bitmap.c                               |    2 +-
 net/sunrpc/auth.c                                  |    2 +-
 sound/oss/sb_ess.c                                 |   12 ++++++------
 sound/oss/sb_mixer.c                               |    4 ++--
 sound/oss/uart6850.c                               |    2 +-
 sound/pci/au88x0/au88x0_game.c                     |    2 +-
 51 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt_clksel.c b/arch/arm/mach-omap2/clkt_clksel.c
index e25364d..292ae26 100644
--- a/arch/arm/mach-omap2/clkt_clksel.c
+++ b/arch/arm/mach-omap2/clkt_clksel.c
@@ -364,7 +364,7 @@ void omap2_init_clksel_parent(struct clk *clk)
 						 ((clk->parent) ?
 						  clk->parent->name : "NULL"));
 					clk_reparent(clk, clks->parent);
-				};
+				}
 				found = 1;
 			}
 		}
diff --git a/arch/arm/plat-omap/omap-pm-noop.c b/arch/arm/plat-omap/omap-pm-noop.c
index b0471bb2..dea3105 100644
--- a/arch/arm/plat-omap/omap-pm-noop.c
+++ b/arch/arm/plat-omap/omap-pm-noop.c
@@ -38,7 +38,7 @@ int omap_pm_set_max_mpu_wakeup_lat(struct device *dev, long t)
 	if (!dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max MPU wakeup latency constraint: "
@@ -67,7 +67,7 @@ int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r)
 	    agent_id != OCP_TARGET_AGENT)) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (r == 0)
 		pr_debug("OMAP PM: remove min bus tput constraint: "
@@ -94,7 +94,7 @@ int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
 	if (!req_dev || !dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max device latency constraint: "
@@ -124,7 +124,7 @@ int omap_pm_set_max_sdma_lat(struct device *dev, long t)
 	if (!dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max DMA latency constraint: "
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 941ff4d..acef596 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2331,7 +2331,7 @@ static void __init fixup_device_tree_efika_add_phy(void)
 				" 0x3 encode-int encode+"
 				" s\" interrupts\" property"
 			" finish-device");
-	};
+	}
 
 	/* Check for a PHY device node - if missing then create one and
 	 * give it's phandle to the ethernet node */
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 492bb70..380a331 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -64,7 +64,7 @@ static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
 	if (vcpu->arch.shared->msr & MSR_WE) {
 		kvm_vcpu_block(vcpu);
 		kvmppc_set_exit_type(vcpu, EMULATED_MTMSRWE_EXITS);
-	};
+	}
 }
 
 int kvmppc_booke_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 018cc67..240b9a8 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -118,7 +118,7 @@ static u32 get_busfreq(void)
 		if (prop)
 			fs_busfreq = *prop;
 		of_node_put(node);
-	};
+	}
 	return fs_busfreq;
 }
 
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index ee05680..181aef1 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -52,7 +52,7 @@ phys_addr_t get_csrbase(void)
 		const void *prop = of_get_property(tsi, "reg", &size);
 		tsi108_csr_base = of_translate_address(tsi, prop);
 		of_node_put(tsi);
-	};
+	}
 	return tsi108_csr_base;
 }
 
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index b01a06e..9cb06b2 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -592,7 +592,7 @@ static int __devinit pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
 		printk(KERN_ERR PFX "Strange virtual-dma[%08x:%08x].\n",
 		       vdma[0], vdma[1]);
 		return -EINVAL;
-	};
+	}
 
 	dma_mask = (roundup_pow_of_two(vdma[1]) - 1UL);
 	num_tsb_entries = vdma[1] / IO_PAGE_SIZE;
diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
index 755a31e..17a7038 100644
--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -272,7 +272,7 @@ static int pcc_get_offset(int cpu)
 	if (!pccp || pccp->type != ACPI_TYPE_PACKAGE) {
 		ret = -ENODEV;
 		goto out_free;
-	};
+	}
 
 	offset = &(pccp->package.elements[0]);
 	if (!offset || offset->type != ACPI_TYPE_INTEGER) {
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 8994ce3..1ce5b52 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -93,7 +93,7 @@ int button_del_callback (void (*callback) (void))
 			button_callback_list [lp].count = 0;
 			callback_count--;
 			return 0;
-		};
+		}
 		lp--;
 	};
 	return -EINVAL;
diff --git a/drivers/gpu/drm/i915/dvo_ch7xxx.c b/drivers/gpu/drm/i915/dvo_ch7xxx.c
index 7eaa94e..f8c25bf 100644
--- a/drivers/gpu/drm/i915/dvo_ch7xxx.c
+++ b/drivers/gpu/drm/i915/dvo_ch7xxx.c
@@ -137,7 +137,7 @@ static bool ch7xxx_readb(struct intel_dvo_device *dvo, int addr, uint8_t *ch)
 	if (i2c_transfer(adapter, msgs, 2) == 2) {
 		*ch = in_buf[0];
 		return true;
-	};
+	}
 
 	if (!ch7xxx->quiet) {
 		DRM_DEBUG_KMS("Unable to read register 0x%02x from %s:%02x.\n",
diff --git a/drivers/gpu/drm/i915/dvo_ivch.c b/drivers/gpu/drm/i915/dvo_ivch.c
index a12ed94..7fba3b1 100644
--- a/drivers/gpu/drm/i915/dvo_ivch.c
+++ b/drivers/gpu/drm/i915/dvo_ivch.c
@@ -195,7 +195,7 @@ static bool ivch_read(struct intel_dvo_device *dvo, int addr, uint16_t *data)
 	if (i2c_transfer(adapter, msgs, 3) == 3) {
 		*data = (in_buf[1] << 8) | in_buf[0];
 		return true;
-	};
+	}
 
 	if (!priv->quiet) {
 		DRM_DEBUG_KMS("Unable to read register 0x%02x from "
diff --git a/drivers/gpu/drm/i915/dvo_sil164.c b/drivers/gpu/drm/i915/dvo_sil164.c
index e4b4091..ed13ee1 100644
--- a/drivers/gpu/drm/i915/dvo_sil164.c
+++ b/drivers/gpu/drm/i915/dvo_sil164.c
@@ -93,7 +93,7 @@ static bool sil164_readb(struct intel_dvo_device *dvo, int addr, uint8_t *ch)
 	if (i2c_transfer(adapter, msgs, 2) == 2) {
 		*ch = in_buf[0];
 		return true;
-	};
+	}
 
 	if (!sil->quiet) {
 		DRM_DEBUG_KMS("Unable to read register 0x%02x from %s:%02x.\n",
diff --git a/drivers/gpu/drm/i915/dvo_tfp410.c b/drivers/gpu/drm/i915/dvo_tfp410.c
index 8ab2855..aec7d8c 100644
--- a/drivers/gpu/drm/i915/dvo_tfp410.c
+++ b/drivers/gpu/drm/i915/dvo_tfp410.c
@@ -118,7 +118,7 @@ static bool tfp410_readb(struct intel_dvo_device *dvo, int addr, uint8_t *ch)
 	if (i2c_transfer(adapter, msgs, 2) == 2) {
 		*ch = in_buf[0];
 		return true;
-	};
+	}
 
 	if (!tfp->quiet) {
 		DRM_DEBUG_KMS("Unable to read register 0x%02x from %s:%02x.\n",
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index be0fdd5..47755f8 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -608,7 +608,7 @@ static struct adm1026_data *adm1026_update_device(struct device *dev)
 		data->gpio = gpio;
 
 		data->last_reading = jiffies;
-	}; /* last_reading */
+	} /* last_reading */
 
 	if (!data->valid ||
 	    time_after(jiffies, data->last_config + ADM1026_CONFIG_INTERVAL)) {
@@ -691,7 +691,7 @@ static struct adm1026_data *adm1026_update_device(struct device *dev)
 		}
 
 		data->last_config = jiffies;
-	}; /* last_config */
+	} /* last_config */
 
 	data->valid = 1;
 	mutex_unlock(&data->update_lock);
@@ -1657,7 +1657,7 @@ static int adm1026_detect(struct i2c_client *client,
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		/* We need to be able to do byte I/O */
 		return -ENODEV;
-	};
+	}
 
 	/* Now, we do the remaining detection. */
 
diff --git a/drivers/hwmon/asc7621.c b/drivers/hwmon/asc7621.c
index d2596ce..eb1f12b 100644
--- a/drivers/hwmon/asc7621.c
+++ b/drivers/hwmon/asc7621.c
@@ -138,7 +138,7 @@ static inline u8 read_byte(struct i2c_client *client, u8 reg)
 		dev_err(&client->dev,
 			"Unable to read from register 0x%02x.\n", reg);
 		return 0;
-	};
+	}
 	return res & 0xff;
 }
 
@@ -149,7 +149,7 @@ static inline int write_byte(struct i2c_client *client, u8 reg, u8 data)
 		dev_err(&client->dev,
 			"Unable to write value 0x%02x to register 0x%02x.\n",
 			data, reg);
-	};
+	}
 	return res;
 }
 
@@ -1028,7 +1028,7 @@ static struct asc7621_data *asc7621_update_device(struct device *dev)
 			}
 		}
 		data->last_high_reading = jiffies;
-	};			/* last_reading */
+	}			/* last_reading */
 
 	/* Read all the low priority registers. */
 
@@ -1042,7 +1042,7 @@ static struct asc7621_data *asc7621_update_device(struct device *dev)
 			}
 		}
 		data->last_low_reading = jiffies;
-	};			/* last_reading */
+	}			/* last_reading */
 
 	data->valid = 1;
 
@@ -1082,11 +1082,11 @@ static void asc7621_init_client(struct i2c_client *client)
 		dev_err(&client->dev,
 			"Client (%d,0x%02x) config is locked.\n",
 			i2c_adapter_id(client->adapter), client->addr);
-	};
+	}
 	if (!(value & 0x04)) {
 		dev_err(&client->dev, "Client (%d,0x%02x) is not ready.\n",
 			i2c_adapter_id(client->adapter), client->addr);
-	};
+	}
 
 /*
  * Start monitoring
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index c0771f9..b129fad 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -598,7 +598,7 @@ prcalling(char *dest, u_char * p)
 		dp += prbits(dp, *++p, 8, 8);
 		*dp++ = '\n';
 		l--;
-	};
+	}
 	p++;
 
 	dp += sprintf(dp, "    number digits ");
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index afeede7..c8f804a 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -1859,7 +1859,7 @@ isdn_net_receive(struct net_device *ndev, struct sk_buff *skb)
 				if( cprot -> pops -> data_ind){
 					cprot -> pops -> data_ind(cprot,skb);
 					return;
-				};
+				}
 #endif /* CONFIG_ISDN_X25 */
 			printk(KERN_WARNING "%s: unknown encapsulation, dropping\n",
 			       lp->netdev->dev->name);
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index 4a88a3e..d296688 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -419,12 +419,12 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 				printk(KERN_INFO "TS speed %llu Kbits/sec \n",
 						div64_u64(speed_bytes,
 							speed_timedelta));
-			};
+			}
 
 			demux->speed_last_time = cur_time;
 			demux->speed_pkts_cnt = 0;
-		};
-	};
+		}
+	}
 
 	if (demux->cnt_storage && dvb_demux_tscheck) {
 		/* check pkt counter */
@@ -442,9 +442,9 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 						buf[3] & 0xf);
 
 			demux->cnt_storage[pid] = ((buf[3] & 0xf) + 1)&0xf;
-		};
+		}
 		/* end check */
-	};
+	}
 
 	list_for_each_entry(feed, &demux->feed_list, list_head) {
 		if ((feed->pid != pid) && (feed->pid != 0x2000))
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 30a78af..d4d8830 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -985,7 +985,7 @@ static int HI_Command(struct drxd_state *state, u16 cmd, u16 * pResult)
 		if (nrRetries > DRXD_MAX_RETRIES) {
 			status = -1;
 			break;
-		};
+		}
 		status = Read16(state, HI_RA_RAM_SRV_CMD__A, &waitCmd, 0);
 	} while (waitCmd != 0);
 
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 0ca316d..fbbb161 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1569,7 +1569,7 @@ static int stv0900_status(struct stv0900_internal *intp,
 			* (tsbitrate1_val << 8 | tsbitrate0_val);
 		bitrate /= 16384;
 		dprintk("TS bitrate = %d Mbit/sec \n", bitrate);
-	};
+	}
 
 	return locked;
 }
diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/video/cx23885/altera-ci.c
index 678539b..b5edf25 100644
--- a/drivers/media/video/cx23885/altera-ci.c
+++ b/drivers/media/video/cx23885/altera-ci.c
@@ -417,7 +417,7 @@ static void netup_read_ci_status(struct work_struct *work)
 				DVB_CA_EN50221_POLL_CAM_READY : 0);
 		ci_dbg_print("%s: setting CI[1] status = 0x%x\n",
 				__func__, inter->state[1]->status);
-	};
+	}
 
 	if (inter->state[0] != NULL) {
 		inter->state[0]->status =
@@ -426,7 +426,7 @@ static void netup_read_ci_status(struct work_struct *work)
 				DVB_CA_EN50221_POLL_CAM_READY : 0);
 		ci_dbg_print("%s: setting CI[0] status = 0x%x\n",
 				__func__, inter->state[0]->status);
-	};
+	}
 }
 
 /* CI irq handler */
diff --git a/drivers/media/video/cx23885/cimax2.c b/drivers/media/video/cx23885/cimax2.c
index 209b971..816049c 100644
--- a/drivers/media/video/cx23885/cimax2.c
+++ b/drivers/media/video/cx23885/cimax2.c
@@ -193,7 +193,7 @@ int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
 				0, &store, 1);
 		if (ret != 0)
 			return ret;
-	};
+	}
 	state->current_ci_flag = flag;
 
 	mutex_lock(&dev->gpio_lock);
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
index 8a456de..f269ad5 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
@@ -227,7 +227,7 @@ static int st6422_init(struct sd *sd)
 
 		{ 0x143f, 0x01 },	/* commit settings */
 
-	};
+	}
 
 	for (i = 0; i < ARRAY_SIZE(st6422_bridge_init) && !err; i++) {
 		err = stv06xx_write_bridge(sd, st6422_bridge_init[i][0],
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 090d2a3..b816499 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -1063,7 +1063,7 @@ struct i2o_controller *i2o_iop_alloc(void)
 	     I2O_MSG_INPOOL_MIN)) {
 		kfree(c);
 		return ERR_PTR(-ENOMEM);
-	};
+	}
 
 	INIT_LIST_HEAD(&c->devices);
 	spin_lock_init(&c->lock);
diff --git a/drivers/mtd/maps/bcm963xx-flash.c b/drivers/mtd/maps/bcm963xx-flash.c
index 1f30495..c822880 100644
--- a/drivers/mtd/maps/bcm963xx-flash.c
+++ b/drivers/mtd/maps/bcm963xx-flash.c
@@ -93,18 +93,18 @@ static int parse_cfe_partitions(struct mtd_info *master,
 	if (rootfslen > 0) {
 		nrparts++;
 		namelen += 6;
-	};
+	}
 	if (kernellen > 0) {
 		nrparts++;
 		namelen += 6;
-	};
+	}
 
 	/* Ask kernel for more memory */
 	parts = kzalloc(sizeof(*parts) * nrparts + 10 * nrparts, GFP_KERNEL);
 	if (!parts) {
 		vfree(buf);
 		return -ENOMEM;
-	};
+	}
 
 	/* Start building partition list */
 	parts[curpart].name = "CFE";
@@ -117,7 +117,7 @@ static int parse_cfe_partitions(struct mtd_info *master,
 		parts[curpart].offset = kerneladdr;
 		parts[curpart].size = kernellen;
 		curpart++;
-	};
+	}
 
 	if (rootfslen > 0) {
 		parts[curpart].name = "rootfs";
@@ -126,7 +126,7 @@ static int parse_cfe_partitions(struct mtd_info *master,
 		if (sparelen > 0)
 			parts[curpart].size += sparelen;
 		curpart++;
-	};
+	}
 
 	parts[curpart].name = "nvram";
 	parts[curpart].offset = master->size - master->erasesize;
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index af9fb0f..088c03b 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -944,7 +944,7 @@ static long ubi_cdev_ioctl(struct file *file, unsigned int cmd,
 		if (!req) {
 			err = -ENOMEM;
 			break;
-		};
+		}
 
 		err = copy_from_user(req, argp, sizeof(struct ubi_rnvol_req));
 		if (err) {
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 2ca880b..7a29185 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1958,7 +1958,7 @@ static int __devinit amd8111e_probe_one(struct pci_dev *pdev,
 						 IPG_CONVERGE_JIFFIES;
 		lp->ipg_data.ipg = DEFAULT_IPG;
 		lp->ipg_data.ipg_state = CSTATE;
-	};
+	}
 
 	/*  display driver and device information */
 
diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index 5352c8a..2555bb8 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -3735,7 +3735,7 @@ static int __devinit init_one(struct pci_dev *pdev,
 	if (err) {
 		dev_warn(&pdev->dev, "only %d net devices registered\n", i);
 		err = 0;
-	};
+	}
 
 	if (cxgb4_debugfs_root) {
 		adapter->debugfs_root = debugfs_create_dir(pci_name(pdev),
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 10800f1..77b8ad2 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -304,7 +304,7 @@ static int __devinit xl_probe(struct pci_dev *pdev,
 
 	if ((i = pci_request_regions(pdev,"3c359"))) { 
 		return i ; 
-	} ; 
+	}
 
 	/* 
 	 * Allowing init_trdev to allocate the private data will align
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 0d6fec6..95f71a3 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1887,7 +1887,7 @@ static void velocity_error(struct velocity_info *vptr, int status)
 		else
 			netif_wake_queue(vptr->dev);
 
-	};
+	}
 	if (status & ISR_MIBFI)
 		velocity_update_hw_mibs(vptr);
 	if (status & ISR_LSTEI)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 10a3a3b..d242d6c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -278,7 +278,7 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 		atomic_set(&reply->refcnt, 1);
 		atomic_set(&reply->received, 0);
 		reply->card = card;
-	};
+	}
 	return reply;
 }
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 195823a..b8e915b 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -475,7 +475,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			if (needs_restart)
 				aha1542_restart(shost);
 			return;
-		};
+		}
 
 		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
@@ -755,7 +755,7 @@ static int __init aha1542_getconfig(int base_io, unsigned char *irq_level, unsig
 	i = inb(STATUS(base_io));
 	if (i & DF) {
 		i = inb(DATA(base_io));
-	};
+	}
 	aha1542_out(base_io, inquiry_cmd, 1);
 	aha1542_in(base_io, inquiry_result, 3);
 	WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
@@ -841,7 +841,7 @@ static int __init aha1542_mbenable(int base)
 
 		aha1542_out(base, mbenable_cmd, 3);
 		WAIT(INTRFLAGS(base), INTRMASK, HACC, 0);
-	};
+	}
 	while (0) {
 fail:
 		printk(KERN_ERR "aha1542_mbenable: Mailbox init failed\n");
@@ -859,7 +859,7 @@ static int __init aha1542_query(int base_io, int *transl)
 	i = inb(STATUS(base_io));
 	if (i & DF) {
 		i = inb(DATA(base_io));
-	};
+	}
 	aha1542_out(base_io, inquiry_cmd, 1);
 	aha1542_in(base_io, inquiry_result, 4);
 	WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
@@ -880,7 +880,7 @@ fail:
 	if (inquiry_result[0] == 0x43) {
 		printk(KERN_INFO "aha1542.c: Emulation mode not supported for AHA 174N hardware.\n");
 		return 1;
-	};
+	}
 
 	/* Always call this - boards that do not support extended bios translation
 	   will ignore the command, and we will set the proper default */
@@ -1240,7 +1240,7 @@ unregister:
 			scsi_unregister(shpnt);
 			continue;
 
-		};
+		}
 
 	return count;
 }
@@ -1561,7 +1561,7 @@ static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
 				if (HOSTDATA(SCpnt->host)->mb[i].status) {
 					printk(KERN_ERR "OGMB still full - restarting\n");
 					aha1542_out(SCpnt->host->io_port, &ahacmd, 1);
-				};
+				}
 			} else
 				printk(KERN_ERR "Other pending command %s\n",
 				       SCpnt->request->rq_disk ?
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 43fa986b..8d0980c 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -3548,7 +3548,7 @@ bfa_fcs_lport_ns_sm_online(struct bfa_fcs_lport_ns_s *ns,
 			bfa_sm_set_state(ns,
 				bfa_fcs_lport_ns_sm_sending_gid_ft);
 			bfa_fcs_lport_ns_send_gid_ft(ns, NULL);
-		};
+		}
 		break;
 
 	default:
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index caaee6f..c763387 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2028,7 +2028,7 @@ bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport)
 		bfa_fcs_itnim_rport_online(rport->itnim);
 		if (!BFA_FCS_PID_IS_WKA(rport->pid))
 			bfa_fcs_rpf_rport_online(rport);
-	};
+	}
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	wwn2str(rpwwn_buf, rport->pwwn);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 6b8b021..a2f54bc 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1261,7 +1261,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 				 *   ---> AutoSCSI with MSGOUTreg is processed.
 				 */
 				data->msgout_len = 0;
-			};
+			}
 
 			nsp32_dbg(NSP32_DEBUG_INTR, "MsgOut phase processed");
 		}
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 190770b..55100c9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -386,7 +386,7 @@ void sym_fw_bind_script(struct sym_hcb *np, u32 *start, int len)
 				sym_name(np), (int) (cur-start));
 			++cur;
 			continue;
-		};
+		}
 
 		/*
 		 *  We use the bogus value 0xf00ff00f ;-)
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 9f4b58b..1be0402 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -380,7 +380,7 @@ static int ultrastor_14f_detect(struct scsi_host_template * tpnt)
     if(!request_region(PORT_OVERRIDE, 0xc, "ultrastor")) {
       printk("Ultrastor I/O space already in use\n");
       return FALSE;
-    };
+    }
     config.port_address = PORT_OVERRIDE;
 #else
     for (i = 0; i < ARRAY_SIZE(ultrastor_ports_14f); i++) {
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 4f65b14..5cbad76 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -806,7 +806,7 @@ static int uhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 		dev_warn(uhci_dev(uhci), "Root hub isn't suspended!\n");
 		rc = -EBUSY;
 		goto done;
-	};
+	}
 
 	/* All PCI host controllers are required to disable IRQ generation
 	 * at the source, so we must turn off PIRQ.
diff --git a/drivers/video/cfbimgblt.c b/drivers/video/cfbimgblt.c
index baed57d..a2bb276 100644
--- a/drivers/video/cfbimgblt.c
+++ b/drivers/video/cfbimgblt.c
@@ -181,7 +181,7 @@ static inline void slow_imageblit(const struct fb_image *image, struct fb_info *
 			}
 			shift += bpp;
 			shift &= (32 - 1);
-			if (!l) { l = 8; s++; };
+			if (!l) { l = 8; s++; }
 		}
 
 		/* write trailing bits */
diff --git a/drivers/video/sysimgblt.c b/drivers/video/sysimgblt.c
index 186c6f6..a4d05b1 100644
--- a/drivers/video/sysimgblt.c
+++ b/drivers/video/sysimgblt.c
@@ -152,7 +152,7 @@ static void slow_imageblit(const struct fb_image *image, struct fb_info *p,
 			}
 			shift += bpp;
 			shift &= (32 - 1);
-			if (!l) { l = 8; s++; };
+			if (!l) { l = 8; s++; }
 		}
 
 		/* write trailing bits */
diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 4202db7..0f40902 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -500,7 +500,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 			   "for key of size %d", bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
-	};
+	}
 
 	strncpy(keybuf, keystart, keylen);
 	*value = fs64_to_cpu(sb, valarray[cur_key]);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 22cf01b..8b33d35 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3635,7 +3635,7 @@ no_journal:
 		ext4_mb_release(sb);
 		ext4_ext_release(sb);
 		goto failed_mount4;
-	};
+	}
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 07ee154..1bf27b0 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1226,7 +1226,7 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
 		printk(KERN_WARNING "JFFS2 flash size adjusted to %dKiB\n", c->flash_size);
-	};
+	}
 
 	c->wbuf_ofs = 0xFFFFFFFF;
 	c->wbuf = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index 1711b71..c6db5d1 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -913,7 +913,7 @@ s64 __ntfs_cluster_free(ntfs_inode *ni, const VCN start_vcn, s64 count,
 		}
 		/* We have freed @to_free real clusters. */
 		real_freed = to_free;
-	};
+	}
 	/* Go to the next run and adjust the number of clusters left to free. */
 	++rl;
 	if (count >= 0)
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 5f79a66..596606b 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -90,7 +90,7 @@ static int aix_magic_present(struct parsed_partitions *state, unsigned char *p)
 		if (d[0] == '_' && d[1] == 'L' && d[2] == 'V' && d[3] == 'M')
 			ret = 1;
 		put_dev_sector(sect);
-	};
+	}
 	return ret;
 }
 
diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 483442e..86789fb 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -560,7 +560,7 @@ int reiserfs_parse_alloc_options(struct super_block *s, char *options)
 		if (!strcmp(this_char, "displacing_new_packing_localities")) {
 			SET_OPTION(displacing_new_packing_localities);
 			continue;
-		};
+		}
 
 		if (!strcmp(this_char, "old_hashed_relocation")) {
 			SET_OPTION(old_hashed_relocation);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 67e3127..78cef42 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -624,7 +624,7 @@ rpcauth_refreshcred(struct rpc_task *task)
 		if (err < 0)
 			goto out;
 		cred = task->tk_rqstp->rq_cred;
-	};
+	}
 	dprintk("RPC: %5u refreshing %s cred %p\n",
 		task->tk_pid, cred->cr_auth->au_ops->au_name, cred);
 
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 9890cf2..5b92c42 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -1109,10 +1109,10 @@ int ess_init(sb_devc * devc, struct address_info *hw_config)
 			devc->submodel = submodel;
 			sprintf (modelname, "ES%d", devc->sbmo.esstype);
 			chip = modelname;
-		};
+		}
 		if (chip == NULL && (ess_minor & 0x0f) < 8) {
 			chip = "ES688";
-		};
+		}
 #ifdef FKS_TEST
 FKS_test (devc);
 #endif
@@ -1122,7 +1122,7 @@ FKS_test (devc);
 		 */
 		if (chip == NULL && devc->sbmo.esstype == ESSTYPE_LIKE20) {
 			chip = "ES1688";
-		};
+		}
 
 		if (chip == NULL) {
 			int type;
@@ -1151,7 +1151,7 @@ FKS_test (devc);
 					printk ("ess_init: Unrecognized %04x\n", type);
 				}
 			};
-		};
+		}
 #if 0
 		/*
 		 * this one failed:
@@ -1182,10 +1182,10 @@ FKS_test (devc);
 				chip = "ES1788";
 				devc->submodel = SUBMDL_ES1788;
 			}
-		};
+		}
 		if (chip == NULL) {
 			chip = "ES1688";
-		};
+		}
 
 	    printk ( KERN_INFO "ESS chip %s %s%s\n"
                , chip
diff --git a/sound/oss/sb_mixer.c b/sound/oss/sb_mixer.c
index 2039d31..2a9d1ee 100644
--- a/sound/oss/sb_mixer.c
+++ b/sound/oss/sb_mixer.c
@@ -410,7 +410,7 @@ static int set_recmask(sb_devc * devc, int mask)
 		case MDL_SMW:
 			if (devc->model == MDL_ESS && ess_set_recmask (devc, &devmask)) {
 				break;
-			};
+			}
 			if (devmask != SOUND_MASK_MIC &&
 				devmask != SOUND_MASK_LINE &&
 				devmask != SOUND_MASK_CD)
@@ -666,7 +666,7 @@ static void sb_mixer_reset(sb_devc * devc)
 
 	if (devc->model != MDL_ESS || !ess_mixer_reset (devc)) {
 		set_recmask(devc, SOUND_MASK_MIC);
-	};
+	}
 }
 
 int sb_mixer_init(sb_devc * devc, struct module *owner)
diff --git a/sound/oss/uart6850.c b/sound/oss/uart6850.c
index f3f914a..1079133 100644
--- a/sound/oss/uart6850.c
+++ b/sound/oss/uart6850.c
@@ -146,7 +146,7 @@ static int uart6850_open(int dev, int mode,
 	{
 /*		  printk("Midi6850: Midi busy\n");*/
 		  return -EBUSY;
-	};
+	}
 
 	uart6850_cmd(UART_RESET);
 	uart6850_input_loop();
diff --git a/sound/pci/au88x0/au88x0_game.c b/sound/pci/au88x0/au88x0_game.c
index e291aa5..90d8610 100644
--- a/sound/pci/au88x0/au88x0_game.c
+++ b/sound/pci/au88x0/au88x0_game.c
@@ -99,7 +99,7 @@ static int __devinit vortex_gameport_register(vortex_t * vortex)
 	if (!gp) {
 		printk(KERN_ERR "vortex: cannot allocate memory for gameport\n");
 		return -ENOMEM;
-	};
+	}
 
 	gameport_set_name(gp, "AU88x0 Gameport");
 	gameport_set_phys(gp, "pci%s/gameport0", pci_name(vortex->pci_dev));
-- 
1.7.4.2.g597a6.dirty

