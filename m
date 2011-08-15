Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1HOD5C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:57:02 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:34134 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1HOD45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:56:57 -0400
Message-ID: <4E4898F5.8050605@gmail.com>
Date: Sun, 14 Aug 2011 20:56:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: ip_rt_bug: 10.0.0.52 -> 255.255.255.255, ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have hit something similar in the past, and _I think_ the patch is 
already Mainline, but dont remember seeing ip_rt_bug.
Anyways just so people are aware.

dmesg here:
http://fpaste.org/Fgo0/

[33184.395947] ip_rt_bug: 10.0.0.52 -> 255.255.255.255, ?
[33184.395960] ------------[ cut here ]------------
[33184.395969] WARNING: at net/ipv4/route.c:1717 ip_rt_bug+0x5c/0x62()
[33184.395973] Hardware name: MacBookPro2,2
[33184.395976] Modules linked in: hidp fuse cpufreq_ondemand 
acpi_cpufreq freq_table mperf 8021q garp stp llc ipt_REJECT 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter 
ip_tables rfcomm bnep arc4 ath9k mac80211 ath9k_common ath9k_hw ath 
cfg80211 ecb btusb bluetooth radeon ttm drm_kms_helper drm uvcvideo 
iTCO_wdt microcode i2c_i801 joydev apple_bl videodev appletouch 
i2c_algo_bit rfkill sky2 video applesmc input_polldev 
iTCO_vendor_support v4l2_compat_ioctl32 i2c_core [last unloaded: 
scsi_wait_scan]
[33184.396177] Pid: 10739, comm: gcm-session Not tainted 
3.1.0-rc1-00073-g068ef73 #4
[33184.396183] Call Trace:
[33184.396195] [<ffffffff81050d3c>] warn_slowpath_common+0x83/0x9b
[33184.396205] [<ffffffff81050d6e>] warn_slowpath_null+0x1a/0x1c
[33184.396213] [<ffffffff81434d5b>] ip_rt_bug+0x5c/0x62
[33184.396221] [<ffffffff8143ceff>] dst_output+0x19/0x1d
[33184.396229] [<ffffffff8143e354>] ip_local_out+0x20/0x24
[33184.396237] [<ffffffff8143f1b9>] ip_send_skb+0x18/0x3e
[33184.396246] [<ffffffff8145b3f2>] udp_send_skb+0x239/0x29b
[33184.396255] [<ffffffff8145cb87>] udp_sendmsg+0x5b7/0x82e
[33184.396265] [<ffffffff813fe07b>] ? release_sock+0x35/0x155
[33184.396272] [<ffffffff8143cc44>] ? ip_select_ident+0x3d/0x3d
[33184.396282] [<ffffffff81056d5b>] ? local_bh_enable_ip+0xe/0x10
[33184.396293] [<ffffffff814bbeba>] ? _raw_spin_unlock_bh+0x40/0x44
[33184.396301] [<ffffffff813fe192>] ? release_sock+0x14c/0x155
[33184.396312] [<ffffffff8146402c>] inet_sendmsg+0x66/0x6f
[33184.396321] [<ffffffff813fa3e7>] sock_sendmsg+0xe6/0x109
[33184.396330] [<ffffffff81081dc3>] ? lock_acquire+0x122/0x15b
[33184.396339] [<ffffffff810f4cde>] ? might_fault+0x5c/0xac
[33184.396347] [<ffffffff81081c6a>] ? lock_release+0x1ab/0x1e2
[33184.396356] [<ffffffff810f4d27>] ? might_fault+0xa5/0xac
[33184.396364] [<ffffffff813f8c6e>] ? copy_from_user+0x2f/0x31
[33184.396374] [<ffffffff813fc1b0>] sys_sendto+0x12f/0x171
[33184.396384] [<ffffffff814c2cba>] ? sysret_check+0x2e/0x69
[33184.396392] [<ffffffff810821f9>] ? trace_hardirqs_on_caller+0x121/0x158
[33184.396401] [<ffffffff810a4b43>] ? audit_syscall_entry+0x11c/0x148
[33184.396410] [<ffffffff8123e69e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[33184.396419] [<ffffffff814c2c82>] system_call_fastpath+0x16/0x1b
[33184.396426] ---[ end trace 5fddb97ae7a1760a ]---
[33185.493453] ip_rt_bug: 10.0.0.52 -> 255.255.255.255, ?
[33185.493464] ------------[ cut here ]------------
[33185.493471] WARNING: at net/ipv4/route.c:1717 ip_rt_bug+0x5c/0x62()
[33185.493474] Hardware name: MacBookPro2,2
[33185.493476] Modules linked in: hidp fuse cpufreq_ondemand 
acpi_cpufreq freq_table mperf 8021q garp stp llc ipt_REJECT 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter 
ip_tables rfcomm bnep arc4 ath9k mac80211 ath9k_common ath9k_hw ath 
cfg80211 ecb btusb bluetooth radeon ttm drm_kms_helper drm uvcvideo 
iTCO_wdt microcode i2c_i801 joydev apple_bl videodev appletouch 
i2c_algo_bit rfkill sky2 video applesmc input_polldev 
iTCO_vendor_support v4l2_compat_ioctl32 i2c_core [last unloaded: 
scsi_wait_scan]
[33185.493545] Pid: 10739, comm: gcm-session Tainted: G W 
3.1.0-rc1-00073-g068ef73 #4
[33185.493549] Call Trace:
[33185.493556] [<ffffffff81050d3c>] warn_slowpath_common+0x83/0x9b
[33185.493562] [<ffffffff81050d6e>] warn_slowpath_null+0x1a/0x1c
[33185.493566] [<ffffffff81434d5b>] ip_rt_bug+0x5c/0x62
[33185.493571] [<ffffffff8143ceff>] dst_output+0x19/0x1d
[33185.493575] [<ffffffff8143e354>] ip_local_out+0x20/0x24
[33185.493579] [<ffffffff8143f1b9>] ip_send_skb+0x18/0x3e
[33185.493584] [<ffffffff8145b3f2>] udp_send_skb+0x239/0x29b
[33185.493589] [<ffffffff8145cb87>] udp_sendmsg+0x5b7/0x82e
[33185.493594] [<ffffffff813fe07b>] ? release_sock+0x35/0x155
[33185.493598] [<ffffffff8143cc44>] ? ip_select_ident+0x3d/0x3d
[33185.493603] [<ffffffff81056d5b>] ? local_bh_enable_ip+0xe/0x10
[33185.493609] [<ffffffff814bbeba>] ? _raw_spin_unlock_bh+0x40/0x44
[33185.493613] [<ffffffff813fe192>] ? release_sock+0x14c/0x155
[33185.493617] [<ffffffff8146402c>] inet_sendmsg+0x66/0x6f
[33185.493623] [<ffffffff813fa3e7>] sock_sendmsg+0xe6/0x109
[33185.493628] [<ffffffff81081dc3>] ? lock_acquire+0x122/0x15b
[33185.493633] [<ffffffff810f4cde>] ? might_fault+0x5c/0xac
[33185.493637] [<ffffffff81081c6a>] ? lock_release+0x1ab/0x1e2
[33185.493642] [<ffffffff810f4d27>] ? might_fault+0xa5/0xac
[33185.493646] [<ffffffff813f8c6e>] ? copy_from_user+0x2f/0x31
[33185.493650] [<ffffffff813fc1b0>] sys_sendto+0x12f/0x171
[33185.493655] [<ffffffff814c2cba>] ? sysret_check+0x2e/0x69
[33185.493659] [<ffffffff810821f9>] ? trace_hardirqs_on_caller+0x121/0x158
[33185.493664] [<ffffffff810a4b43>] ? audit_syscall_entry+0x11c/0x148
[33185.493670] [<ffffffff8123e69e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[33185.493674] [<ffffffff814c2c82>] system_call_fastpath+0x16/0x1b
[33185.493677] ---[ end trace 5fddb97ae7a1760b ]---


Justin P. Mattock
