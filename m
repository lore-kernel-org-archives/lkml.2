Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2DBSIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:08:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761Ab2DBSIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:08:45 -0400
Message-ID: <1333390123.20402.16.camel@joe2Laptop>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Borislav Petkov <bp@alien8.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Apr 2012 11:08:43 -0700
In-Reply-To: <4F79E5A5.9000004@lwfinger.net>
References: <20120402164920.GA13264@x1.osrc.amd.com>
	 <1333385618.15422.17.camel@joe2Laptop>
	 <20120402171733.GB13264@x1.osrc.amd.com> <4F79E5A5.9000004@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 12:45 -0500, Larry Finger wrote:
> On 04/02/2012 12:17 PM, Borislav Petkov wrote:
> > On Mon, Apr 02, 2012 at 09:53:38AM -0700, Joe Perches wrote:
> >> To keep all the "printk(KERN_DEBUG" to "pr_debug(" conversion
> >> output the same as the it was prior to the patch.
> >>
> >> Larry can default it to off if he wants.
> >
> >> From looking at one user of this -
> > drivers/net/wireless/rtlwifi/rtl8192ce/hw.c - some of the messages look
> > like important ones which you wanna have enabled always, f.e. error
> > handling in rtl92ce_hw_init().
> >
> > It probably needs splitting into debugging messages which are default n
> > and always-on messages.
> 
> The current situation is fine with me. Any user with an embedded system can save 
> a lot of memory by setting CONFIG_RTLWIFI_DEBUG to n. If a normal distro chooses 
> to do that, then when some user of that distro reports a problem and is unable 
> to run with the module parameter "debug=X", I get to say "Sorry, I cannot help 
> you." :)
> 
> Of course, if you want to go through the source and convert every instance of 
> "RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ...)" to the equivalent "pr_err(...), 
> then I would probably sign off on it.
> 
> Larry
> 

Well, if you really want, here's one done with.
perl -i -e 'local $/ ; while (<>) { s/RT_TRACE\s*\(\s*rtlpriv,\s*COMP_ERR,\s*DBG_EMERG,\s*/pr_err\(/g; print; }'

It doesn't do the COMP_INIT, COMP_USB, or COMP_SEC cases.

I think some of these aren't very good.
There are a lot of "switch case not processed" messages
that seem useless.

It also introduces some warnings because rtlpriv
isn't used in a couple functions too.

Compiled-but-not-signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtlwifi/base.c                |    6 +-
 drivers/net/wireless/rtlwifi/core.c                |   21 +++-------
 drivers/net/wireless/rtlwifi/pci.c                 |   22 ++++-------
 drivers/net/wireless/rtlwifi/ps.c                  |    3 +-
 drivers/net/wireless/rtlwifi/rc.c                  |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |   21 +++-------
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   22 ++++------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   30 +++++---------
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |   15 ++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   29 +++++---------
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c       |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |    8 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |   15 ++-----
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |   19 +++------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |   30 +++++---------
 drivers/net/wireless/rtlwifi/rtl8192de/led.c       |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |   33 ++++++----------
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |   40 +++++++------------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   27 +++++--------
 drivers/net/wireless/rtlwifi/rtl8192se/led.c       |    6 +--
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   17 +++-----
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |    9 +---
 drivers/net/wireless/rtlwifi/usb.c                 |    8 +--
 31 files changed, 153 insertions(+), 276 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 5100235..f0666c7 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -434,7 +434,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	 * mac80211 hw  in _rtl_init_mac80211.
 	 */
 	if (rtl_regd_init(hw, rtl_reg_notifier)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "REGD init failed\n");
+		pr_err("REGD init failed\n");
 		return 1;
 	} else {
 		/* CRDA regd hint must after init CRDA */
@@ -1056,7 +1056,7 @@ int rtl_tx_agg_stop(struct ieee80211_hw *hw,
 		return -EINVAL;
 
 	if (!sta->addr) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "ra = NULL\n");
+		pr_err("ra = NULL\n");
 		return -EINVAL;
 	}
 
