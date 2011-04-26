Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1DZTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:09:26 -0400
Received: from perninha.conectiva.com.br ([187.115.55.249]:50916 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1DZTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:09:22 -0400
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 15:09:21 EDT
Subject: Re: [PATCH] Power Manager suspend-hybrid warn on systemlog
From: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <201104252347.18955.rjw@sisk.pl>
References: <1298384175.8390.25.camel@localhost.localdomain>
	 <20110405161616.GC1615@ucw.cz> <201104251258.04148.rjw@sisk.pl>
	 <201104252347.18955.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Conectiva
Date: Tue, 26 Apr 2011 15:49:32 -0300
Message-ID: <1303843772.18061.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3-1.1mdv2010.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, thank you a lot for your reply.

Unfortunately something strange occurred when I applied any one of this
2 patches you sent.

The network interface flooded the demsg with many times of that:
WARNING: at net/mac80211/iface.c:718 ieee80211_iface_work+0x305/0x310
[mac80211]()
Hardware name: P MOBILE
interface work scheduled while going to suspend
Modules linked in: option usb_wwan usbserial sit tunnel4 fuse ipt_IFWLOG
ipt_psd cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq
xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy
ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN
ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp ipt_set ipt_SET ip_set_nethash ip_set_iptreemap
ip_set_iptree ip_set_ipporthash ip_set_portmap ip_set_macipmap
ip_set_ipmap ip_set_iphash ip_set xt_TPROXY nf_tproxy_core ip6_tables
nf_defrag_ipv6 xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE
xt_NFLOG nfnetlink_log xt_multiport xt_mark af_packet xt_mac xt_limit
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp
xt_conntrack xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
iptable_mangle nfnetlink iptable_filter ip_tables x_tables ipv6 i915
drm_kms_helper drm i2c_algo_bit binfmt_misc loop dm_mirror
dm_region_hash dm_log dm_mod uvcvideo videodev i2c_core cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
nvram snd_hda_codec_hdmi usbhid hid uas usb_storage
snd_hda_codec_realtek snd_hda_intel arc4 snd_hda_codec snd_hwdep ecb
snd_seq_dummy rtl8192ce snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device pciehp pci_hotplug snd_pcm_oss snd_pcm rtlwifi snd_timer
snd_mixer_oss snd iTCO_wdt soundcore ehci_hcd iTCO_vendor_support
mac80211 sparse_keymap sg sr_mod r8169 battery mii cfg80211 rfkill
serio_raw wmi snd_page_alloc evdev ac processor thermal button video
usbcore ata_piix ahci libahci libata sd_mod scsi_mod crc_t10dif ext4
jbd2 crc16 [last unloaded: scsi_wait_scan]
Pid: 6209, comm: kworker/u:11 Tainted: G        W
2.6.38.3-server-1mnb2 #1
Call Trace:
 [<c0151a72>] ? warn_slowpath_common+0x72/0xa0
 [<f847f735>] ? ieee80211_iface_work+0x305/0x310 [mac80211]
 [<f847f735>] ? ieee80211_iface_work+0x305/0x310 [mac80211]
 [<c0151b43>] ? warn_slowpath_fmt+0x33/0x40
 [<f847f735>] ? ieee80211_iface_work+0x305/0x310 [mac80211]
 [<c0168cf2>] ? cwq_dec_nr_in_flight+0x52/0x90
 [<c016a300>] ? process_one_work+0x100/0x3a0
 [<c014bd94>] ? wake_up_process+0x14/0x20
 [<c01681f5>] ? start_worker+0x25/0x30
 [<f847f430>] ? ieee80211_iface_work+0x0/0x310 [mac80211]
 [<c016b0ba>] ? worker_thread+0x12a/0x2e0
 [<c016af90>] ? worker_thread+0x0/0x2e0
 [<c016e9ed>] ? kthread+0x6d/0x80
 [<c016e980>] ? kthread+0x0/0x80
 [<c010b43e>] ? kernel_thread_helper+0x6/0x10
---[ end trace bbe4a610450faaf0 ]---
WARNING: at net/mac80211/work.c:904 ieee80211_work_work+0x2bf/0x10e0
[mac80211]()
Hardware name: P MOBILE
work scheduled while going to suspend
Modules linked in: option usb_wwan usbserial sit tunnel4 fuse ipt_IFWLOG
ipt_psd cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq
xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy
ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN
ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp ipt_set ipt_SET ip_set_nethash ip_set_iptreemap
ip_set_iptree ip_set_ipporthash ip_set_portmap ip_set_macipmap
ip_set_ipmap ip_set_iphash ip_set xt_TPROXY nf_tproxy_core ip6_tables
nf_defrag_ipv6 xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE
xt_NFLOG nfnetlink_log xt_multiport xt_mark af_packet xt_mac xt_limit
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp
xt_conntrack xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
iptable_mangle nfnetlink iptable_filter ip_tables x_tables ipv6 i915
drm_kms_helper drm i2c_algo_bit binfmt_misc loop dm_mirror
dm_region_hash dm_log dm_mod uvcvideo videodev i2c_core cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
nvram snd_hda_codec_hdmi usbhid hid uas usb_storage
snd_hda_codec_realtek snd_hda_intel arc4 snd_hda_codec snd_hwdep ecb
snd_seq_dummy rtl8192ce snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device pciehp pci_hotplug snd_pcm_oss snd_pcm rtlwifi snd_timer
snd_mixer_oss snd iTCO_wdt soundcore ehci_hcd iTCO_vendor_support
mac80211 sparse_keymap sg sr_mod r8169 battery mii cfg80211 rfkill
serio_raw wmi snd_page_alloc evdev ac processor thermal button video
usbcore ata_piix ahci libahci libata sd_mod scsi_mod crc_t10dif ext4
jbd2 crc16 [last unloaded: scsi_wait_scan]
Pid: 6209, comm: kworker/u:11 Tainted: G        W
2.6.38.3-server-1mnb2 #1
Call Trace:
 [<c0151a72>] ? warn_slowpath_common+0x72/0xa0
 [<f847dc1f>] ? ieee80211_work_work+0x2bf/0x10e0 [mac80211]
 [<f847dc1f>] ? ieee80211_work_work+0x2bf/0x10e0 [mac80211]
 [<c0151b43>] ? warn_slowpath_fmt+0x33/0x40
 [<f847dc1f>] ? ieee80211_work_work+0x2bf/0x10e0 [mac80211]
 [<f847f735>] ? ieee80211_iface_work+0x305/0x310 [mac80211]
 [<f847f735>] ? ieee80211_iface_work+0x305/0x310 [mac80211]
 [<c016a300>] ? process_one_work+0x100/0x3a0
 [<c014bd94>] ? wake_up_process+0x14/0x20
 [<c01681f5>] ? start_worker+0x25/0x30
 [<f847d960>] ? ieee80211_work_work+0x0/0x10e0 [mac80211]
 [<c016b0ba>] ? worker_thread+0x12a/0x2e0
 [<c016af90>] ? worker_thread+0x0/0x2e0
 [<c016e9ed>] ? kthread+0x6d/0x80
 [<c016e980>] ? kthread+0x0/0x80
 [<c010b43e>] ? kernel_thread_helper+0x6/0x10
---[ end trace bbe4a610450faaf1 ]---

With the stupid hack I posted first It does not occurs.

Thanks
Alexandre

Em Seg, 2011-04-25 às 23:47 +0200, Rafael J. Wysocki escreveu:
> into the right direction, but the
> pm_restrict_gfp_mask() is needed for the "pure" suspend-to-RAM case.
> 
> Please check if the appended patch works for you. 


