Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1DJVbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:31:05 -0400
Received: from mail.perches.com ([173.55.12.10]:4620 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1DJVaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:30:18 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 4/4] treewide: Remove unnecessary semicolons when switch (foo) {...};
Date: Sun, 10 Apr 2011 14:30:16 -0700
Message-Id: <d157d39cf9aa4954697ae77d530eae55c9d363d6.1302470775.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470773.git.joe@perches.com>
References: <cover.1302470773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_switch.pl
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
	$count += $text =~ s@\b(switch\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
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

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/alpha/kernel/osf_sys.c                      |    2 +-
 arch/alpha/kernel/sys_eiger.c                    |    2 +-
 arch/arm/mach-omap2/board-flash.c                |    2 +-
 arch/arm/mach-omap2/mux.c                        |    2 +-
 arch/arm/mach-omap2/pm-debug.c                   |    2 +-
 arch/arm/mach-s3c2410/mach-h1940.c               |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c           |    4 +-
 arch/ia64/kvm/vcpu.c                             |    2 +-
 arch/m68k/include/asm/sun3xflop.h                |    4 +-
 arch/m68k/sun3/prom/console.c                    |   10 ++--
 arch/m68k/sun3/prom/init.c                       |    2 +-
 arch/mips/oprofile/common.c                      |    2 +-
 arch/powerpc/include/asm/ps3.h                   |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c          |    4 +-
 arch/powerpc/platforms/pseries/eeh.c             |    2 +-
 arch/sparc/include/asm/floppy_32.h               |    8 ++--
 arch/sparc/include/asm/floppy_64.h               |    4 +-
 arch/sparc/include/asm/system_32.h               |    2 +-
 arch/sparc/include/asm/system_64.h               |    2 +-
 arch/sparc/kernel/apc.c                          |    2 +-
 arch/sparc/kernel/auxio_32.c                     |    2 +-
 arch/sparc/kernel/chmc.c                         |    2 +-
 arch/sparc/kernel/module.c                       |    2 +-
 arch/sparc/kernel/pci_common.c                   |    4 +-
 arch/sparc/kernel/pci_schizo.c                   |    6 +-
 arch/sparc/kernel/prom_irqtrans.c                |    2 +-
 arch/sparc/kernel/psycho_common.c                |    2 +-
 arch/sparc/kernel/sbus.c                         |    4 +-
 arch/sparc/kernel/setup_32.c                     |    2 +-
 arch/sparc/kernel/setup_64.c                     |    2 +-
 arch/sparc/kernel/smp_32.c                       |    6 +-
 arch/sparc/kernel/sys_sparc32.c                  |    2 +-
 arch/sparc/kernel/sys_sparc_64.c                 |    6 +-
 arch/sparc/kernel/time_64.c                      |    2 +-
 arch/sparc/kernel/traps_64.c                     |    2 +-
 arch/sparc/kernel/unaligned_64.c                 |    6 +-
 arch/sparc/kernel/us2e_cpufreq.c                 |    6 +-
 arch/sparc/kernel/us3_cpufreq.c                  |    4 +-
 arch/sparc/kernel/viohs.c                        |    2 +-
 arch/sparc/kernel/visemul.c                      |   14 +++---
 arch/sparc/mm/fault_32.c                         |    2 +-
 arch/sparc/mm/init_32.c                          |    2 +-
 arch/sparc/mm/init_64.c                          |    6 +-
 arch/sparc/mm/srmmu.c                            |    4 +-
 arch/sparc/mm/sun4c.c                            |    8 ++--
 arch/sparc/mm/tsb.c                              |    6 +-
 arch/sparc/prom/console_32.c                     |    2 +-
 arch/sparc/prom/init_32.c                        |    2 +-
 arch/sparc/prom/mp.c                             |    2 +-
 arch/x86/kernel/cpu/cpufreq/longhaul.c           |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c      |    2 +-
 arch/x86/kvm/vmx.c                               |    2 +-
 crypto/af_alg.c                                  |    2 +-
 drivers/ata/pata_bf54x.c                         |    2 +-
 drivers/atm/firestream.c                         |    2 +-
 drivers/atm/horizon.c                            |    4 +-
 drivers/block/drbd/drbd_req.c                    |    2 +-
 drivers/block/sunvdc.c                           |    2 +-
 drivers/bluetooth/bfusb.c                        |    2 +-
 drivers/bluetooth/bluecard_cs.c                  |    2 +-
 drivers/bluetooth/bt3c_cs.c                      |    2 +-
 drivers/bluetooth/btuart_cs.c                    |    2 +-
 drivers/bluetooth/dtl1_cs.c                      |    2 +-
 drivers/bluetooth/hci_ldisc.c                    |    2 +-
 drivers/bluetooth/hci_ll.c                       |    2 +-
 drivers/bluetooth/hci_vhci.c                     |    2 +-
 drivers/char/rtc.c                               |    2 +-
 drivers/infiniband/hw/amso1100/c2_ae.c           |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c           |    2 +-
 drivers/isdn/hisax/st5481.h                      |    2 +-
 drivers/isdn/pcbit/drv.c                         |    4 +-
 drivers/isdn/pcbit/layer2.h                      |    4 +-
 drivers/media/common/tuners/tda18271-common.c    |   10 ++--
 drivers/media/common/tuners/tuner-xc2028.c       |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c                 |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c        |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c               |    4 +-
 drivers/media/dvb/frontends/af9013.c             |    6 +-
 drivers/media/dvb/frontends/bcm3510.c            |    2 +-
 drivers/media/dvb/frontends/cx24110.c            |    2 +-
 drivers/media/dvb/frontends/cx24123.c            |    2 +-
 drivers/media/dvb/frontends/isl6405.c            |    2 +-
 drivers/media/dvb/frontends/isl6421.c            |    2 +-
 drivers/media/dvb/frontends/lnbp21.c             |    4 +-
 drivers/media/dvb/frontends/si21xx.c             |    2 +-
 drivers/media/dvb/frontends/sp8870.c             |    6 +-
 drivers/media/dvb/frontends/sp887x.c             |    6 +-
 drivers/media/dvb/frontends/stv0299.c            |    2 +-
 drivers/media/dvb/frontends/tda8083.c            |    6 +-
 drivers/media/radio/si470x/radio-si470x-common.c |   10 ++--
 drivers/media/radio/si470x/radio-si470x-i2c.c    |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c    |    2 +-
 drivers/media/radio/si4713-i2c.c                 |   12 ++--
 drivers/media/video/cx25840/cx25840-core.c       |    2 +-
 drivers/media/video/cx88/cx88-dvb.c              |    2 +-
 drivers/media/video/cx88/cx88-tvaudio.c          |    4 +-
 drivers/media/video/omap3isp/ispccdc.c           |    4 +-
 drivers/media/video/ov9640.c                     |    2 +-
 drivers/media/video/saa7134/saa7134-video.c      |    2 +-
 drivers/media/video/tea6415c.c                   |    4 +-
 drivers/memstick/core/mspro_block.c              |    2 +-
 drivers/memstick/host/jmb38x_ms.c                |    2 +-
 drivers/memstick/host/tifm_ms.c                  |    2 +-
 drivers/mfd/tps65010.c                           |    2 +-
 drivers/misc/ti-st/st_core.c                     |    2 +-
 drivers/mmc/host/davinci_mmc.c                   |    2 +-
 drivers/mmc/host/wbsd.c                          |    2 +-
 drivers/net/enic/enic_main.c                     |    2 +-
 drivers/net/irda/via-ircc.h                      |    2 +-
 drivers/net/iseries_veth.c                       |    4 +-
 drivers/net/ixgbe/ixgbe_82599.c                  |    4 +-
 drivers/net/sungem.c                             |    2 +-
 drivers/net/tokenring/ibmtr.c                    |    2 +-
 drivers/net/tun.c                                |    2 +-
 drivers/net/wireless/b43/main.c                  |    2 +-
 drivers/net/wireless/b43legacy/main.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c          |    2 +-
 drivers/nfc/pn544.c                              |    4 +-
 drivers/pci/proc.c                               |    2 +-
 drivers/pci/syscall.c                            |    2 +-
 drivers/pcmcia/db1xxx_ss.c                       |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                     |    2 +-
 drivers/rtc/rtc-rs5c372.c                        |    2 +-
 drivers/s390/net/ctcm_fsms.c                     |    2 +-
 drivers/s390/scsi/zfcp_fc.h                      |    2 +-
 drivers/s390/scsi/zfcp_fsf.c                     |    2 +-
 drivers/sbus/char/display7seg.c                  |    2 +-
 drivers/sbus/char/envctrl.c                      |    8 ++--
 drivers/sbus/char/openprom.c                     |    6 +-
 drivers/scsi/aha1542.c                           |    6 +-
 drivers/scsi/fnic/fnic_main.c                    |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                   |   36 +++++++-------
 drivers/scsi/ipr.c                               |    4 +-
 drivers/scsi/ipr.h                               |    2 +-
 drivers/scsi/pmcraid.c                           |    2 +-
 drivers/scsi/qlogicpti.c                         |    2 +-
 drivers/scsi/sym53c8xx_2/sym_fw.c                |    2 +-
 drivers/tty/nozomi.c                             |    6 +-
 drivers/tty/serial/bfin_5xx.c                    |    4 +-
 drivers/tty/serial/ip22zilog.c                   |    2 +-
 drivers/tty/serial/pmac_zilog.c                  |    2 +-
 drivers/tty/serial/sunsab.c                      |    2 +-
 drivers/tty/serial/sunsu.c                       |    2 +-
 drivers/tty/serial/sunzilog.c                    |    6 +-
 drivers/usb/core/hcd.c                           |    2 +-
 drivers/usb/core/hub.c                           |    2 +-
 drivers/usb/gadget/composite.c                   |    2 +-
 drivers/usb/gadget/dummy_hcd.c                   |    6 +-
 drivers/usb/gadget/goku_udc.c                    |    2 +-
 drivers/usb/gadget/langwell_udc.c                |    2 +-
 drivers/usb/gadget/net2280.c                     |    4 +-
 drivers/usb/gadget/rndis.c                       |    2 +-
 drivers/usb/host/ehci-dbg.c                      |    2 +-
 drivers/usb/host/isp116x.h                       |    2 +-
 drivers/usb/host/isp1362-hcd.c                   |    2 +-
 drivers/usb/host/ohci-dbg.c                      |    2 +-
 drivers/usb/host/sl811-hcd.c                     |    4 +-
 drivers/usb/host/whci/hcd.c                      |    4 +-
 drivers/usb/misc/usbtest.c                       |    2 +-
 drivers/usb/musb/musb_core.c                     |    4 +-
 drivers/usb/musb/musb_gadget.c                   |    2 +-
 drivers/usb/musb/musb_host.c                     |    4 +-
 drivers/usb/otg/twl4030-usb.c                    |    2 +-
 drivers/usb/wusbcore/cbaf.c                      |    4 +-
 drivers/usb/wusbcore/devconnect.c                |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                   |    4 +-
 drivers/vbus/pci-bridge.c                        |    2 +-
 drivers/video/cg14.c                             |    4 +-
 drivers/video/cg6.c                              |    2 +-
 drivers/video/leo.c                              |    2 +-
 drivers/video/nvidia/nv_hw.c                     |    2 +-
 drivers/video/sbuslib.c                          |    2 +-
 drivers/video/tcx.c                              |    4 +-
 drivers/watchdog/riowd.c                         |    2 +-
 fs/9p/vfs_inode.c                                |    2 +-
 fs/btrfs/print-tree.c                            |    2 +-
 fs/gfs2/inode.c                                  |    2 +-
 fs/gfs2/ops_inode.c                              |    2 +-
 fs/gfs2/recovery.c                               |    2 +-
 fs/lockd/clnt4xdr.c                              |    4 +-
 fs/lockd/clntxdr.c                               |    4 +-
 fs/nfs/nfs2xdr.c                                 |   10 ++--
 fs/nfs/nfs3xdr.c                                 |   56 +++++++++++-----------
 fs/nfs/nfs4proc.c                                |    2 +-
 fs/nfs/nfs4state.c                               |    2 +-
 fs/nfs/super.c                                   |    4 +-
 fs/nfsd/nfs4callback.c                           |    2 +-
 fs/nfsd/nfs4state.c                              |    2 +-
 fs/notify/fanotify/fanotify.c                    |    2 +-
 fs/notify/inotify/inotify_fsnotify.c             |    2 +-
 fs/ocfs2/cluster/quorum.c                        |    2 +-
 fs/ocfs2/dlmglue.c                               |    2 +-
 fs/ubifs/sb.c                                    |    2 +-
 include/linux/hp_sdc.h                           |    2 +-
 include/net/sctp/sctp.h                          |    4 +-
 kernel/audit_watch.c                             |    2 +-
 kernel/res_counter.c                             |    2 +-
 kernel/smp.c                                     |    2 +-
 net/batman-adv/hard-interface.c                  |    2 +-
 security/selinux/hooks.c                         |    2 +-
 sound/drivers/vx/vx_pcm.c                        |    2 +-
 sound/oss/sb_ess.c                               |   10 ++--
 sound/pci/asihpi/asihpi.c                        |    2 +-
 sound/pci/emu10k1/emupcm.c                       |    2 +-
 sound/pci/intel8x0.c                             |    2 +-
 sound/sparc/amd7930.c                            |    4 +-
 sound/sparc/dbri.c                               |    2 +-
 208 files changed, 359 insertions(+), 359 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 376f221..a796f34 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -522,7 +522,7 @@ SYSCALL_DEFINE2(osf_proplist_syscall, enum pl_code, code,
 	default:
 		error = -EOPNOTSUPP;
 		break;
-	};
+	}
 	return error;
 }
 
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index a60cd5b..12ddf43 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -177,7 +177,7 @@ eiger_swizzle(struct pci_dev *dev, u8 *pinp)
 	   case 0x03: bridge_count = 2; break; /* 2 */
 	   case 0x07: bridge_count = 3; break; /* 3 */
 	   case 0x0f: bridge_count = 4; break; /* 4 */
-	};
+	}
 
 	slot = PCI_SLOT(dev->devfn);
 	while (dev->bus->self) {
diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index 729892f..efdf83a 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -232,7 +232,7 @@ void board_flash_init(struct flash_partitions partition_info[],
 			if (onenandcs > GPMC_CS_NUM)
 				onenandcs = cs;
 			break;
-		};
+		}
 		cs++;
 	}
 
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index bb043cb..19a92b2 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -407,7 +407,7 @@ void omap_hwmod_mux(struct omap_hwmod_mux_info *hmux, u8 state)
 		default:
 			/* Nothing to be done */
 			break;
-		};
+		}
 
 		if (val >= 0) {
 			omap_mux_write(pad->partition, val,
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index a5a83b3..386775b 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -466,7 +466,7 @@ static int pm_dbg_open(struct inode *inode, struct file *file)
 	default:
 		return single_open(file, pm_dbg_show_timers,
 			&inode->i_private);
-	};
+	}
 }
 
 static int pm_dbg_reg_open(struct inode *inode, struct file *file)