@@ -1084,7 +1084,7 @@ int rtl_tx_agg_oper(struct ieee80211_hw *hw,
 		return -EINVAL;
 
 	if (!sta->addr) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "ra = NULL\n");
+		pr_err("ra = NULL\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..528f358 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -51,8 +51,7 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 		return;
 	}
 	if (firmware->size > rtlpriv->max_fw_size) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
+		pr_err("Firmware is too big!\n");
 		release_firmware(firmware);
 		return;
 	}
@@ -62,8 +61,7 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
+		pr_err("Can't register mac80211 hw\n");
 		return;
 	} else {
 		rtlpriv->mac80211.mac80211_registered = 1;
@@ -204,8 +202,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 				(u8 *) (&mac->basic_rates));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "operation mode %d is not supported!\n", vif->type);
+		pr_err("operation mode %d is not supported!\n", vif->type);
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -363,8 +360,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 			break;
 		default:
 			mac->bw_40 = false;
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 
@@ -896,8 +892,7 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			 "IEEE80211_AMPDU_RX_STOP:TID:%d\n", tid);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "IEEE80211_AMPDU_ERR!!!!:\n");
+		pr_err("IEEE80211_AMPDU_ERR!!!!\n");
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -994,8 +989,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, "alg:CCMP\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "alg_err:%x!!!!\n",
-			 key->cipher);
+		pr_err("alg_err:%x!!!!\n", key->cipher);
 		goto out_unlock;
 	}
 	if (key_type == WEP40_ENCRYPTION ||
@@ -1118,8 +1112,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "cmd_err:%x!!!!\n", cmd);
+		pr_err("cmd_err:%x!!!!\n", cmd);
 	}
 out_unlock:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 07dd38e..c824431 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -169,8 +169,7 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 
@@ -1020,8 +1019,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 				    sizeof(*ring) * entries, &dma);
 
 	if (!ring || (unsigned long)ring & 0xFF) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Cannot allocate TX ring (prio = %d)\n", prio);
+		pr_err("Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
@@ -1070,8 +1068,7 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 
 		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Cannot allocate RX ring\n");
+			pr_err("Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
@@ -1490,8 +1487,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 
 	err = _rtl_pci_init_trx_ring(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "tx ring initialization failed\n");
+		pr_err("tx ring initialization failed\n");
 		return err;
 	}
 
@@ -1847,7 +1843,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
 		goto fail3;
 	}
@@ -1860,22 +1856,20 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate sw for mac80211\n");
+		pr_err("Can't allocate sw for mac80211\n");
 		goto fail3;
 	}
 
 	/* Init PCI sw */
 	err = rtl_pci_init(hw, pdev);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Failed to init PCI\n");
+		pr_err("Failed to init PCI\n");
 		goto fail3;
 	}
 
 	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "failed to create sysfs device attributes\n");
+		pr_err("failed to create sysfs device attributes\n");
 		goto fail3;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 5b9c3b5..f824e9b 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -119,8 +119,7 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 		break;
 
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index c66f08a..0a6aaa9 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -250,8 +250,7 @@ static void *rtl_rate_alloc_sta(void *ppriv,
 
 	rate_priv = kzalloc(sizeof(struct rtl_rate_priv), gfp);
 	if (!rate_priv) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Unable to allocate private rc structure\n");
+		pr_err("Unable to allocate private rc structure\n");
 		return NULL;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index c20b3c3..c45f998 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -182,8 +182,7 @@ static void _rtl92c_write_fw(struct ieee80211_hw *hw,
 		remainSize = size % FW_8192C_PAGE_SIZE;
 
 		if (pageNums > 4) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Page numbers should not greater then 4\n");
+			pr_err("Page numbers should not greater then 4\n");
 		}
 
 		for (page = 0; page < pageNums; page++) {
@@ -215,8 +214,7 @@ static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
 		 (!(value32 & FWDL_ChkSum_rpt)));
 
 	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "chksum report faill ! REG_MCUFWDL:0x%08x\n", value32);
+		pr_err("chksum report faill ! REG_MCUFWDL:0x%08x\n", value32);
 		return -EIO;
 	}
 
