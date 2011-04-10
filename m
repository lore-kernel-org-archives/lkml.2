Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab1DJVbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:31:55 -0400
Received: from mail.perches.com ([173.55.12.10]:4635 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab1DJVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:31:37 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: Remove unnecessary semicolons when switch (foo) {...};
Date: Sun, 10 Apr 2011 14:31:35 -0700
Message-Id: <5020f919bbdc4f03e95f2d3a2606f1fd6c0eef61.1302470807.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470807.git.joe@perches.com>
References: <cover.1302470807.git.joe@perches.com>
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
 drivers/staging/ath6kl/os/linux/ar6000_drv.c   |    6 +++---
 drivers/staging/comedi/drivers/adl_pci9118.c   |    4 ++--
 drivers/staging/comedi/drivers/cb_pcidda.c     |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c    |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c       |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c |    6 +++---
 drivers/staging/comedi/drivers/ni_tio.c        |    6 +++---
 drivers/staging/comedi/drivers/pcl818.c        |    2 +-
 drivers/staging/crystalhd/crystalhd_misc.c     |    4 ++--
 drivers/staging/cx25821/cx25821-video.c        |    2 +-
 drivers/staging/hv/hv_util.c                   |    2 +-
 drivers/staging/iio/accel/lis3l02dq_core.c     |    2 +-
 drivers/staging/iio/addac/adt7316.c            |    6 +++---
 drivers/staging/lirc/lirc_serial.c             |    2 +-
 drivers/staging/vt6655/wpactl.c                |    2 +-
 drivers/staging/vt6656/wpactl.c                |    2 +-
 16 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 666d5e6..9c02be1 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4165,7 +4165,7 @@ skip_key:
             default:
                 A_PRINTF("AUTH: Unknown\n");
                 break;
-        };
+        }
         switch (listenInterval&0xFF) {
             case WPA_PSK_AUTH:
                 A_PRINTF("KeyMgmt: WPA-PSK\n");
@@ -4176,7 +4176,7 @@ skip_key:
             default:
                 A_PRINTF("KeyMgmt: NONE\n");
                 break;
-        };
+        }
         switch (beaconInterval) {
             case AES_CRYPT:
                 A_PRINTF("Cipher: AES\n");
@@ -4195,7 +4195,7 @@ skip_key:
             default:
                 A_PRINTF("Cipher: NONE\n");
                 break;
-        };
+        }
 
         add_new_sta(ar, bssid, channel /*aid*/,
             assocInfo /* WPA IE */, assocRespLen /* IE len */,
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 766103c..3f8e649 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1417,7 +1417,7 @@ static int pci9118_ai_docmd_sampl(struct comedi_device *dev,
 		comedi_error(dev,
 			     "pci9118_ai_docmd_sampl() mode number bug!\n");
 		return -EIO;
-	};
+	}
 
 	devpriv->int_ai_func = interrupt_pci9118_ai_onesample;
 						/* transfer function */
@@ -1496,7 +1496,7 @@ static int pci9118_ai_docmd_dma(struct comedi_device *dev,
 	default:
 		comedi_error(dev, "pci9118_ai_docmd_dma() mode number bug!\n");
 		return -EIO;
-	};
+	}
 
 	if (devpriv->ai12_startstop) {
 		pci9118_exttrg_add(dev, EXTTRG_AI);
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 6383fc9..49102b3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -650,7 +650,7 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 	case 5:
 		command |= UNIP | RANGE2V5;
 		break;
-	};
+	}
 
 	/* output channel specification */
 	command |= channel << 2;
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 3d53df0..b1b832b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -264,7 +264,7 @@ found:
 	default:
 		printk("THIS CARD IS UNSUPPORTED.\n"
 		       "PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
-	};
+	}
 
 	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
 		printk(" Failed to enable PCI device and request regions\n");
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index ca2aeaa..35f3a47 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1418,7 +1418,7 @@ static int ni_660x_dio_insn_config(struct comedi_device *dev,
 	default:
 		return -EINVAL;
 		break;
-	};
+	}
 	return 0;
 }
 
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 986ef67..fd232bc 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -1627,7 +1627,7 @@ static int ni_ai_setup_MITE_dma(struct comedi_device *dev)
 	default:
 		mite_prep_dma(devpriv->ai_mite_chan, 16, 16);
 		break;
-	};
+	}
 	/*start the MITE */
 	mite_dma_arm(devpriv->ai_mite_chan);
 	spin_unlock_irqrestore(&devpriv->mite_channel_lock, flags);
@@ -2156,7 +2156,7 @@ static unsigned ni_min_ai_scan_period_ns(struct comedi_device *dev,
 	default:
 		/*  multiplexed inputs */
 		break;
-	};
+	}
 	return boardtype.ai_speed * num_channels;
 }
 
@@ -5173,7 +5173,7 @@ static void GPCT_Reset(struct comedi_device *dev, int chan)
 		devpriv->stc_writew(dev, devpriv->an_trig_etc_reg,
 				    Analog_Trigger_Etc_Register);
 		break;