diff --git a/arch/arm/mach-s3c2410/mach-h1940.c b/arch/arm/mach-s3c2410/mach-h1940.c
index 2a2fa06..d197d01 100644
--- a/arch/arm/mach-s3c2410/mach-h1940.c
+++ b/arch/arm/mach-s3c2410/mach-h1940.c
@@ -462,7 +462,7 @@ static void h1940_set_mmc_power(unsigned char power_mode, unsigned short vdd)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 static struct s3c24xx_mci_pdata h1940_mmc_cfg __initdata = {
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index c03bc3b..3e7e72d 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -1775,7 +1775,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key, const unsigned  char *ke
 		break;
 	default:
 		panic("stream co-processor: bad aes key length in get_aes_decrypt_key\n");
-	};
+	}
 
 	/* Need to do host byte order correction here since key is byte oriented and the
 	 * kx algorithm is word (u32) oriented. */
@@ -3014,7 +3014,7 @@ static int cryptocop_ioctl_create_session(struct inode *inode, struct file *filp
 		default:
 			DEBUG_API(printk("create session, bad cipher algorithm %d\n", sop.cipher));
 			return -EINVAL;
-		};
+		}
 		DEBUG(printk("setting cipher transform %d\n", ti_cipher.alg));
 		copy_from_user(ti_cipher.key, sop.key, sop.keylen/8);
 		ti_cipher.keylen = sop.keylen;
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index 958815c..fc77c2e 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -2026,7 +2026,7 @@ void kvm_emulate(struct kvm_vcpu *vcpu, struct kvm_pt_regs *regs)
 		break;
 	default:
 		break;
-	};
+	}
 	/*Assume all status is NO_FAULT ?*/
 	if (status == IA64_NO_FAULT && cause != EVENT_RFI)
 		vcpu_increment_iip(vcpu);
diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
index 32c45f8..c091312 100644
--- a/arch/m68k/include/asm/sun3xflop.h
+++ b/arch/m68k/include/asm/sun3xflop.h
@@ -62,7 +62,7 @@ static unsigned char sun3x_82072_fd_inb(int port)
 			return 0x80;
 		}
 		return 0;
-	};
+	}
 	panic("sun_82072_fd_inb: How did I get here?");
 }
 
@@ -106,7 +106,7 @@ static void sun3x_82072_fd_outb(unsigned char value, int port)
 	case 4: /* FD_STATUS */
 		*(sun3x_fdc.status_r) = value;
 		break;
-	};
+	}
 	return;
 }
 
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 2bcb6e4..ca009ae 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -80,7 +80,7 @@ prom_query_input_device()
 		case PROMDEV_TTYB:	return PROMDEV_ITTYB;
 		default:
 			return PROMDEV_I_UNK;
-		};
+		}
 	case PROM_V3:
 	case PROM_P1275:
 		local_irq_save(flags);
@@ -104,7 +104,7 @@ prom_query_input_device()
 				return PROMDEV_ITTYB;
 		}
 		return PROMDEV_I_UNK;
-	};
+	}
 }
 #endif
 
@@ -126,7 +126,7 @@ prom_query_output_device()
 		case PROMDEV_SCREEN:	return PROMDEV_OSCREEN;
 		case PROMDEV_TTYA:	return PROMDEV_OTTYA;
 		case PROMDEV_TTYB:	return PROMDEV_OTTYB;
-		};
+		}
 		break;
 	case PROM_V2:
 	case PROM_V3:
@@ -161,10 +161,10 @@ prom_query_output_device()
 			switch(*romvec->pv_stdin) {
 			case PROMDEV_TTYA:	return PROMDEV_OTTYA;
 			case PROMDEV_TTYB:	return PROMDEV_OTTYB;
-			};
+			}
 		}
 		break;
-	};
+	}
 	return PROMDEV_O_UNK;
 }
 #endif
diff --git a/arch/m68k/sun3/prom/init.c b/arch/m68k/sun3/prom/init.c
index d8e6349..430e217 100644
--- a/arch/m68k/sun3/prom/init.c
+++ b/arch/m68k/sun3/prom/init.c
@@ -53,7 +53,7 @@ void __init prom_init(struct linux_romvec *rp)
 			    romvec->pv_romvers);
 		prom_halt();
 		break;
-	};
+	}
 
 	prom_rev = romvec->pv_plugin_revision;
 	prom_prev = romvec->pv_printrev;
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index fff011a..f3d1aad 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -98,7 +98,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	case CPU_LOONGSON2:
 		lmodel = &op_model_loongson2_ops;
 		break;
-	};
+	}
 
 	if (!lmodel)
 		return -ENODEV;
diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index 7f065e1..62c01b1 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -306,7 +306,7 @@ static inline const char* ps3_result(int result)
 	default:
 		BUG();
 		return "** unknown result **";
-	};
+	}
 #else
 	return "";
 #endif
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 23083c3..698305f 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -613,7 +613,7 @@ static dma_addr_t ps3_ioc0_map_page(struct device *_dev, struct page *page,
 	default:
 		/* not happned */
 		BUG();
-	};
+	}
 	result = ps3_dma_map(dev->d_region, (unsigned long)ptr, size,
 			     &bus_addr, iopte_flag);
 
@@ -764,7 +764,7 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	dev->core.of_node = NULL;
 	set_dev_node(&dev->core, 0);
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 3cc4d10..c337630 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -728,7 +728,7 @@ int pcibios_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state stat
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/arch/sparc/include/asm/floppy_32.h b/arch/sparc/include/asm/floppy_32.h
index 86666f7..55aea28 100644
--- a/arch/sparc/include/asm/floppy_32.h
+++ b/arch/sparc/include/asm/floppy_32.h
@@ -138,7 +138,7 @@ static unsigned char sun_82072_fd_inb(int port)
 		return sun_fdc->data_82072;
 	case 7: /* FD_DIR */
 		return sun_read_dir();
-	};
+	}
 	panic("sun_82072_fd_inb: How did I get here?");
 }
 
@@ -161,7 +161,7 @@ static void sun_82072_fd_outb(unsigned char value, int port)
 	case 4: /* FD_STATUS */
 		sun_fdc->status_82072 = value;
 		break;
-	};
+	}
 	return;
 }
 
@@ -186,7 +186,7 @@ static unsigned char sun_82077_fd_inb(int port)
 		return sun_fdc->data_82077;
 	case 7: /* FD_DIR */
 		return sun_read_dir();
-	};
+	}
 	panic("sun_82077_fd_inb: How did I get here?");
 }
 
@@ -212,7 +212,7 @@ static void sun_82077_fd_outb(unsigned char value, int port)
 	case 3: /* FD_TDR */
 		sun_fdc->tapectl_82077 = value;
 		break;
-	};
+	}
 	return;
 }
 
diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index 6597ce8..bcef1f5 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -111,7 +111,7 @@ static unsigned char sun_82077_fd_inb(unsigned long port)
 	case 7: /* FD_DIR */
 		/* XXX: Is DCL on 0x80 in sun4m? */
 		return sbus_readb(&sun_fdc->dir_82077);
-	};
+	}
 	panic("sun_82072_fd_inb: How did I get here?");
 }
 
@@ -135,7 +135,7 @@ static void sun_82077_fd_outb(unsigned char value, unsigned long port)
 	case 4: /* FD_STATUS */
 		sbus_writeb(value, &sun_fdc->status_82077);
 		break;
-	};
+	}
 	return;
 }
 
diff --git a/arch/sparc/include/asm/system_32.h b/arch/sparc/include/asm/system_32.h
index 890036b..9291ec4 100644
--- a/arch/sparc/include/asm/system_32.h
+++ b/arch/sparc/include/asm/system_32.h
@@ -225,7 +225,7 @@ static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr, int
 	switch (size) {
 	case 4:
 		return xchg_u32(ptr, x);
-	};
+	}
 	__xchg_called_with_bad_pointer();
 	return x;
 }
diff --git a/arch/sparc/include/asm/system_64.h b/arch/sparc/include/asm/system_64.h
index e3b65d8..a046fa7 100644
--- a/arch/sparc/include/asm/system_64.h
+++ b/arch/sparc/include/asm/system_64.h
@@ -238,7 +238,7 @@ static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr,
 		return xchg32(ptr, x);
 	case 8:
 		return xchg64(ptr, x);
-	};
+	}
 	__xchg_called_with_bad_pointer();
 	return x;
 }
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index f679c57..77fcdb0 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -123,7 +123,7 @@ static long apc_ioctl(struct file *f, unsigned int cmd, unsigned long __arg)
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/arch/sparc/kernel/auxio_32.c b/arch/sparc/kernel/auxio_32.c
index 8505e0a..acf5151 100644
--- a/arch/sparc/kernel/auxio_32.c
+++ b/arch/sparc/kernel/auxio_32.c
@@ -101,7 +101,7 @@ void set_auxio(unsigned char bits_on, unsigned char bits_off)
 		break;
 	default:
 		panic("Can't set AUXIO register on this machine.");
-	};
+	}
 	spin_unlock_irqrestore(&auxio_lock, flags);
 }
 EXPORT_SYMBOL(set_auxio);
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index 668c7be..5f45026 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -664,7 +664,7 @@ static void chmc_interpret_one_decode_reg(struct chmc *p, int which_bank, u64 va
 	case 0x0:
 		bp->interleave = 16;
 		break;
-	};
+	}
 
 	/* UK[10] is reserved, and UK[11] is not set for the SDRAM
 	 * bank size definition.
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 8d348c4..99ba5ba 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -214,7 +214,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			       me->name,
 			       (int) (ELF_R_TYPE(rel[i].r_info) & 0xff));
 			return -ENOEXEC;
-		};
+		}
 	}
 	return 0;
 }
diff --git a/arch/sparc/kernel/pci_common.c b/arch/sparc/kernel/pci_common.c
index 6e3874b..a689598 100644
--- a/arch/sparc/kernel/pci_common.c
+++ b/arch/sparc/kernel/pci_common.c
@@ -281,7 +281,7 @@ static int sun4v_read_pci_cfg(struct pci_bus *bus_dev, unsigned int devfn,
 	case 4:
 		*value = ret & 0xffffffff;
 		break;
-	};
+	}
 
 
 	return PCIBIOS_SUCCESSFUL;
@@ -456,7 +456,7 @@ void pci_determine_mem_io_space(struct pci_pbm_info *pbm)
 
 		default:
 			break;
-		};
+		}
 	}
 
 	if (!saw_io || !saw_mem) {
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index fecfcb2..8bfc481 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -264,7 +264,7 @@ static void schizo_check_iommu_error_pbm(struct pci_pbm_info *pbm,
 		default:
 			type_string = "ECC Error";
 			break;
-		};
+		}
 		printk("%s: IOMMU Error, type[%s]\n",
 		       pbm->name, type_string);
 
@@ -319,7 +319,7 @@ static void schizo_check_iommu_error_pbm(struct pci_pbm_info *pbm,
 			default:
 				type_string = "ECC Error";
 				break;
-			};
+			}
 			printk("%s: IOMMU TAG(%d)[error(%s) ctx(%x) wr(%d) str(%d) "
 			       "sz(%dK) vpg(%08lx)]\n",
 			       pbm->name, i, type_string,
@@ -1328,7 +1328,7 @@ static int __devinit schizo_pbm_init(struct pci_pbm_info *pbm,
 	default:
 		chipset_name = "SCHIZO";
 		break;
-	};
+	}
 
 	/* For SCHIZO, three OBP regs:
 	 * 1) PBM controller regs
diff --git a/arch/sparc/kernel/prom_irqtrans.c b/arch/sparc/kernel/prom_irqtrans.c
index 570b98f..40e4936 100644
--- a/arch/sparc/kernel/prom_irqtrans.c
+++ b/arch/sparc/kernel/prom_irqtrans.c
@@ -694,7 +694,7 @@ static unsigned int sbus_of_build_irq(struct device_node *dp,
 		case 3:
 			iclr = reg_base + SYSIO_ICLR_SLOT3;
 			break;
-		};
+		}
 
 		iclr += ((unsigned long)sbus_level - 1UL) * 8UL;
 	}
diff --git a/arch/sparc/kernel/psycho_common.c b/arch/sparc/kernel/psycho_common.c
index fe2af66..8db48e8 100644
--- a/arch/sparc/kernel/psycho_common.c
+++ b/arch/sparc/kernel/psycho_common.c
@@ -228,7 +228,7 @@ void psycho_check_iommu_error(struct pci_pbm_info *pbm,
 		default:
 			type_str = "ECC Error";
 			break;
-		};
+		}
 		printk(KERN_ERR "%s: IOMMU Error, type[%s]\n",
 		       pbm->name, type_str);
 
diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index 2ca32d1..a161b9c 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -97,7 +97,7 @@ void sbus_set_sbus64(struct device *dev, int bursts)
 
 	default:
 		return;
-	};
+	}
 
 	val = upa_readq(cfg_reg);
 	if (val & (1UL << 14UL)) {
@@ -244,7 +244,7 @@ static unsigned int sbus_build_irq(struct platform_device *op, unsigned int ino)
 		case 3:
 			iclr = reg_base + SYSIO_ICLR_SLOT3;
 			break;
-		};
+		}
 
 		iclr += ((unsigned long)sbus_level - 1UL) * 8UL;
 	}
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index 7b8b76c..fac4838 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -260,7 +260,7 @@ void __init setup_arch(char **cmdline_p)
 	default:
 		printk("UNKNOWN!\n");
 		break;
-	};
+	}
 
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 29bafe0..4e02bea 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -209,7 +209,7 @@ void __init per_cpu_patch(void)
 		default:
 			prom_printf("Unknown cpu type, halting.\n");
 			prom_halt();
-		};
+		}
 
 		*(unsigned int *) (addr +  0) = insns[0];
 		wmb();
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 91c10fb..1b65cd5 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -112,7 +112,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 }
 
 void cpu_panic(void)
@@ -325,7 +325,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 }
 
 /* Set this up early so that things like the scheduler can init
@@ -398,7 +398,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 		printk("UNKNOWN!\n");
 		BUG();
 		break;
-	};
+	}
 
 	if (!ret) {
 		cpu_set(cpu, smp_commenced_mask);
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 6db18c6..170cd8e 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -109,7 +109,7 @@ asmlinkage long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compa
 
 	default:
 		return -ENOSYS;
-	};
+	}
 
 	return -ENOSYS;
 }
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 96082d3..908b47a 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -460,7 +460,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	}
 	if (call <= MSGCTL) {
 		switch (call) {
@@ -481,7 +481,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	}
 	if (call <= SHMCTL) {
 		switch (call) {
@@ -507,7 +507,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 		default:
 			err = -ENOSYS;
 			goto out;
-		};
+		}
 	} else {
 		err = -ENOSYS;
 	}
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 2b8d54b..1db6b18 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -708,7 +708,7 @@ static void sparc64_timer_setup(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_UNUSED:
 		WARN_ON(1);
 		break;
-	};
+	}
 }
 
 static struct clock_event_device sparc64_clockevent = {
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 1ed547b..0cbdaa4 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -1804,7 +1804,7 @@ static const char *sun4v_err_type_to_str(u32 type)
 		return "warning resumable";
 	default:
 		return "unknown";
-	};
+	}
 }
 
 static void sun4v_log_error(struct pt_regs *regs, struct sun4v_error_entry *ent, int cpu, const char *pfx, atomic_t *ocnt)
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index c752c4c..b2b019e 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -211,7 +211,7 @@ static inline int do_int_store(int reg_num, int size, unsigned long *dst_addr,
 		default:
 			BUG();
 			break;
-		};
+		}
 	}
 	return __do_int_store(dst_addr, size, src_val, asi);
 }
@@ -328,7 +328,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 		case ASI_SNFL:
 			asi &= ~0x08;
 			break;
-		};
+		}
 		switch (dir) {
 		case load:
 			reg_addr = fetch_reg_addr(((insn>>25)&0x1f), regs);
@@ -351,7 +351,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 				default:
 					BUG();
 					break;
-				};
+				}
 				*reg_addr = val_in;
 			}
 			break;
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
index 8f982b7..75b09d4 100644
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -176,7 +176,7 @@ static unsigned long index_to_estar_mode(unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 }
 
 static unsigned long index_to_divisor(unsigned int index)
@@ -199,7 +199,7 @@ static unsigned long index_to_divisor(unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 }
 
 static unsigned long estar_to_divisor(unsigned long estar)
@@ -224,7 +224,7 @@ static unsigned long estar_to_divisor(unsigned long estar)
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	return ret;
 }
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
index f35d1e7..4d8ea66 100644
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -71,7 +71,7 @@ static unsigned long get_current_freq(unsigned int cpu, unsigned long safari_cfg
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	return ret;
 }
@@ -125,7 +125,7 @@ static void us3_set_cpu_divider_index(unsigned int cpu, unsigned int index)
 
 	default:
 		BUG();
-	};
+	}
 
 	reg = read_safari_cfg();
 
diff --git a/arch/sparc/kernel/viohs.c b/arch/sparc/kernel/viohs.c
index aa6ac70..29348ea 100644
--- a/arch/sparc/kernel/viohs.c
+++ b/arch/sparc/kernel/viohs.c
@@ -363,7 +363,7 @@ static int process_ver(struct vio_driver_state *vio, struct vio_ver_info *pkt)
 
 	default:
 		return handshake_failure(vio);
-	};
+	}
 }
 
 static int process_attr(struct vio_driver_state *vio, void *pkt)
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 9dfd2eb..3635771 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -334,7 +334,7 @@ static void edge(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		left = edge32_tab_l[(rs1 >> 2) & 0x1].left;
 		right = edge32_tab_l[(rs2 >> 2) & 0x1].right;
 		break;
-	};
+	}
 
 	if ((rs1 & ~0x7UL) == (rs2 & ~0x7UL))
 		rd_val = right & left;
@@ -360,7 +360,7 @@ static void edge(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		tstate = regs->tstate & ~(TSTATE_XCC | TSTATE_ICC);
 		regs->tstate = tstate | (ccr << 32UL);
 	}
-	};
+	}
 }
 
 static void array(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -392,7 +392,7 @@ static void array(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 
 	case ARRAY32_OPF:
 		rd_val <<= 2;
-	};
+	}
 
 	store_reg(regs, rd_val, RD(insn));
 }
@@ -577,7 +577,7 @@ static void pformat(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		*fpd_regaddr(f, RD(insn)) = rd_val;
 		break;
 	}
-	};
+	}
 }
 
 static void pmul(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -693,7 +693,7 @@ static void pmul(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 		*fpd_regaddr(f, RD(insn)) = rd_val;
 		break;
 	}
-	};
+	}
 }
 
 static void pcmp(struct pt_regs *regs, unsigned int insn, unsigned int opf)
@@ -786,7 +786,7 @@ static void pcmp(struct pt_regs *regs, unsigned int insn, unsigned int opf)
 				rd_val |= 1 << i;
 		}
 		break;
-	};
+	}
 
 	maybe_flush_windows(0, 0, RD(insn), 0);
 	store_reg(regs, rd_val, RD(insn));
@@ -885,7 +885,7 @@ int vis_emul(struct pt_regs *regs, unsigned int insn)
 	case BSHUFFLE_OPF:
 		bshuffle(regs, insn);
 		break;
-	};
+	}
 
 	regs->tpc = regs->tnpc;
 	regs->tnpc += 4;
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index b10ac4d..7543ddb 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -135,7 +135,7 @@ asmlinkage int lookup_fault(unsigned long pc, unsigned long ret_pc,
 
 	default:
 		break;
-	};
+	}
 
 	memset(&regs, 0, sizeof (regs));
 	regs.pc = pc;
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 4c31e2b..4cd4f29 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -342,7 +342,7 @@ void __init paging_init(void)
 		prom_printf("paging_init: sparc_cpu_model = %d\n", sparc_cpu_model);
 		prom_printf("paging_init: Halting...\n");
 		prom_halt();
-	};
+	}
 
 	/* Initialize the protection map with non-constant, MMU dependent values. */
 	protection_map[0] = PAGE_NONE;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2f6ae1d..1f31812 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1625,7 +1625,7 @@ static void __init sun4v_ktsb_init(void)
 		ktsb_descr[0].pgsz_idx = HV_PGSZ_IDX_4MB;
 		ktsb_descr[0].pgsz_mask = HV_PGSZ_MASK_4MB;
 		break;