@@ -243,8 +241,7 @@ static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
 
 	} while (counter++ < FW_8192C_POLLING_TIMEOUT_COUNT);
 
-	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x\n", value32);
+	pr_err("Polling FW ready fail!! REG_MCUFWDL:0x%08x\n", value32);
 	return -EIO;
 }
 
@@ -280,8 +277,7 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
 	_rtl92c_enable_fw_download(hw, false);
 
 	if (_rtl92c_fw_free_to_go(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is not ready to run!\n");
+		pr_err("Firmware is not ready to run!\n");
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "Firmware is ready to run!\n");
@@ -356,8 +352,7 @@ static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
 	while (!bwrite_sucess) {
 		wait_writeh2c_limmit--;
 		if (wait_writeh2c_limmit == 0) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Write H2C fail because no trigger for FW INT!\n");
+			pr_err("Write H2C fail because no trigger for FW INT!\n");
 			break;
 		}
 
@@ -380,8 +375,7 @@ static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
 			box_extreg = REG_HMEBOX_EXT_3;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 
@@ -485,8 +479,7 @@ static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
 			}
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
index 4c01624..3ee08cf 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -113,7 +113,7 @@ u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
 	offset &= 0x3f;
 	newoffset = offset;
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "return all one\n");
+		pr_err("return all one\n");
 		return 0xFFFFFFFF;
 	}
 	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
@@ -160,7 +160,7 @@ void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
 
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "stop\n");
+		pr_err("stop\n");
 		return;
 	}
 	offset &= 0x3f;
@@ -217,7 +217,7 @@ bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 	rtstatus = rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 	if (rtlphy->rf_type == RF_1T2R) {
@@ -230,13 +230,13 @@ bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 						   BASEBAND_CONFIG_PHY_REG);
 	}
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool) (rtl_get_bbreg(hw,
@@ -635,8 +635,7 @@ void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation\n");
+			pr_err("Unknown Scan Backup operation\n");
 			break;
 		}
 	}
@@ -840,8 +839,7 @@ bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			}
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 
@@ -1860,8 +1858,7 @@ bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 			postprocessing = true;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 	} while (false);
@@ -1897,8 +1894,7 @@ void rtl92c_phy_set_io(struct ieee80211_hw *hw)
 		rtl92c_dm_write_dig(hw);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	rtlphy->set_io_inprogress = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 5c4d9bc..2fde090 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -140,8 +140,7 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		break;
 		}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
@@ -364,8 +363,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_BeqEn);
 					break;
 				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case not processed\n");
+					pr_err("switch case not processed\n");
 					break;
 				}
 			}
@@ -507,8 +505,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 		}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
@@ -529,9 +526,8 @@ static bool _rtl92ce_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 			break;
 
 		if (count > POLLING_LLT_THRESHOLD) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Failed to polling write LLT done at address %d!\n",
-				 address);
+			pr_err("Failed to polling write LLT done at address %d!\n",
+			       address);
 			status = false;
 			break;
 		}
@@ -907,7 +903,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl92ce_init_mac(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		return err;
 	}
@@ -1032,8 +1028,7 @@ static enum version_8192c _rtl92ce_read_chip_version(struct ieee80211_hw *hw)
 		break;
 	default:
 		rtlphy->rf_type = RF_1T1R;
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "ERROR RF_Type is set!!\n");
+		pr_err("ERROR RF_Type is set!!\n");
 		break;
 	}
 
@@ -1088,8 +1083,7 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("Network type %d not supported!\n", type);
 		return 1;
 		break;
 
@@ -1554,8 +1548,7 @@ static void _rtl92ce_read_adapter_info(struct ieee80211_hw *hw)
 		       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 		       HWSET_MAX_SIZE);
 	} else if (rtlefuse->epromtype == EEPROM_93C46) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!");
+		pr_err("RTL819X Not boot from eeprom, check it !!\n");
 	}
 
 	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP",
@@ -1681,7 +1674,7 @@ void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92ce_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	_rtl92ce_hal_customized_behavior(hw);
 }
@@ -2066,8 +2059,7 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			enc_algo = CAM_TKIP;
 			break;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
