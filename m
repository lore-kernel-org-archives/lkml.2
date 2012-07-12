Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab2GLNwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:52:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GLNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120712005405.GA1613@redhat.com>
References: <20120709180328.GA4105@redhat.com> <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop> <20120712005405.GA1613@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Jul 2012 15:52:17 +0200
Message-ID: <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 2:54 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Jul 09, 2012 at 08:48:51PM +0200, Kay Sievers wrote:

>  > It looks fine here with the above mentioned patch:
>
> Now that that patch is in Linus tree, I've hit what's probably a different case.
> Look at the modules list in this oops..
>
> [10016.460020] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child1:24295]
> [10016.470008]  rose<4>[10016.470008]  ip_set_bitmap_ipmac<4>[10016.470008]

> Also, I have no idea how the hell the 'Modules linked in:' line (9th line) ended up being printed /after/ the
> module listing began (2nd line).

It's the output of 'dmesg' you pasted, right?

I tried to force all sorts of racy print_modules() calls, and kept
your trinity tool from git for hours, it looks all fine here:

[   54.664301] NET: Registered protocol family 24
[   54.684721] Netfilter messages via NETLINK v0.30.
[   63.103847] ------------[ cut here ]------------
[   63.103857] WARNING: at kernel/futex.c:2452 sys_get_robust_list+0x28e/0x2a0()
[   63.103859] Hardware name: 4174NEG
[   63.103861] deprecated: get_robust_list will be deleted in 2013.
[   63.103862] Modules linked in: binfmt_misc nfnetlink pppoe pppox
ppp_generic slhc atm fuse arc4 i915 hid_generic i2c_algo_bit
drm_kms_helper drm snd_usb_audio snd_usbmidi_lib snd_rawmidi
snd_seq_device bnep bluetooth snd_hda_codec_hdmi
snd_hda_codec_conexant uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core videodev media coretemp kvm_intel kvm crc32c_intel
microcode i2c_i801 i2c_core iwlwifi snd_hda_intel snd_hda_codec
mac80211 snd_hwdep lpc_ich snd_pcm mfd_core sdhci_pci sdhci mmc_core
snd_page_alloc cfg80211 snd_timer thinkpad_acpi snd e1000e soundcore
rfkill video cdc_ncm wmi usbnet mii cdc_wdm cdc_acm
[   63.103921] Pid: 837, comm: trinity-child1 Not tainted
3.5.0-0.rc6.git2.1.fc18.x86_64 #1
[   63.103923] Call Trace:
[   63.103930]  [<ffffffff8106310f>] warn_slowpath_common+0x7f/0xc0
[   63.103934]  [<ffffffff81063206>] warn_slowpath_fmt+0x46/0x50
[   63.103938]  [<ffffffff810d253d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[   63.103941]  [<ffffffff810d6ffe>] sys_get_robust_list+0x28e/0x2a0
[   63.103946]  [<ffffffff816d7d29>] system_call_fastpath+0x16/0x1b
[   63.103948] ---[ end trace 796993e76a8397be ]---
[   63.126701] NET: Registered protocol family 23
[   63.397208] trinity-child3 (839): Using mlock ulimits for
SHM_HUGETLB is deprecated

Can you easily reproduce the issue you pasted?  If, could you give me
the /dev/kmsg output?

Thanks,
Kay