-	};
+	}
 
 	ktsb_descr[0].assoc = 1;
 	ktsb_descr[0].num_ttes = KERNEL_TSB_NENTRIES;
@@ -2266,7 +2266,7 @@ unsigned long pte_sz_bits(unsigned long sz)
 			return _PAGE_SZ512K_4V;
 		case 4 * 1024 * 1024:
 			return _PAGE_SZ4MB_4V;
-		};
+		}
 	} else {
 		switch (sz) {
 		case 8 * 1024:
@@ -2278,7 +2278,7 @@ unsigned long pte_sz_bits(unsigned long sz)
 			return _PAGE_SZ512K_4U;
 		case 4 * 1024 * 1024:
 			return _PAGE_SZ4MB_4U;
-		};
+		}
 	}
 }
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index fe09fd8..cbef74e 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1665,7 +1665,7 @@ static void __init init_swift(void)
 	default:
 		srmmu_modtype = Swift_ok;
 		break;
-	};
+	}
 
 	BTFIXUPSET_CALL(flush_cache_all, swift_flush_cache_all, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(flush_cache_mm, swift_flush_cache_mm, BTFIXUPCALL_NORM);
@@ -2069,7 +2069,7 @@ static void __init get_srmmu_type(void)
 			/* Some other Cypress revision, assume a 605. */
 			init_cypress_605(mod_rev);
 			break;
-		};
+		}
 		return;
 	}
 	
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index a2350b5..1cf4f19 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -318,7 +318,7 @@ void __init sun4c_probe_vac(void)
 		prom_printf("probe_vac: Didn't expect vac-linesize of %d, halting\n",
 			    sun4c_vacinfo.linesize);
 		prom_halt();
-	};
+	}
 
 	sun4c_flush_all();
 	sun4c_enable_vac();
@@ -364,7 +364,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Unhandled number of segmaps: %d\n",
 				    num_segmaps);
 			prom_halt();
-	};
+	}
 	switch (num_contexts) {
 		case 8:
 			/* Default, nothing to do. */
@@ -377,7 +377,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Unhandled number of contexts: %d\n",
 				    num_contexts);
 			prom_halt();
-	};
+	}
 
 	if (sun4c_vacinfo.do_hwflushes != 0) {
 		PATCH_INSN(vac_hwflush_patch1_on, vac_hwflush_patch1);
@@ -394,7 +394,7 @@ static void __init patch_kernel_fault_handler(void)
 			prom_printf("Impossible VAC linesize %d, halting...\n",
 				    sun4c_vacinfo.linesize);
 			prom_halt();
-		};
+		}
 	}
 }
 
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 101d7c8..91e057b 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -179,7 +179,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 		printk(KERN_ERR "TSB[%s:%d]: Impossible TSB size %lu, killing process.\n",
 		       current->comm, current->pid, tsb_bytes);
 		do_exit(SIGSEGV);
-	};
+	}
 	tte |= pte_sz_bits(page_sz);
 
 	if (tlb_type == cheetah_plus || tlb_type == hypervisor) {
@@ -214,7 +214,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 #endif
 		default:
 			BUG();
-		};
+		}
 		hp->assoc = 1;
 		hp->num_ttes = tsb_bytes / 16;
 		hp->ctx_idx = 0;
@@ -229,7 +229,7 @@ static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsign
 #endif
 		default:
 			BUG();
-		};
+		}
 		hp->tsb_base = tsb_paddr;
 		hp->resv = 0;
 	}
diff --git a/arch/sparc/prom/console_32.c b/arch/sparc/prom/console_32.c
index b05e3db..a00f47b 100644
--- a/arch/sparc/prom/console_32.c
+++ b/arch/sparc/prom/console_32.c
@@ -38,7 +38,7 @@ static int prom_nbputchar(const char *buf)
 		break;
 	default:
 		break;
-	};
+	}
 	restore_current();
 	spin_unlock_irqrestore(&prom_lock, flags);
 	return i; /* Ugh, we could spin forever on unsupported proms ;( */
diff --git a/arch/sparc/prom/init_32.c b/arch/sparc/prom/init_32.c
index 0a601b3..26c64ce 100644
--- a/arch/sparc/prom/init_32.c
+++ b/arch/sparc/prom/init_32.c
@@ -53,7 +53,7 @@ void __init prom_init(struct linux_romvec *rp)
 			    romvec->pv_romvers);
 		prom_halt();
 		break;
-	};
+	}
 
 	prom_rev = romvec->pv_plugin_revision;
 	prom_prev = romvec->pv_printrev;
diff --git a/arch/sparc/prom/mp.c b/arch/sparc/prom/mp.c
index 97c44c9..0da8256 100644
--- a/arch/sparc/prom/mp.c
+++ b/arch/sparc/prom/mp.c
@@ -35,7 +35,7 @@ prom_startcpu(int cpunode, struct linux_prom_registers *ctable_reg, int ctx, cha
 	case PROM_V3:
 		ret = (*(romvec->v3_cpustart))(cpunode, (int) ctable_reg, ctx, pc);
 		break;
-	};
+	}
 	restore_current();
 	spin_unlock_irqrestore(&prom_lock, flags);
 
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index cf48cdd..1cc33ef 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -878,7 +878,7 @@ static int __cpuinit longhaul_cpu_init(struct cpufreq_policy *policy)
 	case TYPE_POWERSAVER:
 		printk(KERN_CONT "Powersaver supported.\n");
 		break;
-	};
+	}
 
 	/* Doesn't hurt */
 	longhaul_setup_southbridge();
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
index a94ec6b..d561581 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -242,7 +242,7 @@ unsigned int speedstep_get_frequency(enum speedstep_processor processor)
 		return pentium3_get_frequency(processor);
 	default:
 		return 0;
-	};
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(speedstep_get_frequency);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5b4cdcb..4c29206 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3265,7 +3265,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 				vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
 				return 0;
 			}
-		};
+		}
 		break;
 	case 2: /* clts */
 		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 940d70c..90b89fd 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -437,7 +437,7 @@ int af_alg_wait_for_completion(int err, struct af_alg_completion *completion)
 		INIT_COMPLETION(completion->completion);
 		err = completion->err;
 		break;
-	};
+	}
 
 	return err;
 }
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index e0b58b8..8bcc271 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1687,7 +1687,7 @@ static int __init bfin_atapi_init(void)
 		break;
 	default:
 		bfin_port_info[0].udma_mask = ATA_UDMA5;
-	};
+	}
 
 	return platform_driver_register(&bfin_atapi_driver);
 }
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 049650d..79f5f50 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1081,7 +1081,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 					RC_FLAGS_BFPS_BFP * bfp |
 					RC_FLAGS_RXBM_PSB, 0, 0);
 			break;
-		};
+		}
 		if (IS_FS50 (dev)) {
 			submit_command (dev, &dev->hp_txq, 
 					QE_CMD_REG_WR | QE_CMD_IMM_INQ,
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 24761e1..30cb1ab 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2582,7 +2582,7 @@ static int hrz_getsockopt (struct atm_vcc * atm_vcc, int level, int optname,
 	default:
 	  return -ENOPROTOOPT;
 	  break;
-      };
+      }
       break;
   }
   return -EINVAL;
@@ -2602,7 +2602,7 @@ static int hrz_setsockopt (struct atm_vcc * atm_vcc, int level, int optname,
 	default:
 	  return -ENOPROTOOPT;
 	  break;
-      };
+      }
       break;
   }
   return -EINVAL;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 5c0c8be..7c05503 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -727,7 +727,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->rq_state |= (RQ_NET_OK|RQ_NET_DONE);
 		_req_may_be_done_not_susp(req, m);
 		break;
-	};
+	}
 
 	return rv;
 }
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 48e8fee..e1bd454 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -519,7 +519,7 @@ static int generic_request(struct vdc_port *port, u8 op, void *buf, int len)
 	case VD_OP_SET_EFI:
 		return -EOPNOTSUPP;
 		break;
-	};
+	}
 
 	map_perm |= LDC_MAP_SHADOW | LDC_MAP_DIRECT | LDC_MAP_IO;
 
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 005919a..8bbe6d0 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -495,7 +495,7 @@ static int bfusb_send_frame(struct sk_buff *skb)
 	case HCI_SCODATA_PKT:
 		hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index 4104b7f..9666de5 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -679,7 +679,7 @@ static int bluecard_hci_send_frame(struct sk_buff *skb)
 	case HCI_SCODATA_PKT:
 		hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 0c8a655..03a2888 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -440,7 +440,7 @@ static int bt3c_hci_send_frame(struct sk_buff *skb)
 	case HCI_SCODATA_PKT:
 		hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index f8a0708..a14687d 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -447,7 +447,7 @@ static int btuart_hci_send_frame(struct sk_buff *skb)
 	case HCI_SCODATA_PKT:
 		hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 26ee0cf..5dfe199 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -416,7 +416,7 @@ static int dtl1_hci_send_frame(struct sk_buff *skb)
 		break;
 	default:
 		return -EILSEQ;
-	};
+	}
 
 	nsh.zero = 0;
 	nsh.len = skb->len;
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 48ad2a7..3e55bbe 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -500,7 +500,7 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file * file,
 	default:
 		err = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
-	};
+	}
 
 	return err;
 }
diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 38595e7..e64a2c5 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -481,7 +481,7 @@ static int ll_recv(struct hci_uart *hu, void *data, int count)
 			hu->hdev->stat.err_rx++;
 			ptr++; count--;
 			continue;
-		};
+		}
 
 		ptr++; count--;
 
diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 67c180c..4c8ec8d 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -159,7 +159,7 @@ static inline ssize_t vhci_put_user(struct vhci_data *data,
 	case HCI_SCODATA_PKT:
 		data->hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	return total;
 }
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index dfa8b30..cb0ad89e 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -411,7 +411,7 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 		case RTC_IRQP_READ:
 		case RTC_IRQP_SET:
 			return -EINVAL;
-		};
+		}
 	}
 #endif
 
diff --git a/drivers/infiniband/hw/amso1100/c2_ae.c b/drivers/infiniband/hw/amso1100/c2_ae.c
index 62af742..89d0b7e 100644
--- a/drivers/infiniband/hw/amso1100/c2_ae.c
+++ b/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -141,7 +141,7 @@ static const char *to_qp_state_str(int state)
 		return "C2_QP_STATE_ERROR";
 	default:
 		return "<invalid QP state>";
-	};
+	}
 }
 
 void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 76785c6..428bea1 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -357,7 +357,7 @@ static int mthca_eq_int(struct mthca_dev *dev, struct mthca_eq *eq)
 			mthca_warn(dev, "Unhandled event %02x(%02x) on EQ %d\n",
 				   eqe->type, eqe->subtype, eq->eqn);
 			break;
-		};
+		}
 
 		set_eqe_hw(eqe);
 		++eq->cons_index;
diff --git a/drivers/isdn/hisax/st5481.h b/drivers/isdn/hisax/st5481.h
index 64f78a8..c88d1bc 100644
--- a/drivers/isdn/hisax/st5481.h
+++ b/drivers/isdn/hisax/st5481.h
@@ -513,7 +513,7 @@ static inline const char *ST5481_CMD_string(int evt)
 	case ST5481_CMD_AR10: return "AR10";
 	case ST5481_CMD_ARL: return "ARL";
 	case ST5481_CMD_PDN: return "PDN";
-	};
+	}
 	
 	sprintf(s,"0x%x",evt);
 	return s;
diff --git a/drivers/isdn/pcbit/drv.c b/drivers/isdn/pcbit/drv.c
index 1507d2e..a716d94 100644
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -284,7 +284,7 @@ static int pcbit_command(isdn_ctrl* ctl)
 	default:
 		printk(KERN_DEBUG "pcbit_command: unknown command\n");
 		break;
-	};
+	}
 
 	return 0;
 }
@@ -968,7 +968,7 @@ static int pcbit_ioctl(isdn_ctrl* ctl)
 	default:
 		printk("error: unknown ioctl\n");
 		break;
-	};
+	}
 	return 0;
 }
 
diff --git a/drivers/isdn/pcbit/layer2.h b/drivers/isdn/pcbit/layer2.h
index 2ac295e..d36978e 100644
--- a/drivers/isdn/pcbit/layer2.h
+++ b/drivers/isdn/pcbit/layer2.h
@@ -196,7 +196,7 @@ static __inline__ void pcbit_writew(struct pcbit_dev *dev, unsigned short dt)
     writew(dt, dev->writeptr);
     dev->writeptr += 2;
     break;
-  };
+  }
 }
 
 static __inline__ void memcpy_topcbit(struct pcbit_dev * dev, u_char * data, 
@@ -253,7 +253,7 @@ static __inline__ unsigned short pcbit_readw(struct pcbit_dev *dev)
     val = readw(dev->readptr);
     dev->readptr += 2;
     break;
-  };
+  }
   return val;
 }
 
diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index 5466d47..d9062c8 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -275,7 +275,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	case TDA18271HDC2:
 		regs[R_ID]   = 0x84;
 		break;
-	};
+	}
 
 	regs[R_TM]   = 0x08;
 	regs[R_PL]   = 0x80;
@@ -300,7 +300,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	case TDA18271HDC2:
 		regs[R_EB1]  = 0xfc;
 		break;
-	};
+	}
 
 	regs[R_EB2]  = 0x01;
 	regs[R_EB3]  = 0x84;
@@ -320,7 +320,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	case TDA18271HDC2:
 		regs[R_EB12] = 0x33;
 		break;
-	};
+	}
 
 	regs[R_EB13] = 0xc1;
 	regs[R_EB14] = 0x00;
@@ -335,7 +335,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	case TDA18271HDC2:
 		regs[R_EB18] = 0x8c;
 		break;
-	};
+	}
 
 	regs[R_EB19] = 0x00;
 	regs[R_EB20] = 0x20;
@@ -347,7 +347,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	case TDA18271HDC2:
 		regs[R_EB21] = 0xb3;
 		break;
-	};
+	}
 
 	regs[R_EB22] = 0x48;
 	regs[R_EB23] = 0xb0;
diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 16fba6b..73e4d2a 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1127,7 +1127,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 		break;
 	default:
 		tuner_err("error: bandwidth not supported.\n");
-	};
+	}
 
 	/*
 	  Selects between D2633 or D2620 firmware.
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 48e48e8..a57e714 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -647,7 +647,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_PID Success !");
 	default:
 		result = -EOPNOTSUPP;
-	};
+	}
  free_mem_and_exit:
 	kfree (p_ca_message);
 	kfree (p_ca_slot_info);
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index cad6634..449f524 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1884,7 +1884,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		fepriv->tune_mode_flags = (unsigned long) parg;
 		err = 0;
 		break;
-	};
+	}
 
 	if (fe->dvb->fe_ioctl_override) {
 		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 100ebc3..8620c07 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -900,7 +900,7 @@ static int af9015_read_config(struct usb_device *udev)
 		case 3:
 			af9015_af9013_config[i].adc_clock = 25000;
 			break;
-		};
+		}
 		deb_info("%s: [%d] xtal:%d set adc_clock:%d\n", __func__, i,
 			val, af9015_af9013_config[i].adc_clock);
 
@@ -961,7 +961,7 @@ static int af9015_read_config(struct usb_device *udev)
 		default:
 			warn("tuner id:%d not supported, please report!", val);
 			return -ENODEV;
-		};
+		}
 
 		af9015_af9013_config[i].tuner = val;
 		deb_info("%s: [%d] tuner id:%d\n", __func__, i, val);
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 345311c..a1fe39d 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -176,7 +176,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 		err("invalid gpio:%d\n", gpio);
 		ret = -EINVAL;
 		goto error;
-	};
+	}
 
 	switch (gpio) {
 	case 0:
@@ -188,7 +188,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	default:
 		pos = 4;
 		break;
-	};
+	}
 
 	ret = af9013_write_reg_bits(state, addr, pos, 4, gpioval);
 
@@ -448,7 +448,7 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 	default:
 		deb_info("%s: invalid hierarchy_information\n", __func__);
 		*auto_mode = 1;
-	};
+	}
 
 	switch (params->constellation) {
 	case QAM_AUTO:
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index cf5e576..96c23d1 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -525,7 +525,7 @@ static int bcm3510_set_frontend(struct dvb_frontend* fe,
 			cmd.ACQUIRE1.IF_FREQ = 0x0;
 		default:
 			return -EINVAL;
-	};
+	}
 	cmd.ACQUIRE0.OFFSET = 0;
 	cmd.ACQUIRE0.NTSCSWEEP = 1;
 	cmd.ACQUIRE0.FA = 1;
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 20f781f..98298e3 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -378,7 +378,7 @@ static int cx24110_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t voltag
 		return cx24110_writereg(state,0x76,(cx24110_readreg(state,0x76)&0x3b)|0x40);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int cx24110_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index fad6a99..8d8084c 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -754,7 +754,7 @@ static int cx24123_set_voltage(struct dvb_frontend *fe,
 		return 0;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/isl6405.c b/drivers/media/dvb/frontends/isl6405.c
index 33d33f4..0c642a5 100644
--- a/drivers/media/dvb/frontends/isl6405.c
+++ b/drivers/media/dvb/frontends/isl6405.c
@@ -77,7 +77,7 @@ static int isl6405_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage
 			break;
 		default:
 			return -EINVAL;
-		};
+		}
 	}
 	isl6405->config |= isl6405->override_or;
 	isl6405->config &= isl6405->override_and;
diff --git a/drivers/media/dvb/frontends/isl6421.c b/drivers/media/dvb/frontends/isl6421.c
index 684c8ec..0cb3f0f 100644
--- a/drivers/media/dvb/frontends/isl6421.c
+++ b/drivers/media/dvb/frontends/isl6421.c
@@ -63,7 +63,7 @@ static int isl6421_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	isl6421->config |= isl6421->override_or;
 	isl6421->config &= isl6421->override_and;
diff --git a/drivers/media/dvb/frontends/lnbp21.c b/drivers/media/dvb/frontends/lnbp21.c
index 1343725..f3ba7b5 100644
--- a/drivers/media/dvb/frontends/lnbp21.c
+++ b/drivers/media/dvb/frontends/lnbp21.c
@@ -65,7 +65,7 @@ static int lnbp21_set_voltage(struct dvb_frontend *fe,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	lnbp21->config |= lnbp21->override_or;
 	lnbp21->config &= lnbp21->override_and;
@@ -108,7 +108,7 @@ static int lnbp21_set_tone(struct dvb_frontend *fe,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	lnbp21->config |= lnbp21->override_or;
 	lnbp21->config &= lnbp21->override_and;
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index 9d943dc..1149f0e 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -472,7 +472,7 @@ static int si21xx_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int si21xx_init(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index b85eb60..21851c1 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -188,7 +188,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->u.ofdm.hierarchy_information) {
 	case HIERARCHY_NONE:
@@ -207,7 +207,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->u.ofdm.code_rate_HP) {
 	case FEC_1_2:
@@ -229,7 +229,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (known_parameters)
 		*reg0xc05 |= (2 << 1);	/* use specified parameters */
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 4a7c3d8..f551147 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -229,7 +229,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->u.ofdm.hierarchy_information) {
 	case HIERARCHY_NONE:
@@ -248,7 +248,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->u.ofdm.code_rate_HP) {
 	case FEC_1_2:
@@ -270,7 +270,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (known_parameters)
 		*reg0xc05 |= (2 << 1);	/* use specified parameters */
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index a971613..ca9d71f 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -386,7 +386,7 @@ static int stv0299_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t voltag
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (state->config->op0_off)
 		reg0x0c &= ~0x10;
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 6fe89a3..0134e3e 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -189,7 +189,7 @@ static int tda8083_set_tone (struct tda8083_state* state, fe_sec_tone_mode_t ton
 		return tda8083_writereg (state, 0x29, 0x80);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int tda8083_set_voltage (struct tda8083_state* state, fe_sec_voltage_t voltage)
@@ -201,7 +201,7 @@ static int tda8083_set_voltage (struct tda8083_state* state, fe_sec_voltage_t vo
 		return tda8083_writereg (state, 0x20, 0x11);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int tda8083_send_diseqc_burst (struct tda8083_state* state, fe_sec_mini_cmd_t burst)
@@ -215,7 +215,7 @@ static int tda8083_send_diseqc_burst (struct tda8083_state* state, fe_sec_mini_c
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	tda8083_wait_diseqc_fifo (state, 100);
 
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 38ae6cd..a1df6b4 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -219,7 +219,7 @@ static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
 	/* 2:  50 kHz */
 	default:
 		spacing = 0.050 * FREQ_MUL; break;
-	};
+	}
 
 	/* Bottom of Band (MHz) */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -232,7 +232,7 @@ static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
 	/* 2: 76   -  90 MHz (Japan) */
 	case 2:
 		band_bottom = 76   * FREQ_MUL; break;
-	};
+	}
 
 	/* read channel */
 	retval = si470x_get_register(radio, READCHAN);
@@ -264,7 +264,7 @@ int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
 	/* 2:  50 kHz */
 	default:
 		spacing = 0.050 * FREQ_MUL; break;
-	};
+	}
 
 	/* Bottom of Band (MHz) */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -277,7 +277,7 @@ int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
 	/* 2: 76   -  90 MHz (Japan) */
 	case 2:
 		band_bottom = 76   * FREQ_MUL; break;
-	};
+	}
 
 	/* Chan = [ Freq (Mhz) - Bottom of Band (MHz) ] / Spacing (kHz) */
 	chan = (freq - band_bottom) / spacing;
@@ -707,7 +707,7 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 		tuner->rangelow  =  76   * FREQ_MUL;
 		tuner->rangehigh =  90   * FREQ_MUL;
 		break;
-	};
+	}
 
 	/* stereo indicator == stereo (instead of mono) */
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_ST) == 0)
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 4ce541a..a0c48ea 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -312,7 +312,7 @@ static void si470x_i2c_interrupt_work(struct work_struct *work)
 					READCHAN_BLERD) >> 10;
 			rds = radio->registers[RDSD];
 			break;
-		};
+		}
 
 		/* Fill the V4L2 RDS buffer */
 		put_unaligned_le16(rds, &tmpbuf);
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 392e84f..884a0e5 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -460,7 +460,7 @@ static void si470x_int_in_callback(struct urb *urb)
 						READCHAN_BLERD) >> 10;
 				rds = radio->registers[RDSD];
 				break;
-			};
+			}
 
 			/* Fill the V4L2 RDS buffer */
 			put_unaligned_le16(rds, &tmpbuf);
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 0fab6f8..abab20e 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1008,7 +1008,7 @@ static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
 
 	default:
 		rval = -EINVAL;
-	};
+	}
 
 	return rval;
 }
@@ -1080,7 +1080,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 exit:
 	return rval;
@@ -1129,7 +1129,7 @@ static int si4713_write_econtrol_tune(struct si4713_device *sdev,
 	default:
 		rval = -EINVAL;
 		goto unlock;
-	};
+	}
 
 	if (sdev->power_state)
 		rval = si4713_tx_tune_power(sdev, power, antcap);
@@ -1419,7 +1419,7 @@ static int si4713_read_econtrol_string(struct si4713_device *sdev,
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 exit:
 	return rval;
@@ -1472,7 +1472,7 @@ static int si4713_read_econtrol_tune(struct si4713_device *sdev,
 		break;
 	default:
 		rval = -EINVAL;
-	};
+	}
 
 unlock:
 	mutex_unlock(&sdev->mutex);
@@ -1697,7 +1697,7 @@ static int si4713_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 	return rval;
 }
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 35796e0..172b7f0 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -578,7 +578,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		cx25840_write4(client, 0x114, 0x01bf0c9e);
 		cx25840_write4(client, 0x110, 0x000a030c);
 		break;
