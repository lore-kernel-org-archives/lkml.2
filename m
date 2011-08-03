Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab1HCGo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:44:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61765 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1HCGoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110802002226.3ff0b342.akpm@linux-foundation.org>
References: <CAJn8CcE20-co4xNOD8c+0jMeABrc1mjmGzju3xT34QwHHHFsUA@mail.gmail.com>
	<CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com>
	<20110802002226.3ff0b342.akpm@linux-foundation.org>
Date: Wed, 3 Aug 2011 14:44:20 +0800
Message-ID: <CAJn8CcGTwhAaqghqWOYN9mGvRZDzyd9UJbYARz7NGA-7NvFg9Q@mail.gmail.com>
Subject: Re: kernel BUG at mm/vmscan.c:1114
From: Xiaotian Feng <xtfeng@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        mgorman@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 3:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 2 Aug 2011 15:09:57 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:
>
>> __ __I'm hitting the kernel BUG at mm/vmscan.c:1114 twice, each time I
>> was trying to build my kernel. The photo of crash screen and my config
>> is attached.
>
> hm, now why has that started happening?
>
> Perhaps you could apply this debug patch, see if we can narrow it down?
>

I will try it then, but it isn't very reproducible :(
But my system hung after some list corruption warnings... I hit the
corruption 4 times...

So, Dozens of corruption warnings followed after this one:
 [ 3641.495875] ------------[ cut here ]------------
 [ 3641.495885] WARNING: at lib/list_debug.c:53 __list_del_entry+0xa1/0xd0()
 [ 3641.495888] Hardware name: 42424XC
 [ 3641.495891] list_del corruption. prev->next should be
