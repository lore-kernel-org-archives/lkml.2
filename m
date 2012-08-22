Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab2HVOkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:40:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50156 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab2HVOka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:40:30 -0400
Date: Wed, 22 Aug 2012 16:40:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rtl8192se hanging completely
Message-ID: <20120822144027.GA6981@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20120822140733.GA1266@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120822140733.GA1266@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Larry.

On Wed, Aug 22, 2012 at 11:07:33PM +0900, Norbert Preining wrote:
> Dear all,
> 
> (please cc)
> 
> I am having serious troubles with my rtl8192se card:
> 
> kernel: 3.6.0-rc2+, compiled from git today, same with rc1
> rtl8192se in kernel driver, loaded with debug=3
> Debian sid
> Lenovo Thinkpad Edge
> 
> When starting from cold boot, the driver associates, but no packet
> whatsoever leaves the computer it seems, pinging the gateway
> does not return anything, and ns lookups are not working.
> 
> In the logs I see many instances of:
> rtlwifi:rtl_tx_agg_start():<0-0> on ra = 00:0a:79:eb:56:10 tid = 6 seq:39
> rtlwifi:rtl_action_proc():<200-1> Tx ACT_ADDBAREQ From :88:9f:fa:f9:07:28
> rtlwifi:rtl_tx_agg_stop():<0-0> on ra = 00:0a:79:eb:56:10 tid = 6
> rtlwifi:rtl_action_proc():<400-1> ACT_ADDBADEL From :88:9f:fa:f9:07:28
> rtlwifi:rtl_action_proc():<10000-1> Rx ACT_ADDBARSP From :00:0a:79:eb:56:10
> in various orders.
> 
> 
> trying to remove the module gave me:
> [  649.459652] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
> [  649.459701] rtlwifi:rtl_tx_agg_stop():<0-0> on ra = 00:0a:79:eb:56:10 tid = 0
> [  659.094654] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 0, mac: 00:0a:79:eb:56:10
> [  659.094659] rtlwifi:rtl_op_set_key():<0-0> alg:CCMP
> [  659.094663] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:4(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
> [  659.094667] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
> [  659.094670] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:0
> [  659.094673] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
> [  659.094676] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010000
> [  659.094719] rtlwifi:rtl_op_sta_remove():<0-0> Remove sta addr is 00:0a:79:eb:56:10
> [  659.142712] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_UN_ASSOC
> [  659.142725] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
> [  659.190740] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
> [  659.190744] rtlwifi:rtl_op_set_key():<0-0> alg:TKIP
> [  659.190747] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:2(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
> [  659.190750] rtlwifi:rtl_op_set_key():<0-0> disable key delete one entry
> [  659.190753] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:1
> [  659.190756] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
> [  659.190759] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010008
> 
> 
> After that I reloaded the module and then it is getting worse:
> rtl8192se 0000:03:00.0: Refused to change power state, currently in D3
> rtl8192se:_rtl92se_read_adapter_info():<0-0> RTL819X Not boot from eeprom, check it !!
> tl8192se: FW Power Save off (module option)
> rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE
> Loading firmware rtlwifi/rtl8192sefw.bin
> ...
> rtl8192se:_rtl92se_macconfig_after_fwdownload():<0-0> OK
> rtl8192se:rtl92s_phy_bb_config():<0-0> RF_Type(0) does not match RF_Num(4)!!
> rtl8192se:rtl92s_phy_bb_config():<0-0> path1 0xf, path2 0xf, pathmap 0xf
> rtlwifi:rtl_pci_start():<0-0> OK
> rtl8192se:rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail!!
> rtl8192se:rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail!!
> rtl8192se:rtl92s_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
> 
> rtl8192se:rtl92s_phy_set_rf_power_state():<0-1> IPS Set eRf nic enable
> rtl8192se:_rtl92se_macconfig_after_fwdownload():<0-1> OK
> 
> ...
> rtl8192se:rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail!!
> rtlwifi:rtl_pci_tx():<200-1> No more TX desc@6, ring->idx = 0, idx = 0, skb_queue_len = 0x0
> 
> etc etc.
> 
> That is the end, no connection at all, and no way (AFAIS) to get
> it back.
> 
> Are there any suggestions, patches, ideas to fix and track that down?
> 
> THanks a lot
> 
> Norbert
> (please cc)
> 
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> MOTSPUR (n.)
> The fourth wheel of a supermarket trolley which looks identical to the
> other tree but renders the trolley completely uncontrollable.
> MO I RANA Imagine being on a vacation, and it's raining all the time,
> you are driving and the kids are making you a nervous wreck. Well you
> are definitive in Mo i Rana.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.