-	};
+	}
 
 	/* ADC2 input select */
 	cx25840_write(client, 0x102, 0x10);
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 7b8c9d3..cb2cb3c 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -859,7 +859,7 @@ static int samsung_smt_7020_set_voltage(struct dvb_frontend *fe,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return (i2c_transfer(&dev->core->i2c_adap, &msg, 1) == 1) ? 0 : -EIO;
 }
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/video/cx88/cx88-tvaudio.c
index 770ec05..424fd97 100644
--- a/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/drivers/media/video/cx88/cx88-tvaudio.c
@@ -373,7 +373,7 @@ static void set_audio_standard_NICAM(struct cx88_core *core, u32 mode)
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_default);
 		break;
-	};
+	}
 
 	mode |= EN_DMTRX_LR | EN_DMTRX_BYPASS;
 	set_audio_finish(core, mode);
@@ -639,7 +639,7 @@ static void set_audio_standard_A2(struct cx88_core *core, u32 mode)
 		dprintk("%s Warning: wrong value\n", __func__);
 		return;
 		break;
-	};
+	}
 
 	mode |= EN_FMRADIO_EN_RDS | EN_DMTRX_SUMDIFF;
 	set_audio_finish(core, mode);
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 5ff9d14..a5a5497 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -824,7 +824,7 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 	case 13:
 		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
 		break;
-	};
+	}
 
 	if (pipe->input)
 		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
@@ -980,7 +980,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	case 12:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
 		break;
-	};
+	}
 
 	if (syncif->fldmode)
 		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 53d88a2..aebf9f6 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -442,7 +442,7 @@ static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_565;
 		break;
-	};
+	}
 }
 
 /* Setup registers according to resolution and color encoding */
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 776ba2d..ce234dd 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1204,7 +1204,7 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 		break;
 	default:
 		/* nothing */;
-	};
+	}
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
 		dev->ctl_bright = c->value;
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 19621ed..ab112c5 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -81,7 +81,7 @@ static int tea6415c_s_routing(struct v4l2_subdev *sd,
 	case 13:
 		byte = 0x28;
 		break;
-	};
+	}
 
 	switch (i) {
 	case 5:
@@ -108,7 +108,7 @@ static int tea6415c_s_routing(struct v4l2_subdev *sd,
 	case 11:
 		byte |= 0x07;
 		break;
-	};
+	}
 
 	ret = i2c_smbus_write_byte(client, byte);
 	if (ret) {
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 57b42bf..505331e 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -281,7 +281,7 @@ static const char *mspro_block_attr_name(unsigned char tag)
 		return "attr_devinfo";
 	default:
 		return NULL;
-	};
+	}
 }
 
 typedef ssize_t (*sysfs_show_t)(struct device *dev,
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index d89d925..82f61fa 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -754,7 +754,7 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 				      clock_delay);
 		host->ifmode = value;
 		break;
-	};
+	}
 	return 0;
 }
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 03f71a4..60d3cc2 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -532,7 +532,7 @@ static int tifm_ms_set_param(struct memstick_host *msh,
 		} else
 			return -EINVAL;
 		break;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index 93d5fdf..09f4809 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -147,7 +147,7 @@ static void dbg_chgconf(int por, char *buf, size_t len, u8 chgconfig)
 		case 2:		p = 75; break;
 		case 1:		p = 50; break;
 		default:	p = 25; break;
-		}; p; }),
+		} p; }),
 		(chgconfig & TPS_VBUS_CHARGING)
 			? ((chgconfig & TPS_VBUS_500MA) ? 500 : 100)
 			: 0,
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 486117f..71e3502 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -347,7 +347,7 @@ void st_int_recv(void *disc_data,
 			st_gdata->rx_state = ST_W4_HEADER;
 			st_gdata->rx_count = st_gdata->list[type]->hdr_len;
 			pr_debug("rx_count %ld\n", st_gdata->rx_count);
-		};
+		}
 		ptr++;
 		count--;
 	}
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 0076c74..ce7edc7 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -297,7 +297,7 @@ static void mmc_davinci_start_command(struct mmc_davinci_host *host,
 		default:
 			s = ", (R? response)";
 			break;
-		}; s; }));
+		} s; }));
 	host->cmd = cmd;
 
 	switch (mmc_resp_type(cmd)) {
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 7fca0a3..e31b625 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -810,7 +810,7 @@ static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 			cmd->error = -EINVAL;
 
 			goto done;
-		};
+		}
 	}
 
 	/*
diff --git a/drivers/net/enic/enic_main.c b/drivers/net/enic/enic_main.c
index 9a3a027..7fe45af 100644
--- a/drivers/net/enic/enic_main.c
+++ b/drivers/net/enic/enic_main.c
@@ -1618,7 +1618,7 @@ static void enic_notify_timer_start(struct enic *enic)
 	default:
 		/* Using intr for notification for INTx/MSI-X */
 		break;
-	};
+	}
 }
 
 /* rtnl lock is held, process context */
diff --git a/drivers/net/irda/via-ircc.h b/drivers/net/irda/via-ircc.h
index c6f5848..a1282e9 100644
--- a/drivers/net/irda/via-ircc.h
+++ b/drivers/net/irda/via-ircc.h
@@ -210,7 +210,7 @@ static void DisableDmaChannel(unsigned int channel)
 		break;
 	default:
 		break;
-	};			//Switch
+	}			//Switch
 }
 
 static unsigned char ReadLPCReg(int iRegNum)
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index 9ece1fd..b6c296f 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -538,7 +538,7 @@ static void veth_handle_ack(struct veth_lpevent *event)
 	default:
 		veth_error("Unknown ack type %d from LPAR %d.\n",
 				event->base_event.xSubtype, rlp);
-	};
+	}
 }
 
 static void veth_handle_int(struct veth_lpevent *event)
@@ -584,7 +584,7 @@ static void veth_handle_int(struct veth_lpevent *event)
 	default:
 		veth_error("Unknown interrupt type %d from LPAR %d.\n",
 				event->base_event.xSubtype, rlp);
-	};
+	}
 }
 
 static void veth_handle_event(struct HvLpEvent *event)
diff --git a/drivers/net/ixgbe/ixgbe_82599.c b/drivers/net/ixgbe/ixgbe_82599.c
index 00aeba3..4492f41 100644
--- a/drivers/net/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ixgbe/ixgbe_82599.c
@@ -1147,7 +1147,7 @@ s32 ixgbe_init_fdir_signature_82599(struct ixgbe_hw *hw, u32 pballoc)
 	default:
 		/* bad value */
 		return IXGBE_ERR_CONFIG;
-	};
+	}
 
 	/* Move the flexible bytes to use the ethertype - shift 6 words */
 	fdirctrl |= (0x6 << IXGBE_FDIRCTRL_FLEX_SHIFT);
@@ -1235,7 +1235,7 @@ s32 ixgbe_init_fdir_perfect_82599(struct ixgbe_hw *hw, u32 pballoc)
 	default:
 		/* bad value */
 		return IXGBE_ERR_CONFIG;
-	};
+	}
 
 	/* Turn perfect match filtering on */
 	fdirctrl |= IXGBE_FDIRCTRL_PERFECT_MATCH;
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index a935426..7a6f810 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -2825,7 +2825,7 @@ static int gem_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			rc = 0;
 		}
 		break;
-	};
+	}
 
 	spin_lock_irqsave(&gp->lock, flags);
 	gem_put_cell(gp);
diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index 4786497..e896ad0 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -177,7 +177,7 @@ static char __devinit *adapter_def(char type)
 	case 0xD: return "16/4 Adapter/A (short) | 16/4 ISA-16 Adapter";
 	case 0xC: return "Auto 16/4 Adapter";
 	default: return "adapter (unknown type)";
-	};
+	}
 };
 
 #define TRC_INIT 0x01		/*  Trace initialization & PROBEs */
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f5e9ac0..2c435c5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -655,7 +655,7 @@ static __inline__ ssize_t tun_get_user(struct tun_struct *tun,
 	case TUN_TAP_DEV:
 		skb->protocol = eth_type_trans(skb, tun->dev);
 		break;
-	};
+	}
 
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57eb5b6..ed17073 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4066,7 +4066,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 #endif
 	default:
 		unsupported = 1;
-	};
+	}
 	if (unsupported) {
 		b43err(dev->wl, "FOUND UNSUPPORTED PHY "
 		       "(Analog %u, Type %u, Revision %u)\n",
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c7fd73e..6499c43 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2974,7 +2974,7 @@ static int b43legacy_phy_versioning(struct b43legacy_wldev *dev)
 		break;
 	default:
 		unsupported = 1;
-	};
+	}
 	if (unsupported) {
 		b43legacyerr(dev->wl, "FOUND UNSUPPORTED PHY "
 		       "(Analog %u, Type %u, Revision %u)\n",
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 769c05c..cd1cb62 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1326,7 +1326,7 @@ static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
 			gf20_rate = gf40_rate = 0x0003;
 		}
 		break;
-	};
+	}
 
 	/* check for STAs not supporting greenfield mode */
 	if (any_sta_nongf)
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index adc3534..67775ba 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -219,7 +219,7 @@ static void rt2800pci_start_queue(struct data_queue *queue)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 static void rt2800pci_kick_queue(struct data_queue *queue)
diff --git a/drivers/nfc/pn544.c b/drivers/nfc/pn544.c
index 724f65d..811b8bd 100644
--- a/drivers/nfc/pn544.c
+++ b/drivers/nfc/pn544.c
@@ -667,7 +667,7 @@ static int pn544_suspend(struct device *dev)
 
 	case PN544_ST_COLD:
 		break;
-	};
+	}
 
 	mutex_unlock(&info->mutex);
 	return r;
@@ -698,7 +698,7 @@ static int pn544_resume(struct device *dev)
 
 	case PN544_ST_FW_READY:
 		break;
-	};
+	}
 
 	mutex_unlock(&info->mutex);
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 27911b5..7360607 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -237,7 +237,7 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 	default:
 		ret = -EINVAL;
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index e1c1ec5..24750a1 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -44,7 +44,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	default:
 		err = -EINVAL;
 		goto error;
-	};
+	}
 
 	err = -EIO;
 	if (cfg_ret != PCIBIOS_SUCCESSFUL)
diff --git a/drivers/pcmcia/db1xxx_ss.c b/drivers/pcmcia/db1xxx_ss.c
index 01757f1..b9b4502 100644
--- a/drivers/pcmcia/db1xxx_ss.c
+++ b/drivers/pcmcia/db1xxx_ss.c
@@ -422,7 +422,7 @@ static int __devinit db1x_pcmcia_socket_probe(struct platform_device *pdev)
 		printk(KERN_INFO "db1xxx-ss: unknown board %d!\n", bid);
 		ret = -ENODEV;
 		goto out0;
-	};
+	}
 
 	/*
 	 * gather resources necessary and optional nice-to-haves to
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 271a590..cde800f 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -801,7 +801,7 @@ static int m8xx_get_status(struct pcmcia_socket *sock, unsigned int *value)
 		case 2:
 			*value |= SS_XVCARD;
 			break;	/* NC. GND - x.xV only */
-		};
+		}
 	}
 
 	pr_debug("m8xx_pcmcia: GetStatus(%d) = %#2.2x\n", lsock, *value);
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 85c1b84..a7d9cfd 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -639,7 +639,7 @@ static int rs5c372_probe(struct i2c_client *client,
 			case rtc_rv5c386:	s = "rv5c386"; break;
 			case rtc_rv5c387a:	s = "rv5c387a"; break;
 			default:		s = "chip"; break;
-			}; s;}),
+			} s;}),
 			rs5c372->time24 ? "24hr" : "am/pm"
 			);
 
diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 8c921fc..ff79c69 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -1514,7 +1514,7 @@ static void ctcmpc_chx_firstio(fsm_instance *fi, int event, void *arg)
 				goto done;
 	default:
 		break;
-	};
+	}
 
 	fsm_newstate(fi, (CHANNEL_DIRECTION(ch->flags) == CTCM_READ)
 		     ? CTC_STATE_RXINIT : CTC_STATE_TXINIT);
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 4561f3b..1e5f387 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -229,7 +229,7 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 		case MSG_SIMPLE_TAG:
 			fcp->fc_pri_ta |= FCP_PTA_SIMPLE;
 			break;
-		};
+		}
 	} else
 		fcp->fc_pri_ta = FCP_PTA_SIMPLE;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index a0e05ef..824dc16 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -204,7 +204,7 @@ static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
 		break;
 	case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
 		zfcp_fsf_link_down_info_eval(req, NULL);
-	};
+	}
 }
 
 static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 740da446..3af13dd 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -150,7 +150,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			regs |= D7S_FLIP;
 		writeb(regs, p->regs);
 		break;
-	};
+	}
 	mutex_unlock(&d7s_mutex);
 
 	return error;
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index be7b4e5..34f6faf 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -353,7 +353,7 @@ static int envctrl_i2c_data_translate(unsigned char data, int translate_type,
 
 	default:
 		break;
-	};
+	}
 
 	return len;
 }
@@ -644,7 +644,7 @@ envctrl_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	default:
 		break;
 
-	};
+	}
 
 	return ret;
 }
@@ -687,7 +687,7 @@ envctrl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
@@ -947,7 +947,7 @@ static void envctrl_init_i2c_child(struct device_node *dp,
 
 		default:
 			break;
-		};
+		}
 	}
 }
 
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 8d6e508..c723a7a 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -223,7 +223,7 @@ static int opromnext(void __user *argp, unsigned int cmd, struct device_node *dp
 		case OPROMSETCUR:
 		default:
 			break;
-		};
+		}
 	} else {
 		/* Sibling of node zero is the root node.  */
 		if (cmd != OPROMNEXT)
@@ -589,7 +589,7 @@ static int openprom_bsd_ioctl(struct file * file,
 	default:
 		err = -EINVAL;
 		break;
-	};
+	}
 	mutex_unlock(&openprom_mutex);
 
 	return err;
@@ -655,7 +655,7 @@ static long openprom_ioctl(struct file * file,
 
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static long openprom_compat_ioctl(struct file *file, unsigned int cmd,
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index fce00ca..8ef2137 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -785,7 +785,7 @@ fail:
 	default:
 		printk(KERN_ERR "Unable to determine Adaptec DMA priority.  Disabling board\n");
 		return -1;
-	};
+	}
 	switch (inquiry_result[1]) {
 	case 0x40:
 		*irq_level = 15;
@@ -808,7 +808,7 @@ fail:
 	default:
 		printk(KERN_ERR "Unable to determine Adaptec IRQ level.  Disabling board\n");
 		return -1;
-	};
+	}
 	*scsi_id = inquiry_result[2] & 7;
 	return 0;
 }
@@ -1004,7 +1004,7 @@ static int __init aha1542_detect(struct scsi_host_template * tpnt)
 		case 10:
 			atbt = 0x03;
 			break;
-		};
+		}
 		setup_dmaspeed[0] = atbt;
 	}
 #endif
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index bb63f1a..6507ff2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -301,7 +301,7 @@ static void fnic_notify_timer_start(struct fnic *fnic)
 	default:
 		/* Using intr for notification for INTx/MSI-X */
 		break;