index 8283e9b..4d34952 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -61,8 +61,7 @@ void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = true;
@@ -96,8 +95,7 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 88deae6..4c2b75f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -346,12 +346,10 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		}
 		break;
 	case RF90_PATH_C:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	return true;
@@ -391,8 +389,7 @@ void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -416,8 +413,7 @@ void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
@@ -596,8 +592,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			break;
 		}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
index 54c7614..c475035 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -55,8 +55,7 @@ void rtl92ce_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 2c3b733..3587ff5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -155,8 +155,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -173,8 +172,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 0c74d4f..ae3da99 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -354,15 +354,13 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 		       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
 		       HWSET_MAX_SIZE);
 	} else if (rtlefuse->epromtype == EEPROM_93C46) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+		pr_err("RTL819X Not boot from eeprom, check it !!\n");
 	}
 	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD, "MAP",
 		      hwinfo, HWSET_MAX_SIZE);
 	eeprom_id = le16_to_cpu(*((__le16 *)&hwinfo[0]));
 	if (eeprom_id != RTL8190_EEPROM_ID) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "EEPROM ID(%#x) is invalid!!\n", eeprom_id);
+		pr_err("EEPROM ID(%#x) is invalid!!\n", eeprom_id);
 		rtlefuse->autoload_failflag = true;
 	} else {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
@@ -851,8 +849,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	err = _rtl92cu_init_power_on(hw);
 
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to init power on!\n");
+		pr_err("Failed to init power on!\n");
 		return err;
 	}
 	if (!wmm_enable) {
@@ -863,8 +860,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
 	}
 	if (false == rtl92c_init_llt_table(hw, boundary)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to init LLT Table!\n");
+		pr_err("Failed to init LLT Table!\n");
 		return -EINVAL;
 	}
 	_rtl92cu_init_queue_reserved_page(hw, wmm_enable, out_ep_nums,
@@ -989,7 +985,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	rtlhal->hw_type = HARDWARE_TYPE_RTL8192CU;
 	err = _rtl92cu_init_mac(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "init mac failed!\n");
+		pr_err("init mac failed!\n");
 		return err;
 	}
 	err = rtl92c_download_fw(hw);
@@ -1099,8 +1095,7 @@ static void  _ResetDigitalProcedure1(struct ieee80211_hw *hw, bool bWithoutHWSM)
 				udelay(50);
 			}
 			if (retry_cnts >= 100) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 "#####=> 8051 reset failed!.........................\n");
+				pr_err("#####=> 8051 reset failed!.........................\n");
 				/* if 8051 reset fail, reset MAC. */
 				rtl_write_byte(rtlpriv,
 					       REG_SYS_FUNC_EN + 1,
@@ -1341,8 +1336,7 @@ static int _rtl92cu_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("Network type %d not supported!\n", type);
 		goto error_out;
 	}
 	rtl_write_byte(rtlpriv, (MSR), bt_msr);
@@ -1585,8 +1579,7 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
@@ -1855,8 +1848,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_BeqEn);
 					break;
 				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case not processed\n");
+					pr_err("switch case not processed\n");
 					break;
 				}
 			}
@@ -1985,8 +1977,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *)val);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
index 75a2deb..634eed0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
@@ -61,8 +61,7 @@ void rtl92cu_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = true;
@@ -94,8 +93,7 @@ void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 025bdc2..ced968b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -171,9 +171,8 @@ bool rtl92c_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value))
 			break;
 		if (count > POLLING_LLT_THRESHOLD) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Failed to polling write LLT done at address %d! _LLT_OP_VALUE(%x)\n",
-				 address, _LLT_OP_VALUE(value));
+			pr_err("Failed to polling write LLT done at address %d! _LLT_OP_VALUE(%x)\n",
+			       address, _LLT_OP_VALUE(value));
 			status = false;
 			break;
 		}
@@ -276,8 +275,7 @@ void rtl92c_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "illegal switch case\n");
+			pr_err("invalid switch case\n");
 			enc_algo = CAM_TKIP;
 			break;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 34e5630..9f3dcfe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -333,12 +333,10 @@ bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		}
 		break;
 	case RF90_PATH_C:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	return true;