-	};
+	}
 
 	devpriv->gpct_mode[chan] = 0;
 	devpriv->gpct_input_select[chan] = 0;
diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index a9bb6b1..98f8789 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -1181,7 +1181,7 @@ static int ni_660x_set_second_gate(struct ni_gpct *counter,
 			break;
 		return -EINVAL;
 		break;
-	};
+	}
 	counter_dev->regs[second_gate_reg] |= Gi_Second_Gate_Mode_Bit;
 	counter_dev->regs[second_gate_reg] &= ~Gi_Second_Gate_Select_Mask;
 	counter_dev->regs[second_gate_reg] |=
@@ -1209,7 +1209,7 @@ static int ni_m_series_set_second_gate(struct ni_gpct *counter,
 		ni_m_series_second_gate_select =
 		    selected_second_gate & selected_second_gate_mask;
 		break;
-	};
+	}
 	counter_dev->regs[second_gate_reg] |= Gi_Second_Gate_Mode_Bit;
 	counter_dev->regs[second_gate_reg] &= ~Gi_Second_Gate_Select_Mask;
 	counter_dev->regs[second_gate_reg] |=
@@ -1674,7 +1674,7 @@ int ni_tio_rinsn(struct ni_gpct *counter, struct comedi_insn *insn,
 		    counter_dev->
 		    regs[NITIO_Gi_LoadB_Reg(counter->counter_index)];
 		break;
-	};
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ni_tio_rinsn);
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index f58d75b..35a1b20 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1662,7 +1662,7 @@ static void rtc_dropped_irq(unsigned long data)
 		tmp = (CMOS_READ(RTC_INTR_FLAGS) & 0xF0);	/* restart */
 		restore_flags(flags);
 		break;
-	};
+	}
 }
 
 /*
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 2c5138e..5fa0c6e 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -311,7 +311,7 @@ enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
 		BCMLOG_ERR("Invalid len:%d\n", len);
-	};
+	}
 
 	if (rc && (sts == BC_STS_SUCCESS))
 		sts = BC_STS_ERROR;
@@ -356,7 +356,7 @@ enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
 		BCMLOG_ERR("Invalid len:%d\n", len);
-	};
+	}
 
 	if (rc && (sts == BC_STS_SUCCESS))
 		sts = BC_STS_ERROR;
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index ab05392..914920b 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1573,7 +1573,7 @@ int cx25821_set_control(struct cx25821_dev *dev,
 		break;
 	default:
 		/* nothing */ ;
-	};
+	}
 
 	switch (ctl->id) {
 	case V4L2_CID_BRIGHTNESS:
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 3af0a11..e587c4f 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -88,7 +88,7 @@ static void shutdown_onchannelcallback(void *context)
 				pr_info("Shutdown request received -"
 					    " Invalid request\n");
 				break;
-			};
+			}
 		}
 
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index c4b4ab7..be2cd41 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -399,7 +399,7 @@ static ssize_t lis3l02dq_write_frequency(struct device *dev,
 	default:
 		ret = -EINVAL;
 		goto error_ret_mutex;
-	};
+	}
 
 	ret = lis3l02dq_spi_write_reg_8(dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/addac/adt7316.c
index d1b5b13..9b25f12 100644
--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -403,7 +403,7 @@ static ssize_t adt7316_show_ad_channel(struct device *dev,
 		return sprintf(buf, "5 - AIN4\n");
 	default:
 		return sprintf(buf, "N/A\n");
-	};
+	}
 }
 
 static ssize_t adt7316_store_ad_channel(struct device *dev,
@@ -893,7 +893,7 @@ static ssize_t adt7316_show_DAC_update_mode(struct device *dev,
 			return sprintf(buf, "2 - auto at MSB DAC ABCD writing\n");
 		default: /* ADT7316_DA_EN_MODE_LDAC */
 			return sprintf(buf, "3 - manual\n");
-		};
+		}
 	}
 }
 
@@ -1205,7 +1205,7 @@ static ssize_t adt7316_show_ad(struct adt7316_chip_info *chip,
 			return sprintf(buf, "%d\n", data);
 		else
 			break;
-	};
+	}
 
 	if (data & ADT7316_T_VALUE_SIGN) {
 		/* convert supplement to positive value */
diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 1c3099b..4a3cca0 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -919,7 +919,7 @@ static int set_use_inc(void *data)
 	default:
 		dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 		break;
-	};
+	}
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index c328f95..a0f994e 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -832,7 +832,7 @@ else
 		break;
 	default:
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-	};
+	}
 
 //DavidWang add for WPA_supplicant support open/share mode
 
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index d22e773..9216df0 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -831,7 +831,7 @@ static int wpa_set_associate(PSDevice pDevice,
 		break;
 	default:
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-	};
+	}
 
            pMgmt->Roam_dbm = param->u.wpa_associate.roam_dbm;
          // if ((pMgmt->Roam_dbm > 40)&&(pMgmt->Roam_dbm<80))
-- 
1.7.4.2.g597a6.dirty