-	};
+	}
 }
 
 static int fnic_dev_wait(struct vnic_dev *vdev,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b765061..45bc276 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -176,7 +176,7 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 /**
@@ -215,7 +215,7 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 	default:
 		break;
 
-	};
+	}
 }
 
 #else
@@ -459,7 +459,7 @@ static int ibmvfc_set_host_state(struct ibmvfc_host *vhost,
 	default:
 		vhost->state = state;
 		break;
-	};
+	}
 
 	return rc;
 }
@@ -495,7 +495,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 			break;
 		default:
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
@@ -510,7 +510,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 		default:
 			vhost->action = action;
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -521,7 +521,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 	default:
 		vhost->action = action;
 		break;
-	};
+	}
 }
 
 /**
@@ -1593,7 +1593,7 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 	case IBMVFC_ACTIVE:
 		result = 0;
 		break;
-	};
+	}
 
 	return result;
 }
@@ -1653,7 +1653,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 		case MSG_ORDERED_TAG:
 			vfc_cmd->iu.pri_task_attr = IBMVFC_ORDERED_TASK;
 			break;
-		};
+		}
 	}
 
 	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
@@ -1857,7 +1857,7 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 		break;
 	default:
 		return -ENOTSUPP;
-	};
+	}
 
 	if (port_id == -1)
 		return -EINVAL;
@@ -2586,7 +2586,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 			vhost->delay_init = 1;
 			__ibmvfc_reset_host(vhost);
 			break;
-		};
+		}
 
 		break;
 	case IBMVFC_AE_LINK_UP:
@@ -2638,7 +2638,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	default:
 		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
 		break;
-	};
+	}
 }
 
 /**
@@ -3306,7 +3306,7 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 			ibmvfc_get_cmd_error(rsp->status, rsp->error),
 			rsp->status, rsp->error, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3402,7 +3402,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
 			ibmvfc_get_ls_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3473,7 +3473,7 @@ static void ibmvfc_tgt_implicit_logout_done(struct ibmvfc_event *evt)
 	default:
 		tgt_err(tgt, "Implicit Logout failed: rc=0x%02X\n", status);
 		break;
-	};
+	}
 
 	if (vhost->action == IBMVFC_HOST_ACTION_TGT_INIT)
 		ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_plogi);
@@ -3577,7 +3577,7 @@ static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
 			 ibmvfc_get_fc_type(fc_reason), fc_reason,
 			 ibmvfc_get_ls_explain(fc_explain), fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3789,7 +3789,7 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
 			ibmvfc_get_gs_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -4190,7 +4190,7 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_REENABLE:
 	default:
 		break;
-	};
+	}
 
 	return 1;
 }
@@ -4418,7 +4418,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	default:
 		break;
-	};
+	}
 
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0621238..5afcdfd 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1011,7 +1011,7 @@ static void ipr_update_ata_class(struct ipr_resource_entry *res, unsigned int pr
 	default:
 		res->ata_class = ATA_DEV_UNKNOWN;
 		break;
-	};
+	}
 }
 
 /**
@@ -5253,7 +5253,7 @@ static u8 ipr_get_task_attributes(struct scsi_cmnd *scsi_cmd)
 		case MSG_ORDERED_TAG:
 			rc = IPR_FLAGS_LO_ORDERED_TASK;
 			break;
-		};
+		}
 	}
 
 	return rc;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 13f425f..31bef36 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1870,7 +1870,7 @@ static inline int ipr_sdt_is_fmt2(u32 sdt_word)
 	case IPR_SDT_FMT2_BAR5_SEL:
 	case IPR_SDT_FMT2_EXP_ROM_SEL:
 		return 1;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bcf858e..53a4de7 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3187,7 +3187,7 @@ static u8 pmcraid_task_attributes(struct scsi_cmnd *scsi_cmd)
 		case MSG_ORDERED_TAG:
 			rc = TASK_TAG_ORDERED;
 			break;
-		};
+		}
 	}
 
 	return rc;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e2d45c9..71f5f31 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1140,7 +1140,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 37e8eac..a804179 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -494,7 +494,7 @@ void sym_fw_bind_script(struct sym_hcb *np, u32 *start, int len)
 		default:
 			relocs = 0;
 			break;
-		};
+		}
 
 		/*
 		 *  Scriptify:) the opcode.
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index f4f1116..09c2650 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -970,7 +970,7 @@ static int receive_flow_control(struct nozomi *dc)
 		dev_err(&dc->pdev->dev,
 			"ERROR: flow control received for non-existing port\n");
 		return 0;
-	};
+	}
 
 	DBG1("0x%04X->0x%04X", *((u16 *)&dc->port[port].ctrl_dl),
 	   *((u16 *)&ctrl_dl));
@@ -1036,7 +1036,7 @@ static enum ctrl_port_type port2ctrl(enum port_type port,
 		dev_err(&dc->pdev->dev,
 			"ERROR: send flow control " \
 			"received for non-existing port\n");
-	};
+	}
 	return CTRL_ERROR;
 }
 
@@ -1841,7 +1841,7 @@ static int ntty_ioctl(struct tty_struct *tty,
 	default:
 		DBG1("ERR: 0x%08X, %d", cmd, cmd);
 		break;
-	};
+	}
 
 	return rval;
 }
diff --git a/drivers/tty/serial/bfin_5xx.c b/drivers/tty/serial/bfin_5xx.c
index 9b1ff2b..4ffb30c 100644
--- a/drivers/tty/serial/bfin_5xx.c
+++ b/drivers/tty/serial/bfin_5xx.c
@@ -704,7 +704,7 @@ static int bfin_serial_startup(struct uart_port *port)
 		default:
 			uart_dma_ch_rx = uart_dma_ch_tx = 0;
 			break;
-		};
+		}
 
 		if (uart_dma_ch_rx &&
 			request_dma(uart_dma_ch_rx, "BFIN_UART_RX") < 0) {
@@ -784,7 +784,7 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		break;
 	default:
 		break;
-	};
+	}
 #endif
 	free_irq(uart->port.irq, uart);
 	free_irq(uart->port.irq+1, uart);
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index ebff4a1..ca0c4e2 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -838,7 +838,7 @@ ip22zilog_convert_to_zs(struct uart_ip22zilog_port *up, unsigned int cflag,
 		up->curregs[5] |= Tx8;
 		up->parity_mask = 0xff;
 		break;
-	};
+	}
 	up->curregs[4] &= ~0x0c;
 	if (cflag & CSTOPB)
 		up->curregs[4] |= SB2;
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 5b9cde7..9fbab28 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1126,7 +1126,7 @@ static void pmz_convert_to_zs(struct uart_pmac_port *uap, unsigned int cflag,
 		uap->curregs[5] |= Tx8;
 		uap->parity_mask = 0xff;
 		break;
-	};
+	}
 	uap->curregs[4] &= ~(SB_MASK);
 	if (cflag & CSTOPB)
 		uap->curregs[4] |= SB2;
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5fa2a5..833c9b3 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -899,7 +899,7 @@ static int sunsab_console_setup(struct console *con, char *options)
 	case B115200: baud = 115200; break;
 	case B230400: baud = 230400; break;
 	case B460800: baud = 460800; break;
-	};
+	}
 
 	/*
 	 * Temporary fix.
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 92aa545..7757c94 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -522,7 +522,7 @@ static void receive_kbd_ms_chars(struct uart_sunsu_port *up, int is_break)
 				serio_interrupt(&up->serio, ch, 0);
 #endif
 				break;
-			};
+			}
 		}
 	} while (serial_in(up, UART_LSR) & UART_LSR_DR);
 }
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 99ff9ab..c93c705 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -318,7 +318,7 @@ static void sunzilog_kbdms_receive_chars(struct uart_sunzilog_port *up,
 				serio_interrupt(&up->serio, ch, 0);
 #endif
 			break;
-		};
+		}
 	}
 }
 
@@ -903,7 +903,7 @@ sunzilog_convert_to_zs(struct uart_sunzilog_port *up, unsigned int cflag,
 		up->curregs[R5] |= Tx8;
 		up->parity_mask = 0xff;
 		break;
-	};
+	}
 	up->curregs[R4] &= ~0x0c;
 	if (cflag & CSTOPB)
 		up->curregs[R4] |= SB2;
@@ -1245,7 +1245,7 @@ static int __init sunzilog_console_setup(struct console *con, char *options)
 	default: case B9600: baud = 9600; break;
 	case B19200: baud = 19200; break;
 	case B38400: baud = 38400; break;
-	};
+	}
 
 	brg = BPS_TO_BRG(baud, ZS_CLOCK / ZS_CLOCK_DIVISOR);
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 02b4dbf..7c08f4d 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1637,7 +1637,7 @@ rescan:
 					s = "-intr"; break;
 				 default:
 			 		s = "-iso"; break;
-				};
+				}
 				s;
 			}));
 		usb_put_urb (urb);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 564eaa5..fb09b63 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -251,7 +251,7 @@ static void set_port_led(
 			case HUB_LED_OFF: s = "off"; break;
 			case HUB_LED_AUTO: s = "auto"; break;
 			default: s = "??"; break;
-			}; s; }),
+			} s; }),
 			status);
 }
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index c2251c4..6f108a9 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -414,7 +414,7 @@ static int set_config(struct usb_composite_dev *cdev,
 		case USB_SPEED_FULL:	speed = "full"; break;
 		case USB_SPEED_HIGH:	speed = "high"; break;
 		default:		speed = "?"; break;
-		} ; speed; }), number, c ? c->label : "unconfigured");
+		} speed; }), number, c ? c->label : "unconfigured");
 
 	if (!c)
 		goto done;
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 3214ca3..24b12d7 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -429,7 +429,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		 case USB_ENDPOINT_XFER_ISOC: val = "iso"; break;
 		 case USB_ENDPOINT_XFER_INT: val = "intr"; break;
 		 default: val = "ctrl"; break;
-		 }; val; }),
+		 } val; }),
 		max);
 
 	/* at this point real hardware should be NAKing transfers
@@ -1789,7 +1789,7 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		 case USB_SPEED_FULL:	s = "fs"; break;
 		 case USB_SPEED_HIGH:	s = "hs"; break;
 		 default:		s = "?"; break;
-		 }; s; }),
+		 } s; }),
 		ep, ep ? (usb_pipein (urb->pipe) ? "in" : "out") : "",
 		({ char *s; \
 		 switch (usb_pipetype (urb->pipe)) { \
@@ -1797,7 +1797,7 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		 case PIPE_BULK:	s = "-bulk"; break; \
 		 case PIPE_INTERRUPT:	s = "-int"; break; \
 		 default: 		s = "-iso"; break; \
-		}; s;}),
+		} s;}),
 		urb->actual_length, urb->transfer_buffer_length);
 }
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 48a7602..4e8c8dc 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1179,7 +1179,7 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 				s = "invalid"; break;
 			default:
 				s = "?"; break;
-			}; s; }),
+			} s; }),
 			(tmp & EPxSTATUS_TOGGLE) ? "data1" : "data0",
 			(tmp & EPxSTATUS_SUSPEND) ? " suspend" : "",
 			(tmp & EPxSTATUS_FIFO_DISABLE) ? " disable" : "",
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 1eca8b4..df59a74 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -187,7 +187,7 @@ static char *type_string(const struct usb_endpoint_descriptor *desc)
 		return "iso";
 	case USB_ENDPOINT_XFER_INT:
 		return "int";
-	};
+	}
 
 	return "control";
 }
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d09155b..342e00c 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -135,7 +135,7 @@ static char *type_string (u8 bmAttributes)
 	case USB_ENDPOINT_XFER_BULK:	return "bulk";
 	case USB_ENDPOINT_XFER_ISOC:	return "iso";
 	case USB_ENDPOINT_XFER_INT:	return "intr";
-	};
+	}
 	return "control";
 }
 #endif
@@ -1632,7 +1632,7 @@ show_queues (struct device *_dev, struct device_attribute *attr, char *buf)
 					val = "intr"; break;
 				 default:
 					val = "iso"; break;
-				 }; val; }),
+				 } val; }),
 				le16_to_cpu (d->wMaxPacketSize) & 0x1fff,
 				ep->dma ? "dma" : "pio", ep->fifo_size
 				);
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index d3cdffe..7703636 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -1074,7 +1074,7 @@ static int rndis_proc_show(struct seq_file *m, void *v)
 				s = "RNDIS_INITIALIZED"; break;
 			 case RNDIS_DATA_INITIALIZED:
 				s = "RNDIS_DATA_INITIALIZED"; break;
-			}; s; }),
+			} s; }),
 			 param->medium,
 			 (param->media_state) ? 0 : param->speed*100,
 			 (param->media_state) ? "disconnected" : "connected",
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 693c29b..462cf0f 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -409,7 +409,7 @@ struct debug_buffer {
 		case 1 << 12: tmp = 'l'; break; \
 		case 2 << 12: tmp = 'h'; break; \
 		default: tmp = '?'; break; \
-		}; tmp; })
+		} tmp; })
 
 static inline char token_mark(struct ehci_hcd *ehci, __hc32 token)
 {
diff --git a/drivers/usb/host/isp116x.h b/drivers/usb/host/isp116x.h
index 12db961..e97dd7c 100644
--- a/drivers/usb/host/isp116x.h
+++ b/drivers/usb/host/isp116x.h
@@ -555,7 +555,7 @@ static void urb_dbg(struct urb *urb, char *msg)
 	case 0:  __c = 's'; break;		\
 	case 1:  __c = 'o'; break;		\
 	default: __c = 'i'; break;		\
-	}; __c;})
+	} __c;})
 
 /*
   Dump PTD info. The code documents the format
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 662cd00..0677ac2 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2127,7 +2127,7 @@ static int proc_isp1362_show(struct seq_file *s, void *unused)
 				   default:
 					   s = "?";
 					   break;
-				   };
+				   }
 				   s;}), ep->maxpacket) ;
 		list_for_each_entry(urb, &ep->hep->urb_list, urb_list) {
 			seq_printf(s, "  urb%p, %d/%d\n", urb,
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index d7d3449..3fb9831 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -17,7 +17,7 @@
 	case PIPE_BULK:		temp = "bulk"; break; \
 	case PIPE_INTERRUPT:	temp = "intr"; break; \
 	default:		temp = "isoc"; break; \
-	}; temp;})
+	} temp;})
 #define pipestring(pipe) edstring(usb_pipetype(pipe))
 
 /* debug| print the main components of an URB
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 18b7099..60dfa35 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1419,7 +1419,7 @@ static int proc_sl811h_show(struct seq_file *s, void *unused)
 			case SL11H_CTL1MASK_SE0: s = " se0/reset"; break;
 			case SL11H_CTL1MASK_K: s = " k/resume"; break;
 			default: s = "j"; break;
-			}; s; }),
+			} s; }),
 			(t & SL11H_CTL1MASK_LSPD) ? " lowspeed" : "",
 			(t & SL11H_CTL1MASK_SUSPEND) ? " suspend" : "");
 
@@ -1452,7 +1452,7 @@ static int proc_sl811h_show(struct seq_file *s, void *unused)
 			case USB_PID_SETUP: s = "setup"; break;
 			case USB_PID_ACK: s = "status"; break;
 			default: s = "?"; break;
-			}; s;}),
+			} s;}),
 			ep->maxpacket,
 			ep->nak_count, ep->error_count);
 		list_for_each_entry (urb, &ep->hep->urb_list, urb_list) {
diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
index 9546f6c..a4b6483 100644
--- a/drivers/usb/host/whci/hcd.c
+++ b/drivers/usb/host/whci/hcd.c
@@ -133,7 +133,7 @@ static int whc_urb_enqueue(struct usb_hcd *usb_hcd, struct urb *urb,
 	default:
 		ret = asl_urb_enqueue(whc, urb, mem_flags);
 		break;
-	};
+	}
 
 	return ret;
 }
@@ -159,7 +159,7 @@ static int whc_urb_dequeue(struct usb_hcd *usb_hcd, struct urb *urb, int status)
 	default:
 		ret = asl_urb_dequeue(whc, urb, status);
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 388cc12..f5d1807 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2195,7 +2195,7 @@ usbtest_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			default:
 				tmp = "unknown";
 				break;
-			}; tmp; }),
+			} tmp; }),
 			info->ctrl_out ? " in/out" : "",
 			rtest, wtest,
 			irtest, iwtest,
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 630ae7f..3465ebf 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -620,7 +620,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				/* case 3 << MUSB_DEVCTL_VBUS_SHIFT: */
 				default:
 					s = "VALID"; break;
-				}; s; }),
+				} s; }),
 				VBUSERR_RETRY_COUNT - musb->vbuserr_retry,
 				musb->port1_status);
 
