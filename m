Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2IGAWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:22:09 -0400
Received: from mailrelayi.jaist.ac.jp ([150.65.19.7]:39603 "EHLO
	mailrelayi.jaist.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2IGAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:22:07 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2012 20:22:06 EDT
X-IronPort-AV: E=Sophos;i="4.80,382,1344178800"; 
   d="scan'208";a="122529300"
Date: Fri, 7 Sep 2012 09:11:39 +0900
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rtl8192se hanging completely
Message-ID: <20120907001138.GB9279@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822144027.GA6981@x1.osrc.amd.com>
 <20120822140733.GA1266@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please cc)

I have now changed my home router and with the new one it
is working without problems at home, and with a few
hickups at work, too.

But still, at work after some time the connection breaks.
I found the following interesting messages in the log:
   dmar: DRHD: handling fault status reg 3
   dmar: DMAR:[DMA Read] Request device [03:00.0] fault addr fff73000 
   DMAR:[fault reason 06] PTE Read access is not set
around the time the connection hangs and never comes back.

The mentioned device 03:00.0 is the wlan adapter:
$ lspci -v -s 03:00.0
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. Device e020
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 2000 [size=256]
	Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se
$

That is with latest git kernel from yesterday.

Any suggestions would be appreciated.

On Wed, 22 Aug 2012, Norbert Preining wrote:
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


Best wishes

Norbert

----------------------------------------------------------------------------
Norbert Preining                preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                   TeX Live and Debian Developer
gpg DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
----------------------------------------------------------------------------
FULKING (participial vb.)
Pretending not to be in when the carol-singers come round.
			--- Douglas Adams, The Meaning of Liff