@@ -375,8 +373,7 @@ void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	switch (rtlphy->current_chan_bw) {
@@ -397,8 +394,7 @@ void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	rtl92cu_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
@@ -570,8 +566,7 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		_rtl92c_phy_set_rf_sleep(hw);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 506b9a0..fec66f7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -55,8 +55,7 @@ void rtl92cu_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 82c85286..0206a8a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -64,8 +64,7 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("Can't alloc buffer for fw\n");
 		return 1;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
index f548a8d..de26b00 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -130,8 +130,7 @@ static void _rtl92d_write_fw(struct ieee80211_hw *hw,
 	pagenums = size / FW_8192D_PAGE_SIZE;
 	remainSize = size % FW_8192D_PAGE_SIZE;
 	if (pagenums > 8) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Page numbers should not greater then 8\n");
+		pr_err("Page numbers should not greater then 8\n");
 	}
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192D_PAGE_SIZE;
@@ -157,9 +156,7 @@ static int _rtl92d_fw_free_to_go(struct ieee80211_hw *hw)
 	} while ((counter++ < FW_8192D_POLLING_TIMEOUT_COUNT) &&
 		 (!(value32 & FWDL_ChkSum_rpt)));
 	if (counter >= FW_8192D_POLLING_TIMEOUT_COUNT) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "chksum report faill ! REG_MCUFWDL:0x%08x\n",
-			 value32);
+		pr_err("chksum report faill ! REG_MCUFWDL:0x%08x\n", value32);
 		return -EIO;
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
@@ -331,8 +328,7 @@ int rtl92d_download_fw(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, 0x1f, value);
 	spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "fw is not ready to run!\n");
+		pr_err("fw is not ready to run!\n");
 		goto exit;
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "fw is ready to run!\n");
@@ -411,8 +407,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 	while (!bwrite_sucess) {
 		wait_writeh2c_limmit--;
 		if (wait_writeh2c_limmit == 0) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Write H2C fail because no trigger for FW INT!\n");
+			pr_err("Write H2C fail because no trigger for FW INT!\n");
 			break;
 		}
 		boxnum = rtlhal->last_hmeboxnum;
@@ -434,8 +429,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 			box_extreg = REG_HMEBOX_EXT_3;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 		isfw_read = _rtl92d_check_fw_read_last_h2c(hw, boxnum);
@@ -511,8 +505,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 					       boxcontent[idx]);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 		bwrite_sucess = true;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 509f5af..0b7e88f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -165,8 +165,7 @@ void rtl92de_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((bool *)(val)) = rtlpriv->dm.disable_tx_int;
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
@@ -360,8 +359,7 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 "switch case not processed\n");
+				pr_err("switch case not processed\n");
 				break;
 			}
 		}
@@ -501,8 +499,7 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		break;
 	}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 }
@@ -521,9 +518,8 @@ static bool _rtl92de_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value))
 			break;
 		if (count > POLLING_LLT_THRESHOLD) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Failed to polling write LLT done at address %d!\n",
-				 address);
+			pr_err("Failed to polling write LLT done at address %d!\n",
+			       address);
 			status = false;
 			break;
 		}
@@ -921,7 +917,7 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	/* rtlpriv->intf_ops->disable_aspm(hw); */
 	rtstatus = _rtl92de_init_mac(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		spin_unlock_irqrestore(&globalmutex_for_power_and_efuse, flags);
 		return err;
@@ -1120,8 +1116,7 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("Network type %d not supported!\n", type);
 		return 1;
 		break;
 
@@ -1770,8 +1765,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 		       [EFUSE_INIT_MAP][0],
 		       HWSET_MAX_SIZE);
 	} else if (rtlefuse->epromtype == EEPROM_93C46) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+		pr_err("RTL819X Not boot from eeprom, check it !!\n");
 	}
 	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "MAP",
 		      hwinfo, HWSET_MAX_SIZE);