@@ -2114,7 +2114,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 			 case MUSB_HOST:		s = "Host"; break;
 			 case MUSB_PERIPHERAL:	s = "Peripheral"; break;
 			 default:		s = "OTG"; break;
-			 }; s; }),
+			 } s; }),
 			ctrl,
 			(is_dma_capable() && musb->dma_controller)
 			? "DMA" : "PIO",
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 98519c5..e16b02a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1101,7 +1101,7 @@ static int musb_gadget_enable(struct usb_ep *ep,
 			case USB_ENDPOINT_XFER_BULK:	s = "bulk"; break;
 			case USB_ENDPOINT_XFER_INT:	s = "int"; break;
 			default:			s = "iso"; break;
-			}; s; }),
+			} s; }),
 			musb_ep->is_in ? "IN" : "OUT",
 			musb_ep->dma ? "dma, " : "",
 			musb_ep->packet_sz);
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 5eef4a8..9969f22 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -248,7 +248,7 @@ musb_start_urb(struct musb *musb, int is_in, struct musb_qh *qh)
 			case USB_ENDPOINT_XFER_BULK:	s = "-bulk"; break;
 			case USB_ENDPOINT_XFER_ISOC:	s = "-iso"; break;
 			default:			s = "-intr"; break;
-			}; s; }),
+			} s; }),
 			epnum, buf + offset, len);
 
 	/* Configure endpoint */
@@ -315,7 +315,7 @@ __acquires(musb->lock)
 				default:
 					level = 2;
 					break;
-				}; level; }),
+				} level; }),
 			"complete %p %pF (%d), dev%d ep%d%s, %d/%d\n",
 			urb, urb->complete, status,
 			usb_pipedevice(urb->pipe),
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index e01b073..010bc56 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -315,7 +315,7 @@ static void twl4030_usb_set_mode(struct twl4030_usb *twl, int mode)
 		dev_err(twl->dev, "unsupported T2 transceiver mode %d\n",
 				mode);
 		break;
-	};
+	}
 }
 
 static void twl4030_i2c_access(struct twl4030_usb *twl, int on)
diff --git a/drivers/usb/wusbcore/cbaf.c b/drivers/usb/wusbcore/cbaf.c
index c0c5665..6e150aa 100644
--- a/drivers/usb/wusbcore/cbaf.c
+++ b/drivers/usb/wusbcore/cbaf.c
@@ -208,9 +208,9 @@ static int cbaf_check(struct cbaf *cbaf)
 				ar_name = "ASSOCIATE";
 				ar_assoc = 1;
 				break;
-			};
+			}
 			break;
-		};
+		}
 
 		dev_dbg(dev, "Association request #%02u: 0x%04x/%04x "
 			 "(%zu bytes): %s\n",
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 7ec24e4..cce811d 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -985,7 +985,7 @@ int wusb_usb_ncb(struct notifier_block *nb, unsigned long val,
 	default:
 		WARN_ON(1);
 		result = NOTIFY_BAD;
-	};
+	}
 	return result;
 }
 
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 84b744c..232f385 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -424,7 +424,7 @@ static ssize_t __wa_xfer_setup_sizes(struct wa_xfer *xfer,
 		/* never happens */
 		BUG();
 		result = -EINVAL;	/* shut gcc up */
-	};
+	}
 	xfer->is_inbound = urb->pipe & USB_DIR_IN ? 1 : 0;
 	xfer->is_dma = urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP ? 1 : 0;
 	xfer->seg_size = le16_to_cpu(rpipe->descr.wBlocks)
@@ -484,7 +484,7 @@ static void __wa_xfer_setup_hdr0(struct wa_xfer *xfer,
 		printk(KERN_ERR "FIXME: ISOC not implemented\n");
 	default:
 		BUG();
-	};
+	}
 }
 
 /*
diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index 36de7c4..b2398cc 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -648,7 +648,7 @@ eventq_wakeup(struct ioq_notifier *notifier)
 			printk(KERN_WARNING "VBUS_PCI: Unexpected event %d\n",
 			       event->eventid);
 			break;
-		};
+		}
 
 		memset(event, 0, sizeof(*event));
 
diff --git a/drivers/video/cg14.c b/drivers/video/cg14.c
index f188950..8a6543d 100644
--- a/drivers/video/cg14.c
+++ b/drivers/video/cg14.c
@@ -330,7 +330,7 @@ static int cg14_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 		default:
 			ret = -ENOSYS;
 			break;
-		};
+		}
 		if (!ret) {
 			sbus_writeb(cur_mode, &regs->mcr);
 			par->mode = mode;
@@ -343,7 +343,7 @@ static int cg14_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 					  FBTYPE_MDICOLOR, 8,
 					  info->fix.smem_len);
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 179e96c..b72919f 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -624,7 +624,7 @@ static void __devinit cg6_init_fix(struct fb_info *info, int linebytes)
 	default:
 		cg6_cpu_name = "i386";
 		break;
-	};
+	}
 	if (((conf >> CG6_FHC_REV_SHIFT) & CG6_FHC_REV_MASK) >= 11) {
 		if (info->fix.smem_len <= 0x100000)
 			cg6_card_name = "TGX";
diff --git a/drivers/video/leo.c b/drivers/video/leo.c
index 9e946e2..11aae58 100644
--- a/drivers/video/leo.c
+++ b/drivers/video/leo.c
@@ -469,7 +469,7 @@ static void leo_wid_put(struct fb_info *info, struct fb_wid_list *wl)
 
 		default:
 			continue;
-		};
+		}
 		sbus_writel(0x5800 + j, &lx_krn->krn_type);
 		sbus_writel(wi->wi_values[0], &lx_krn->krn_value);
 	}
diff --git a/drivers/video/nvidia/nv_hw.c b/drivers/video/nvidia/nv_hw.c
index ed20a98..81c80ac 100644
--- a/drivers/video/nvidia/nv_hw.c
+++ b/drivers/video/nvidia/nv_hw.c
@@ -1300,7 +1300,7 @@ void NVLoadStateExt(struct nvidia_par *par, RIVA_HW_STATE * state)
 					break;
 				default:
 					break;
-				};
+				}
 
 				NV_WR32(par->PGRAPH, 0x0b38, 0x2ffff800);
 				NV_WR32(par->PGRAPH, 0x0b3c, 0x00006000);
diff --git a/drivers/video/sbuslib.c b/drivers/video/sbuslib.c
index 37d764a..bb97d9c 100644
--- a/drivers/video/sbuslib.c
+++ b/drivers/video/sbuslib.c
@@ -187,7 +187,7 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 	}
 	default:
 		return -EINVAL;
-	};
+	}
 }
 EXPORT_SYMBOL(sbusfb_ioctl_helper);
 
diff --git a/drivers/video/tcx.c b/drivers/video/tcx.c
index 07c66e9..e04e751 100644
--- a/drivers/video/tcx.c
+++ b/drivers/video/tcx.c
@@ -232,7 +232,7 @@ tcx_blank(int blank, struct fb_info *info)
 
 	case FB_BLANK_POWERDOWN: /* Poweroff */
 		break;
-	};
+	}
 
 	sbus_writel(val, &thc->thc_misc);
 
@@ -434,7 +434,7 @@ static int __devinit tcx_probe(struct platform_device *op)
 		default:
 			j = i;
 			break;
-		};
+		}
 		par->mmap_map[i].poff = op->resource[j].start;
 	}
 
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 109b533..33536ad 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -139,7 +139,7 @@ static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7f6c677..03cb932 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1088,7 +1088,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 			P9_DPRINTK(P9_DEBUG_ERROR,
 				"Unknown special type %c %s\n", type,
 				stat->extension);
-		};
+		}
 		inode->i_rdev = MKDEV(major, minor);
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fb2605d..41904fc 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -290,7 +290,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
-		};
+		}
 	}
 }
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9134dcb..87dea94 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -265,7 +265,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		ip->i_inode.i_rdev = MKDEV(be32_to_cpu(str->di_major),
 					   be32_to_cpu(str->di_minor));
 		break;
-	};
+	}
 
 	ip->i_inode.i_uid = be32_to_cpu(str->di_uid);
 	ip->i_inode.i_gid = be32_to_cpu(str->di_gid);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 09e436a..cb9bfac 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -831,7 +831,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			error = -EEXIST;
 		default:
 			goto out_gunlock;
-		};
+		}
 
 		if (odip != ndip) {
 			if (!ndip->i_inode.i_nlink) {
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index f2a02ed..b83718e 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -478,7 +478,7 @@ void gfs2_recover_func(struct work_struct *work)
 
 		default:
 			goto fail;
-		};
+		}
 
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED,
 					   LM_FLAG_NOEXP | GL_NOCACHE, &ji_gh);
diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index f848b52..868f531 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -476,7 +476,7 @@ static void nlm4_xdr_enc_res(struct rpc_rqst *req,
  *		struct nlm4_holder holder;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct nlm4_testres {
  *		netobj cookie;
@@ -508,7 +508,7 @@ static void nlm4_xdr_enc_testres(struct rpc_rqst *req,
  *		struct nlm4_holder holder;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct nlm4_testres {
  *		netobj cookie;
diff --git a/fs/lockd/clntxdr.c b/fs/lockd/clntxdr.c
index 180ac34..e3824c3 100644
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -469,7 +469,7 @@ static void nlm_xdr_enc_res(struct rpc_rqst *req,
  *		struct nlm_holder holder;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct nlm_testres {
  *		netobj cookie;
@@ -506,7 +506,7 @@ static void nlm_xdr_enc_testres(struct rpc_rqst *req,
  *		struct nlm_holder holder;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct nlm_testres {
  *		netobj cookie;
diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 792cb13..2dab565 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -474,7 +474,7 @@ out_overflow:
  *		fattr attributes;
  *	default:
  *		void;
- *	};
+ *	}
  */
 static int decode_attrstat(struct xdr_stream *xdr, struct nfs_fattr *result)
 {
@@ -519,7 +519,7 @@ static void encode_diropargs(struct xdr_stream *xdr, const struct nfs_fh *fh,
  *		} diropok;
  *	default:
  *		void;
- *	};
+ *	}
  */
 static int decode_diropok(struct xdr_stream *xdr, struct nfs_diropok *result)
 {
@@ -820,7 +820,7 @@ static int nfs2_xdr_dec_diropres(struct rpc_rqst *req, struct xdr_stream *xdr,
  *		path data;
  *	default:
  *		void;
- *	};
+ *	}
  */
 static int nfs2_xdr_dec_readlinkres(struct rpc_rqst *req,
 				    struct xdr_stream *xdr, void *__unused)
@@ -849,7 +849,7 @@ out_default:
  *		nfsdata data;
  *	default:
  *		void;
- *	};
+ *	}
  */
 static int nfs2_xdr_dec_readres(struct rpc_rqst *req, struct xdr_stream *xdr,
 				struct nfs_readres *result)
@@ -961,7 +961,7 @@ out_overflow:
  *		} readdirok;
  *	default:
  *		void;
- *	};
+ *	}
  *
  * Read the directory contents into the page cache, but don't
  * touch them.  The actual decoding is done by nfs2_decode_dirent()
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 183c6b1..d9f4648 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -516,42 +516,42 @@ static __be32 *xdr_decode_nfstime3(__be32 *p, struct timespec *timep)
  *		mode3	mode;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	union set_uid3 switch (bool set_it) {
  *	case TRUE:
  *		uid3	uid;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	union set_gid3 switch (bool set_it) {
  *	case TRUE:
  *		gid3	gid;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	union set_size3 switch (bool set_it) {
  *	case TRUE:
  *		size3	size;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	union set_atime switch (time_how set_it) {
  *	case SET_TO_CLIENT_TIME:
  *		nfstime3	atime;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	union set_mtime switch (time_how set_it) {
  *	case SET_TO_CLIENT_TIME:
  *		nfstime3  mtime;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct sattr3 {
  *		set_mode3	mode;
@@ -691,7 +691,7 @@ out_overflow:
  *		fattr3	attributes;
  *	case FALSE:
  *		void;
- *	};
+ *	}
  */
 static int decode_post_op_attr(struct xdr_stream *xdr, struct nfs_fattr *fattr)
 {
@@ -745,7 +745,7 @@ out_overflow:
  *		wcc_attr	attributes;
  *	case FALSE:
  *		void;
- *	};
+ *	}
  *
  * wcc_data
  *
@@ -789,7 +789,7 @@ out:
  *		nfs_fh3  handle;
  *	case FALSE:
  *		void;
- *	};
+ *	}
  */
 static int decode_post_op_fh3(struct xdr_stream *xdr, struct nfs_fh *fh)
 {
@@ -850,7 +850,7 @@ static void nfs3_xdr_enc_getattr3args(struct rpc_rqst *req,
  *		nfstime3  obj_ctime;
  *	case FALSE:
  *		void;
- *	};
+ *	}
  *
  *	struct SETATTR3args {
  *		nfs_fh3		object;
@@ -1020,7 +1020,7 @@ static void nfs3_xdr_enc_write3args(struct rpc_rqst *req,
  *		sattr3       obj_attributes;
  *	case EXCLUSIVE:
  *		createverf3  verf;
- *	};
+ *	}
  *
  *	struct CREATE3args {
  *		diropargs3	where;
@@ -1113,7 +1113,7 @@ static void nfs3_xdr_enc_symlink3args(struct rpc_rqst *req,
  *		sattr3		pipe_attributes;
  *	default:
  *		void;
- *	};
+ *	}
  *
  *	struct MKNOD3args {
  *		diropargs3	where;
@@ -1367,7 +1367,7 @@ static void nfs3_xdr_enc_setacl3args(struct rpc_rqst *req,
  *		GETATTR3resok  resok;
  *	default:
  *		void;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_getattr3res(struct rpc_rqst *req,
 				    struct xdr_stream *xdr,
@@ -1404,7 +1404,7 @@ out_default:
  *		SETATTR3resok   resok;
  *	default:
  *		SETATTR3resfail resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_setattr3res(struct rpc_rqst *req,
 				    struct xdr_stream *xdr,
@@ -1445,7 +1445,7 @@ out_status:
  *		LOOKUP3resok	resok;
  *	default:
  *		LOOKUP3resfail	resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_lookup3res(struct rpc_rqst *req,
 				   struct xdr_stream *xdr,
@@ -1492,7 +1492,7 @@ out_default:
  *		ACCESS3resok	resok;
  *	default:
  *		ACCESS3resfail	resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_access3res(struct rpc_rqst *req,
 				   struct xdr_stream *xdr,
@@ -1533,7 +1533,7 @@ out_default:
  *		READLINK3resok	resok;
  *	default:
  *		READLINK3resfail resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_readlink3res(struct rpc_rqst *req,
 				     struct xdr_stream *xdr,
@@ -1576,7 +1576,7 @@ out_default:
  *		READ3resok	resok;
  *	default:
  *		READ3resfail	resfail;
- *	};
+ *	}
  */
 static int decode_read3resok(struct xdr_stream *xdr,
 			     struct nfs_readres *result)
@@ -1664,7 +1664,7 @@ out_status:
  *		WRITE3resok	resok;
  *	default:
  *		WRITE3resfail	resfail;
- *	};
+ *	}
  */
 static int decode_write3resok(struct xdr_stream *xdr,
 			      struct nfs_writeres *result)
@@ -1727,7 +1727,7 @@ out_status:
  *		CREATE3resok	resok;
  *	default:
  *		CREATE3resfail	resfail;
- *	};
+ *	}
  */
 static int decode_create3resok(struct xdr_stream *xdr,
 			       struct nfs3_diropres *result)
@@ -1789,7 +1789,7 @@ out_default:
  *		REMOVE3resok   resok;
  *	default:
  *		REMOVE3resfail resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_remove3res(struct rpc_rqst *req,
 				   struct xdr_stream *xdr,
@@ -1830,7 +1830,7 @@ out_status:
  *		RENAME3resok   resok;
  *	default:
  *		RENAME3resfail resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_rename3res(struct rpc_rqst *req,
 				   struct xdr_stream *xdr,
@@ -1874,7 +1874,7 @@ out_status:
  *		LINK3resok	resok;
  *	default:
  *		LINK3resfail	resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_link3res(struct rpc_rqst *req, struct xdr_stream *xdr,
 				 struct nfs3_linkres *result)
@@ -2026,7 +2026,7 @@ out_truncated:
  *		READDIR3resok	resok;
  *	default:
  *		READDIR3resfail	resfail;
- *	};
+ *	}
  *
  * Read the directory contents into the page cache, but otherwise
  * don't touch them.  The actual decoding is done by nfs3_decode_entry()
@@ -2114,7 +2114,7 @@ out_default:
  *		FSSTAT3resok	resok;
  *	default:
  *		FSSTAT3resfail	resfail;
- *	};
+ *	}
  */
 static int decode_fsstat3resok(struct xdr_stream *xdr,
 			       struct nfs_fsstat *result)
