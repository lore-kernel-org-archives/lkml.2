Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0FOLZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:25:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58476 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0FOLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=m+1hhNbvcONldKaugOkj+gy6Ej0LGX+9lXmKRnHDRmvAJh5t+iHT/DS2FuEyI0iI9O
         6l4qUqhVZKwAteogfFWSLl8/EliZG20FL+ky+CFOVqVo2+EetC+5d3zkB8cX3jDzzfIv
         hUq7U3LHwK3LyI16PaW8e6ztMhdAvGm9Nz2Rw=
Date: Tue, 15 Jun 2010 13:25:30 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: smatch stuff: range checking issues 2.6.35-rc3
Message-ID: <20100615112530.GC5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the list of range checking issues and potential array 
overflows reported by smatch for 2.6.35-rc3.  I hand edited the list to
remove false positives.  Also I changed the format a bit to  make the
lines shorter.

filename.c +[line number] function() 'array_name' [array size] <= [array offset]

I added bugs from staging this time but this list is still shorter than
for 2.6.34 so that's good.  :)  Probably a lot (most?) of the remaining
stuff here is not worth caring about.

regards,
dan carpenter

fs/btrfs/ctree.c +1026 balance_level() 'path->slots' 8 <= 8
fs/btrfs/ctree.c +1238 push_nodes_for_insert() 'path->slots' 8 <= 8
drivers/block/floppy.c +2891 redo_fd_request() 'drive_state' 8 <= 8
drivers/char/riscom8.c +1464 riscom8_setup() 'ints' 4 <= 4
drivers/gpu/drm/radeon/radeon_legacy_tv.c +652 radeon_legacy_tv_mode_set() 'SLOPE_value' 5 <= 5
drivers/gpu/drm/radeon/radeon_legacy_tv.c +656 radeon_legacy_tv_mode_set() 'YCOEF_EN_value' 5 <= 5
drivers/gpu/drm/radeon/radeon_legacy_tv.c +656 radeon_legacy_tv_mode_set() 'YCOEF_value' 5 <= 5
drivers/media/dvb/frontends/cx22700.c +171 cx22700_set_tps() 'fec_tab' 6 <= 6
drivers/media/dvb/frontends/cx24110.c +210 cx24110_set_fec() 'rate' 7 <= 8
drivers/media/dvb/frontends/ds3000.c +745 ds3000_read_snr() 'dvbs2_snr_tab' 80 <= 80
drivers/media/video/msp3400-driver.c +277 msp_set_scart() 'scart_names' 8 <= 8
drivers/media/video/saa7134/saa7134-tvaudio.c +604 tvaudio_thread() 'tvaudio' 11 <= 11
drivers/media/video/saa7134/saa7134-video.c +1879 saa7134_s_std_internal() 'tvnorms' 12 <= 12
drivers/message/fusion/mptbase.c +8021 mpt_sas_log_info() 'originator_str' 3 <= 3
drivers/net/tulip/de4x5.c +4729 type3_infoblock() 'lp->phy' 8 <= 8
drivers/net/tulip/de4x5.c +5020 mii_get_phy() 'lp->phy' 8 <= 8
drivers/net/wan/lmc/lmc_main.c +1892 lmc_softreset() 'sc->lmc_rxring' 32 <= 32
drivers/net/wan/lmc/lmc_main.c +1914 lmc_softreset() 'sc->lmc_txring' 32 <= 32
drivers/net/wan/sdla.c +958 sdla_close() 'flp->dlci' 8 <= 8
drivers/net/wireless/iwlwifi/iwl-agn-rs.c +2694 rs_fill_link_cmd() 'lq_cmd->rs_table' 16 <= 16
drivers/net/wireless/libertas/mesh.c +816 mesh_id_get() 'defs.meshie.val.mesh_id' 32 <= 32
drivers/net/wireless/orinoco/hw.c +772 orinoco_hw_get_act_bitrate() 'bitrate_table' 8 <= 8
drivers/net/wireless/atmel.c +1217 service_interrupt() 'irq_order' 8 <= 8
drivers/net/wireless/ray_cs.c +1025 translate_frame() '(ptx->var)->org' 3 <= 3
drivers/net/defxx.c +2422 dfx_ctl_update_cam() 'bp->uc_table' 6 <= 366
drivers/net/s2io.c +5811 s2io_vpd_read() 'vpd_data' 256 <= 256
drivers/pci/dmar.c +1214 dmar_get_fault_reason() 'intr_remap_fault_reasons' 7 <= 7
drivers/scsi/aic7xxx/aic7xxx_core.c +968 ahc_handle_brkadrint() 'ahc_hard_errors' 8 <= 8
drivers/scsi/bfa/bfa_ioc.c +1598 bfa_ioc_mbox_isr() 'mod->mbhdlr' 32 <= 32
drivers/scsi/aha152x.c +1687 seldo_run() '(&shpnt->hostdata)->msgo' 256 <= 256
drivers/scsi/qla2xxx/qla_dbg.c +746 qla2100_fw_dump() 'fw->risc_ram' 61440 <= 61440
drivers/scsi/gdth.c +2116 gdth_next() 'ha->hdr' 255 <= 255
drivers/video/fbmem.c +1601 register_framebuffer() 'registered_fb' 32 <= 32
drivers/video/cyber2000fb.c +330 cyber2000fb_setcolreg() 'cfb->palette' 256 <= 504
sound/drivers/opl3/opl3_midi.c +652 snd_opl3_kill_voice() 'opl3->voices' 18 <= 20
sound/pci/riptide/riptide.c +2037 snd_riptide_joystick_probe() 'joystick_port' 32 <= 32
lib/zlib_inflate/inftrees.c +240 zlib_inflate_table() 'count' 16 <= 16