@@ -1786,8 +1780,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 	}
 	if (rtlefuse->autoload_failflag) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+		pr_err("RTL819X Not boot from eeprom, check it !!\n");
 		return;
 	}
 	rtlefuse->eeprom_oemid = *(u8 *)&hwinfo[EEPROM_CUSTOMER_ID];
@@ -1869,7 +1862,7 @@ void rtl92de_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92de_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	return;
 }
@@ -2223,8 +2216,7 @@ void rtl92de_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			enc_algo = CAM_TKIP;
 			break;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/led.c b/drivers/net/wireless/rtlwifi/rtl8192de/led.c
index 76a57ae..e6d47e7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/led.c
@@ -70,8 +70,7 @@ void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = true;
@@ -105,8 +104,7 @@ void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 28fc5fb..75a50f8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -759,7 +759,7 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 
@@ -774,13 +774,13 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 			BASEBAND_CONFIG_PHY_REG);
 	}
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool) (rtl_get_bbreg(hw,
@@ -913,12 +913,10 @@ bool rtl92d_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		}
 		break;
 	case RF90_PATH_C:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	return true;
@@ -1062,8 +1060,7 @@ void rtl92d_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation\n");
+			pr_err("Unknown Scan Backup operation\n");
 			break;
 		}
 	}
@@ -1107,8 +1104,7 @@ void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	switch (rtlphy->current_chan_bw) {
@@ -1139,8 +1135,7 @@ void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
 			HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 
 	}
@@ -2969,8 +2964,7 @@ static bool _rtl92d_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			rtl92d_phy_reload_iqk_setting(hw, channel);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 		break;
@@ -3081,8 +3075,7 @@ static void rtl92d_phy_set_io(struct ieee80211_hw *hw)
 		rtl92d_dm_write_dig(hw);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	rtlphy->set_io_inprogress = false;
@@ -3112,8 +3105,7 @@ bool rtl92d_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 			postprocessing = true;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 	} while (false);
@@ -3300,8 +3292,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		_rtl92d_phy_set_rfsleep(hw);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c b/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
index 3066a7f..45c5df6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
@@ -67,8 +67,7 @@ void rtl92d_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index 4898c50..a1659c6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -178,8 +178,7 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -193,8 +192,7 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
index 380e7d4..09628d6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -175,9 +175,7 @@ static bool _rtl92s_firmware_downloadcode(struct ieee80211_hw *hw,
 	_rtl92s_fw_set_rqpn(hw);
 
 	if (buffer_len >= MAX_FIRMWARE_CODE_SIZE) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Size over FIRMWARE_CODE_SIZE!\n");
-
+		pr_err("Size over FIRMWARE_CODE_SIZE!\n");
 		return false;
 	}
 
@@ -246,9 +244,8 @@ static bool _rtl92s_firmware_checkready(struct ieee80211_hw *hw,
 		} while (pollingcnt--);
 
 		if (!(cpustatus & IMEM_CHK_RPT) || (pollingcnt <= 0)) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "FW_STATUS_LOAD_IMEM FAIL CPU, Status=%x\n",
-				 cpustatus);
+			pr_err("FW_STATUS_LOAD_IMEM FAIL CPU, Status=%x\n",
+			       cpustatus);
 			goto status_check_fail;
 		}
 		break;
@@ -264,17 +261,15 @@ static bool _rtl92s_firmware_checkready(struct ieee80211_hw *hw,
 		} while (pollingcnt--);
 
 		if (!(cpustatus & EMEM_CHK_RPT) || (pollingcnt <= 0)) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "FW_STATUS_LOAD_EMEM FAIL CPU, Status=%x\n",
-				 cpustatus);
+			pr_err("FW_STATUS_LOAD_EMEM FAIL CPU, Status=%x\n",
+			       cpustatus);
 			goto status_check_fail;
 		}
 
 		/* Turn On CPU */
 		rtstatus = _rtl92s_firmware_enable_cpu(hw);
 		if (!rtstatus) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Enable CPU fail!\n");
+			pr_err("Enable CPU fail!\n");
 			goto status_check_fail;
 		}
 		break;