ffffea00000a6c20, but was ffff880033edde70
 [ 3641.495893] Modules linked in: ip6table_filter ip6_tables
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp binfmt_misc parport_pc
ppdev snd_hda_codec_conexant snd_hda_intel snd_hda_codec thinkpad_acpi
arc4 snd_hwdep snd_pcm snd_seq_midi snd_rawmidi cryptd aes_x86_64
iwlagn snd_seq_midi_event aes_generic snd_seq snd_timer snd_seq_device
mac80211 btusb bluetooth snd cfg80211 snd_page_alloc i915 uvcvideo
videodev drm_kms_helper psmouse v4l2_compat_ioctl32 drm tpm_tis tpm lp
soundcore tpm_bios nvram i2c_algo_bit serio_raw joydev parport video
usbhid hid ahci libahci firewire_ohci firewire_core crc_itu_t
sdhci_pci sdhci e1000e
 [ 3641.495987] Pid: 22709, comm: skype Tainted: G        W   3.0.0+ #23
 [ 3641.495989] Call Trace:
 [ 3641.495996]  [<ffffffff8106db3f>] warn_slowpath_common+0x7f/0xc0
 [ 3641.496001]  [<ffffffff8106dc36>] warn_slowpath_fmt+0x46/0x50
 [ 3641.496006]  [<ffffffff81332a71>] __list_del_entry+0xa1/0xd0
 [ 3641.496010]  [<ffffffff81332ab1>] list_del+0x11/0x40
 [ 3641.496015]  [<ffffffff8117a212>] __slab_free+0x362/0x3d0
 [ 3641.496020]  [<ffffffff81519ac9>] ? __sk_free+0xf9/0x1d0
 [ 3641.496025]  [<ffffffff8117b767>] ? kmem_cache_free+0x97/0x220
 [ 3641.496028]  [<ffffffff81519ac9>] ? __sk_free+0xf9/0x1d0
 [ 3641.496032]  [<ffffffff81519ac9>] ? __sk_free+0xf9/0x1d0
 [ 3641.496036]  [<ffffffff8117b8df>] kmem_cache_free+0x20f/0x220
 [ 3641.496040]  [<ffffffff81519ac9>] __sk_free+0xf9/0x1d0
 [ 3641.496044]  [<ffffffff81519c35>] sk_free+0x25/0x30
 [ 3641.496049]  [<ffffffff81576ac9>] tcp_close+0x239/0x440
 [ 3641.496054]  [<ffffffff815a10ef>] inet_release+0xcf/0x150
 [ 3641.496058]  [<ffffffff815a1042>] ? inet_release+0x22/0x150
 [ 3641.496063]  [<ffffffff81513f19>] sock_release+0x29/0x90
 [ 3641.496067]  [<ffffffff81513f97>] sock_close+0x17/0x30
 [ 3641.496072]  [<ffffffff8119151d>] fput+0xfd/0x240
 [ 3641.496077]  [<ffffffff8118c9b6>] filp_close+0x66/0x90
 [ 3641.496081]  [<ffffffff8118d412>] sys_close+0xc2/0x1a0
 [ 3641.496087]  [<ffffffff81652b60>] sysenter_dispatch+0x7/0x33
 [ 3641.496093]  [<ffffffff8132c8ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f

And after I reboot my system, trying to recover building my kernel,
the system hung again, and I got following  warnings:

 [ 1220.468089] ------------[ cut here ]------------
 [ 1220.468099] WARNING: at lib/list_debug.c:56 __list_del_entry+0x82/0xd0()
 [ 1220.468102] Hardware name: 42424XC
 [ 1220.468104] list_del corruption. next->prev should be
ffffea0000e069a0, but was ffff880100216c78
 [ 1220.468106] Modules linked in: ip6table_filter ip6_tables
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables binfmt_misc bridge stp parport_pc
ppdev snd_hda_codec_conexant snd_hda_intel snd_hda_codec thinkpad_acpi
snd_hwdep snd_pcm i915 snd_seq_midi snd_rawmidi arc4 cryptd
snd_seq_midi_event aes_x86_64 snd_seq drm_kms_helper iwlagn snd_timer
aes_generic drm snd_seq_device mac80211 psmouse uvcvideo videodev snd
v4l2_compat_ioctl32 soundcore snd_page_alloc serio_raw i2c_algo_bit
btusb tpm_tis tpm tpm_bios video cfg80211 bluetooth nvram lp joydev
parport usbhid hid ahci libahci firewire_ohci firewire_core e1000e
sdhci_pci sdhci crc_itu_t
 [ 1220.468185] Pid: 1168, comm: Xorg Tainted: G        W   3.0.0+ #23
 [ 1220.468188] Call Trace:
 [ 1220.468190]  <IRQ>  [<ffffffff8106db3f>] warn_slowpath_common+0x7f/0xc0
 [ 1220.468201]  [<ffffffff8106dc36>] warn_slowpath_fmt+0x46/0x50
 [ 1220.468206]  [<ffffffff81332a52>] __list_del_entry+0x82/0xd0
 [ 1220.468210]  [<ffffffff81332ab1>] list_del+0x11/0x40
 [ 1220.468216]  [<ffffffff8117a212>] __slab_free+0x362/0x3d0
 [ 1220.468222]  [<ffffffff811c6606>] ? bvec_free_bs+0x26/0x40
 [ 1220.468226]  [<ffffffff8117b767>] ? kmem_cache_free+0x97/0x220
 [ 1220.468230]  [<ffffffff811c6606>] ? bvec_free_bs+0x26/0x40
 [ 1220.468234]  [<ffffffff811c6606>] ? bvec_free_bs+0x26/0x40
 [ 1220.468239]  [<ffffffff8117b8df>] kmem_cache_free+0x20f/0x220
 [ 1220.468243]  [<ffffffff811c6606>] bvec_free_bs+0x26/0x40
 [ 1220.468247]  [<ffffffff811c6654>] bio_free+0x34/0x70
 [ 1220.468250]  [<ffffffff811c66a5>] bio_fs_de

So is it possible that my previous BUG is triggered by slab list corruption?