@@ -2185,7 +2185,7 @@ out_status:
  *		FSINFO3resok	resok;
  *	default:
  *		FSINFO3resfail	resfail;
- *	};
+ *	}
  */
 static int decode_fsinfo3resok(struct xdr_stream *xdr,
 			       struct nfs_fsinfo *result)
@@ -2257,7 +2257,7 @@ out_status:
  *		PATHCONF3resok	resok;
  *	default:
  *		PATHCONF3resfail resfail;
- *	};
+ *	}
  */
 static int decode_pathconf3resok(struct xdr_stream *xdr,
 				 struct nfs_pathconf *result)
@@ -2315,7 +2315,7 @@ out_status:
  *		COMMIT3resok	resok;
  *	default:
  *		COMMIT3resfail	resfail;
- *	};
+ *	}
  */
 static int nfs3_xdr_dec_commit3res(struct rpc_rqst *req,
 				   struct xdr_stream *xdr,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index dfd1e6d..5fffe7b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4323,7 +4323,7 @@ static void nfs4_handle_setlk_error(struct nfs_server *server, struct nfs4_lock_
 		lsp->ls_seqid.flags &= ~NFS_SEQID_CONFIRMED;
 	case -NFS4ERR_EXPIRED:
 		nfs4_schedule_lease_recovery(server->nfs_client);
-	};
+	}
 }
 
 static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *fl, int recovery_type)
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index a6804f7..ef17acb 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -933,7 +933,7 @@ static void nfs_increment_seqid(int status, struct nfs_seqid *seqid)
 		case -NFS4ERR_NOFILEHANDLE:
 			/* Non-seqid mutating errors */
 			return;
-	};
+	}
 	/*
 	 * Note: no locking needed as we are guaranteed to be first
 	 * on the sequence list
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 2b8e9a5..cc81320 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1413,7 +1413,7 @@ static int nfs_parse_mount_options(char *raw,
 					dfprintk(MOUNT, "NFS:   invalid "
 							"lookupcache argument\n");
 					return 0;
-			};
+			}
 			break;
 		case Opt_fscache_uniq:
 			if (nfs_get_option_str(args, &mnt->fscache_uniq))
@@ -1446,7 +1446,7 @@ static int nfs_parse_mount_options(char *raw,
 				dfprintk(MOUNT, "NFS:	invalid	"
 						"local_lock argument\n");
 				return 0;
-			};
+			}
 			break;
 
 		/*
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 02eb4ed..4f5408a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -412,7 +412,7 @@ static void encode_cb_sequence4args(struct xdr_stream *xdr,
  *		CB_SEQUENCE4resok	csr_resok4;
  *	default:
  *		void;
- *	};
+ *	}
  *
  * Our current back channel implmentation supports a single backchannel
  * with a single slot.
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fbde6f7..e9f734c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1608,7 +1608,7 @@ static __be32 nfsd4_map_bcts_dir(u32 *dir)
 	case NFS4_CDFC4_BACK_OR_BOTH:
 		*dir = NFS4_CDFC4_BOTH;
 		return nfs_ok;
-	};
+	}
 	return nfserr_inval;
 }
 
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c2ba86a..a5079a0 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -25,7 +25,7 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 			return true;
 		default:
 			BUG();
-		};
+		}
 	}
 	return false;
 }
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 0348d0c..ff6e347 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -63,7 +63,7 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 			else if (old->mask & FS_IN_IGNORED)
 				return false;
 			return true;
-		};
+		}
 	}
 	return false;
 }
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index a873667..76f7da6 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -86,7 +86,7 @@ static void o2quo_fence_self(void)
 		       "system by restarting ***\n");
 		emergency_restart();
 		break;
-	};
+	}
 }
 
 /* Indicate that a timeout occured on a hearbeat region write. The
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..a4afa3a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -554,7 +554,7 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 			mlog_bug_on_msg(1, "type: %d\n", type);
 			ops = NULL; /* thanks, gcc */
 			break;
-	};
+	}
 
 	ocfs2_build_lock_name(type, OCFS2_I(inode)->ip_blkno,
 			      generation, res->l_name);
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index bf31b47..92db0e6 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -583,7 +583,7 @@ int ubifs_read_superblock(struct ubifs_info *c)
 		c->key_hash = key_test_hash;
 		c->key_hash_type = UBIFS_KEY_HASH_TEST;
 		break;
-	};
+	}
 
 	c->key_fmt = sup->key_fmt;
 
diff --git a/include/linux/hp_sdc.h b/include/linux/hp_sdc.h
index 9db3d45..4c03e4a 100644
--- a/include/linux/hp_sdc.h
+++ b/include/linux/hp_sdc.h
@@ -168,7 +168,7 @@ switch (val) {						\
 	case 0x2: str = "1820-4379"; break;		\
 	case 0x3: str = "1820-4784"; break;		\
 	default: str = "unknown";			\
-};
+}
 #define HP_SDC_XTD_BEEPER	0x08	/* TI SN76494 beeper available */
 #define HP_SDC_XTD_BBRTC	0x20	/* OKI MSM-58321 BBRTC present */
 
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 505845d..37ca089 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -601,7 +601,7 @@ static inline int ipver2af(__u8 ipver)
 		return AF_INET6;
 	default:
 		return 0;
-	};
+	}
 }
 
 /* Convert from an address parameter type to an address family.  */
@@ -614,7 +614,7 @@ static inline int param_type2af(__be16 type)
 		return AF_INET6;
 	default:
 		return 0;
-	};
+	}
 }
 
 /* Perform some sanity checks. */
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index e683869..f264b9b 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -515,7 +515,7 @@ static int audit_watch_handle_event(struct fsnotify_group *group,
 		BUG();
 		inode = NULL;
 		break;
-	};
+	}
 
 	if (mask & (FS_CREATE|FS_MOVED_TO) && inode)
 		audit_update_watch(parent, dname, inode->i_sb->s_dev, inode->i_ino, 0);
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 34683ef..72a6f2b 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -103,7 +103,7 @@ res_counter_member(struct res_counter *counter, int member)
 		return &counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return &counter->soft_limit;
-	};
+	}
 
 	BUG();
 	return NULL;
diff --git a/kernel/smp.c b/kernel/smp.c
index 73a1951..3f84ac0 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -65,7 +65,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		free_cpumask_var(cfd->cpumask);
 		break;
 #endif
-	};
+	}
 
 	return NOTIFY_OK;
 }
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index b3058e4..fc7c52f 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -554,7 +554,7 @@ static int hard_if_event(struct notifier_block *this,
 		break;
 	default:
 		break;
-	};
+	}
 
 hardif_put:
 	hardif_free_ref(hard_iface);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f9c3764..e97cec6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -990,7 +990,7 @@ static void selinux_write_opts(struct seq_file *m,
 			continue;
 		default:
 			BUG();
-		};
+		}
 		/* we need a comma before each option */
 		seq_putc(m, ',');
 		seq_puts(m, prefix);
diff --git a/sound/drivers/vx/vx_pcm.c b/sound/drivers/vx/vx_pcm.c
index 35a2f71..c19f944 100644
--- a/sound/drivers/vx/vx_pcm.c
+++ b/sound/drivers/vx/vx_pcm.c
@@ -184,7 +184,7 @@ static int vx_set_format(struct vx_core *chip, struct vx_pipe *pipe,
 	default : 
 		snd_BUG();
 		return -EINVAL;
-        };
+        }
 
 	return vx_set_stream_format(chip, pipe, header);
 }
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index 5b92c42..13f0936 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -1104,7 +1104,7 @@ int ess_init(sb_devc * devc, struct address_info *hw_config)
 		default:
 			printk (KERN_ERR "Invalid esstype=%d specified\n", devc->sbmo.esstype);
 			return 0;
-		};
+		}
 		if (submodel != -1) {
 			devc->submodel = submodel;
 			sprintf (modelname, "ES%d", devc->sbmo.esstype);
@@ -1150,7 +1150,7 @@ FKS_test (devc);
 				if ((type & 0x00ff) != ((type >> 8) & 0x00ff)) {
 					printk ("ess_init: Unrecognized %04x\n", type);
 				}
-			};
+			}
 		}
 #if 0
 		/*
@@ -1293,7 +1293,7 @@ printk(KERN_INFO "ess_set_dma_hw: dma8=%d,dma16=%d,dup=%d\n"
 			default:
 				printk(KERN_ERR "ESS1887: Invalid DMA16 %d\n", dma);
 				return 0;
-			};
+			}
 			ess_chgmixer (devc, 0x78, 0x20, dma16_bits);
 			ess_chgmixer (devc, 0x7d, 0x07, dma_bits);
 		}
@@ -1544,7 +1544,7 @@ static int ess_has_rec_mixer (int submodel)
 		return 1;
 	default:
 		return 0;
-	};
+	}
 };
 
 #ifdef FKS_LOGGING
@@ -1761,7 +1761,7 @@ int ess_mixer_reset (sb_devc * devc)
 			ess_chgmixer(devc, 0x7a, 0x18, 0x08);
 			ess_chgmixer(devc, 0x1c, 0x07, 0x07);
 			break;
-		};
+		}
 		/*
 		 * Call set_recmask for proper initialization
 		 */
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index eac7b08..a7c4f3c 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -2614,7 +2614,7 @@ static int __devinit snd_card_asihpi_mixer_new(struct snd_card_asihpi *asihpi)
 					hpi_ctl.dst_node_type,
 					hpi_ctl.dst_node_index);
 			continue;
-		};
+		}
 		if (err < 0)
 			return err;
 	}
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index 622bace..c887572 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1305,7 +1305,7 @@ static int snd_emu10k1_capture_efx_open(struct snd_pcm_substream *substream)
 			runtime->hw.channels_min =
 				runtime->hw.channels_max = 16;
 			break;
-		};
+		}
 #endif
 #if 0
 		/* For 96kHz */
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 629a549..6322e60 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2174,7 +2174,7 @@ static int __devinit snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 		case DEVICE_INTEL_ICH4:
 			chip->spdif_idx = ICHD_SPBAR;
 			break;
-		};
+		}
 	}
 
 	chip->in_ac97_init = 1;
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index ad7d4d7..eb4c10e 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -813,7 +813,7 @@ static int snd_amd7930_get_volume(struct snd_kcontrol *kctl, struct snd_ctl_elem
 	default:
 		swval = &amd->pgain;
 		break;
-	};
+	}
 
 	ucontrol->value.integer.value[0] = *swval;
 
@@ -838,7 +838,7 @@ static int snd_amd7930_put_volume(struct snd_kcontrol *kctl, struct snd_ctl_elem
 	default:
 		swval = &amd->pgain;
 		break;
-	};
+	}
 
 	spin_lock_irqsave(&amd->lock, flags);
 
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 73f9cba..4028a8a 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -591,7 +591,7 @@ static __u32 reverse_bytes(__u32 b, int len)
 		break;
 	default:
 		printk(KERN_ERR "DBRI reverse_bytes: unsupported length\n");
-	};
+	}
 
 	return b;
 }
-- 
1.7.4.2.g597a6.dirty