@@ -289,9 +284,8 @@ static bool _rtl92s_firmware_checkready(struct ieee80211_hw *hw,
 		} while (pollingcnt--);
 
 		if (!(cpustatus & DMEM_CODE_DONE) || (pollingcnt <= 0)) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Polling DMEM code done fail ! cpustatus(%#x)\n",
-				 cpustatus);
+			pr_err("Polling DMEM code done fail ! cpustatus(%#x)\n",
+			       cpustatus);
 			goto status_check_fail;
 		}
 
@@ -315,9 +309,8 @@ static bool _rtl92s_firmware_checkready(struct ieee80211_hw *hw,
 
 		if (((cpustatus & LOAD_FW_READY) != LOAD_FW_READY) ||
 		    (pollingcnt <= 0)) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Polling Load Firmware ready fail ! cpustatus(%x)\n",
-				 cpustatus);
+			pr_err("Polling Load Firmware ready fail ! cpustatus(%x)\n",
+			       cpustatus);
 			goto status_check_fail;
 		}
 
@@ -387,8 +380,7 @@ int rtl92s_download_fw(struct ieee80211_hw *hw)
 	/* 2. Retrieve IMEM image. */
 	if ((pfwheader->img_imem_size == 0) || (pfwheader->img_imem_size >
 	    sizeof(firmware->fw_imem))) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "memory for data image is less than IMEM required\n");
+		pr_err("memory for data image is less than IMEM required\n");
 		goto fail;
 	} else {
 		puc_mappedfile += fwhdr_size;
@@ -400,8 +392,7 @@ int rtl92s_download_fw(struct ieee80211_hw *hw)
 
 	/* 3. Retriecve EMEM image. */
 	if (pfwheader->img_sram_size > sizeof(firmware->fw_emem)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "memory for data image is less than EMEM required\n");
+		pr_err("memory for data image is less than EMEM required\n");
 		goto fail;
 	} else {
 		puc_mappedfile += firmware->fw_imem_len;
@@ -435,8 +426,7 @@ int rtl92s_download_fw(struct ieee80211_hw *hw)
 					RT_8192S_FIRMWARE_HDR_EXCLUDE_PRI_SIZE;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unexpected Download step!!\n");
+			pr_err("Unexpected Download step!!\n");
 			goto fail;
 			break;
 		}
@@ -446,14 +436,14 @@ int rtl92s_download_fw(struct ieee80211_hw *hw)
 				ul_filelength);
 
 		if (!rtstatus) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "fail!\n");
+			pr_err("fail!\n");
 			goto fail;
 		}
 
 		/* <3> Check whether load FW process is ready */
 		rtstatus = _rtl92s_firmware_checkready(hw, fwstatus);
 		if (!rtstatus) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "fail!\n");
+			pr_err("fail!\n");
 			goto fail;
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index b141c35..9e1c157 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -78,8 +78,7 @@ void rtl92se_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			break;
 		}
 	default: {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 			break;
 		}
 	}
@@ -296,8 +295,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_BeqEn);
 					break;
 				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case not processed\n");
+					pr_err("switch case not processed\n");
 					break;
 				}
 			}
@@ -401,8 +399,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			break;
 		}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 
@@ -715,9 +712,8 @@ static void _rtl92se_macconfig_before_fwdownload(struct ieee80211_hw *hw)
 	} while (pollingcnt--);
 
 	if (pollingcnt <= 0) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Polling TXDMA_INIT_VALUE timeout!! Current TCR(%#x)\n",
-			 tmpu1b);
+		pr_err("Polling TXDMA_INIT_VALUE timeout!! Current TCR(%#x)\n",
+		       tmpu1b);
 		tmpu1b = rtl_read_byte(rtlpriv, CMDR);
 		rtl_write_byte(rtlpriv, CMDR, tmpu1b & (~TXDMA_EN));
 		udelay(2);
@@ -963,7 +959,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
 	if (!rtl92s_phy_mac_config(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "MAC Config failed\n");
+		pr_err("MAC Config failed\n");
 		return rtstatus;
 	}
 
@@ -1142,8 +1138,7 @@ static int _rtl92se_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("Network type %d not supported!\n", type);
 		return 1;
 		break;
 
