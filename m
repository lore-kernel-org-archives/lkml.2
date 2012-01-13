Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab2AMOuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:50:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2AMOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:50:06 -0500
Message-ID: <4F104499.9030102@gmail.com>
Date: Fri, 13 Jan 2012 06:50:01 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/base/core.c:194 device_release+0x6e/0x80()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this with waking up from suspend on the current Mainline,
will pull to see if its still there.




[ 5757.674028] CPU 1 is now offline
[ 5757.674030] lockdep: fixing up alternatives.
[ 5757.675589] ------------[ cut here ]------------
[ 5757.675596] WARNING: at drivers/base/core.c:194 
device_release+0x6e/0x80()
[ 5757.675599] Hardware name: MacBookPro2,2
[ 5757.675600] Device 'machinecheck1' does not have a release() 
function, it is broken and must be fixed.
[ 5757.675602] Modules linked in: usb_storage rfcomm bnep kvm_intel kvm 
authenc esp4 ah4 xfrm4_mode_transport deflate zlib_deflate des_generic 
parport_pc ppdev radeon ipt_REJECT ipt_LOG arc4 ath9k mac80211 xt_limit 
xt_tcpudp ath9k_common ath9k_hw xt_addrtype uvcvideo xt_state videodev 
ttm ath nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat 
snd_hda_codec_idt snd_hda_intel snd_hda_codec btusb cfg80211 
drm_kms_helper bluetooth snd_hwdep nf_conntrack_ipv4 drm nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack snd_pcm snd_seq_midi iptable_filter 
snd_rawmidi ip_tables snd_seq_midi_event x_tables appletouch snd_seq 
snd_timer snd_seq_device joydev applesmc snd video input_polldev 
i2c_algo_bit soundcore snd_page_alloc lp parport hid_apple usbhid hid 
firewire_ohci firewire_core sky2
[ 5757.675657] Pid: 6728, comm: pm-suspend Not tainted 
3.2.0-06541-gf33180c #1
[ 5757.675659] Call Trace:
[ 5757.675663]  [<c102dc3d>] warn_slowpath_common+0x6d/0xa0
[ 5757.675667]  [<c12ac6fe>] ? device_release+0x6e/0x80
[ 5757.675670]  [<c12ac6fe>] ? device_release+0x6e/0x80
[ 5757.675673]  [<c102dcee>] warn_slowpath_fmt+0x2e/0x30
[ 5757.675676]  [<c12ac6fe>] device_release+0x6e/0x80
[ 5757.675680]  [<c11f4d2a>] kobject_release+0x3a/0x80
[ 5757.675683]  [<c11f4c17>] kobject_put+0x27/0x60
[ 5757.675685]  [<c11f4ce2>] ? kobject_del+0x22/0x30
[ 5757.675688]  [<c12ad075>] ? device_del+0x125/0x150
[ 5757.675691]  [<c12ac56f>] put_device+0xf/0x20
[ 5757.675694]  [<c12ad0b2>] device_unregister+0x12/0x20
[ 5757.675698]  [<c14536b8>] mce_cpu_callback+0xc3/0x155
[ 5757.675702]  [<c1467a45>] notifier_call_chain+0x45/0x60
[ 5757.675706]  [<c104e4b9>] __raw_notifier_call_chain+0x19/0x20
[ 5757.675709]  [<c102f69f>] __cpu_notify+0x1f/0x40
[ 5757.675712]  [<c102f7c7>] cpu_notify_nofail+0x17/0x20
[ 5757.675716]  [<c1442e3d>] _cpu_down+0xdd/0x240
[ 5757.675719]  [<c102f7df>] ? cpu_maps_update_begin+0xf/0x20
[ 5757.675722]  [<c102f88c>] disable_nonboot_cpus+0x6c/0x100
[ 5757.675726]  [<c107e093>] suspend_devices_and_enter+0x153/0x230
[ 5757.675729]  [<c107e2ac>] enter_state+0x13c/0x160
[ 5757.675733]  [<c107d05a>] state_store+0x8a/0x110
[ 5757.675736]  [<c107cfd0>] ? pm_trace_dev_match_show+0x20/0x20
[ 5757.675739]  [<c11f4b2b>] kobj_attr_store+0x1b/0x30
[ 5757.675743]  [<c114d9f6>] sysfs_write_file+0xa6/0x100
[ 5757.675747]  [<c10f73da>] vfs_write+0x8a/0x160
[ 5757.675750]  [<c114d950>] ? sysfs_poll+0x80/0x80
[ 5757.675753]  [<c10f76b8>] sys_write+0x38/0x70
[ 5757.675756]  [<c1469d5f>] sysenter_do_call+0x12/0x33
[ 5757.675758] ---[ end trace 010aa8996d37704b ]---
[ 5757.676178] Extended CMOS year: 2000
[ 5757.676178] ACPI: Low-level resume complete
[ 5757.676178] PM: Restoring platform NVS memory

Justin P. Mattock