drivers/staging/comedi/drivers/cb_pcidda.c +311 cb_pcidda_attach() 'cb_pcidda_boards' 6 <= 9
drivers/staging/cxt1e1/comet.c +415 WrtXmtWaveformTbl() 'table' 24 <= 24
drivers/staging/rt2860/common/cmm_wpa.c +414 RTMPToWirelessSta() 'pAd->TxSwQueue' 4 <= 4
drivers/staging/rtl8192e/r819xE_cmdpkt.c +796 cmpk_message_handle_rx() 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/rtl8192su/r8192S_phy.c +2031 PHY_SetTxPowerLevel8192S() 'priv->AntennaTxPwDiff' 2 <= 2
drivers/staging/rtl8192su/r819xU_cmdpkt.c +499 cmpk_message_handle_rx() 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/rtl8192su/r8192S_Efuse.c +2089 efuse_read_data() 'RTL8712_SDIO_EFUSE_TABLE' 13 <= 13
drivers/staging/rtl8192u/r819xU_cmdpkt.c +783 cmpk_message_handle_rx() 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/vt6655/card.c +1590 CARDbAdd_PMKID_Candidate() 'pDevice->gsPMKIDCandidate.CandidateList' 5 <= 5
drivers/staging/vt6655/wroute.c +157 ROUTEbRelay() 'pDevice->pMgmt->sNodeDBTable' 65 <= 65
drivers/staging/vt6655/rf.c +1022 RFbSetPower() 'pDevice->abyCCKPwrTbl' 15 <= 56
drivers/staging/vt6656/rxtx.c +3254 bRelayPacketSend() 'pMgmt->sNodeDBTable' 65 <= 65
drivers/staging/vt6656/channel.c +502 CHvInitChannelTable() 'ChannelRuleTab' 119 <= 119
drivers/staging/wlags49_h2/wl_util.c +922 wl_is_a_valid_chan() 'chan_freq_list' 26 <= 49
drivers/staging/wlags49_h2/wl_util.c +960 wl_is_a_valid_freq() 'chan_freq_list' 26 <= 49
drivers/staging/wlags49_h2/wl_util.c +1003 wl_get_freq_from_chan() 'chan_freq_list' 26 <= 49
drivers/staging/wlan-ng/prism2fw.c +595 mkpdrlist() 'pda16' 512 <= 512