@@ -1626,8 +1621,7 @@ static void _rtl92se_read_adapter_info(struct ieee80211_hw *hw)
 	u8 rf_path, index;
 
 	if (rtlefuse->epromtype == EEPROM_93C46) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "RTL819X Not boot from eeprom, check it !!\n");
+		pr_err("RTL819X Not boot from eeprom, check it !!\n");
 	} else if (rtlefuse->epromtype == EEPROM_BOOT_EFUSE) {
 		rtl_efuse_shadow_map_update(hw);
 
@@ -1971,7 +1965,7 @@ void rtl92se_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92se_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 		rtlefuse->autoload_failflag = true;
 	}
 }
@@ -2400,8 +2394,7 @@ void rtl92se_set_key(struct ieee80211_hw *hw, u32 key_index, u8 *p_macaddr,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			enc_algo = CAM_TKIP;
 			break;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
index 44949b5..769d92a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -67,8 +67,7 @@ void rtl92se_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0x0f);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = true;
@@ -103,8 +102,7 @@ void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 4a49992..ccf0687 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -250,8 +250,7 @@ void rtl92s_phy_scan_operation_backup(struct ieee80211_hw *hw,
 			rtl92s_phy_set_fw_cmd(hw, FW_CMD_RESUME_DM_BY_SCAN);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown operation\n");
+			pr_err("Unknown operation\n");
 			break;
 		}
 	}
@@ -291,8 +290,7 @@ void rtl92s_phy_set_bw_mode(struct ieee80211_hw *hw,
 		rtl_write_byte(rtlpriv, BW_OPMODE, reg_bw_opmode);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -316,8 +314,7 @@ void rtl92s_phy_set_bw_mode(struct ieee80211_hw *hw,
 			rtl_write_byte(rtlpriv, RFPGA0_ANALOGPARAMETER2, 0x18);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -438,8 +435,7 @@ static bool _rtl92s_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			}
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case not processed\n");
+			pr_err("switch case not processed\n");
 			break;
 		}
 
@@ -644,8 +640,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			_rtl92se_phy_set_rf_sleep(hw);
 	    break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case not processed\n");
+		pr_err("switch case not processed\n");
 		bresult = false;
 		break;
 	}
@@ -1308,7 +1303,7 @@ void rtl92s_phy_chk_fwcmd_iodone(struct ieee80211_hw *hw)
 	} while (--pollingcnt);
 
 	if (pollingcnt == 0)
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Set FW Cmd fail!!\n");
+		pr_err("Set FW Cmd fail!!\n");
 }
 
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 08c2f56..a512b4a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -531,8 +531,7 @@ void rtl92s_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 					rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index f1b3600..ccffba1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -106,8 +106,7 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 		return;
 	}
 	if (firmware->size > rtlpriv->max_fw_size) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
+		pr_err("Firmware is too big!\n");
 		rtlpriv->max_fw_size = 0;
 		release_firmware(firmware);
 		return;
@@ -119,8 +118,7 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
+		pr_err("Can't register mac80211 hw\n");
 		return;
 	} else {
 		rtlpriv->mac80211.mac80211_registered = 1;
@@ -239,8 +237,7 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl92se_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 2e1e352..6fc1bea 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -844,8 +844,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	_skb = skb;
 	_urb = _rtl_usb_tx_urb_setup(hw, _skb, ep_num);
 	if (unlikely(!_urb)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate urb. Drop skb!\n");
+		pr_err("Can't allocate urb. Drop skb!\n");
 		return;
 	}
 	urb_list = &rtlusb->tx_pending[ep_num];
@@ -975,7 +974,7 @@ int __devinit rtl_usb_probe(struct usb_interface *intf,
 	/*like read eeprom and so on */
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		pr_err("Can't init_sw_vars\n");
 		goto error_out;
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
@@ -986,8 +985,7 @@ int __devinit rtl_usb_probe(struct usb_interface *intf,
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't allocate sw for mac80211\n");
+		pr_err("Can't allocate sw for mac80211\n");
 		goto error_out;
 	}
 


