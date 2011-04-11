Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1DKRYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:24:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46950 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1DKRYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LTTs09HJguUIE+lNI15H/uGZtAy5zQ3ZQpkABXvuilElD4VQMEdgF6zqm9wnF9kFu6
         N6HC0VmozE00HNzwHL/FmJnmh/98wFUBzCyKbOByVlpxrxDpDgfSVLUTXue31yh1Vw48
         clkeNHBTPbF+eLUxLUgfbLp+FO/STKcmt6swg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104111217560.1975-100000@iolanthe.rowland.org>
References: <BANLkTin3Qg1dHqAVXfZR1g_AK2JuSKLmdg@mail.gmail.com>
	<Pine.LNX.4.44L0.1104111217560.1975-100000@iolanthe.rowland.org>
Date: Mon, 11 Apr 2011 19:24:27 +0200
Message-ID: <BANLkTinfr5_9hw=296TXPu6_HZ=QEOVcig@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Alan Stern <stern@rowland.harvard.edu>:
> On Mon, 11 Apr 2011, Zdenek Kabelac wrote:
>
>> Ok - add some more memory debug:
>>
>> [   13.347268] usb 1-1: USB disconnect, device number 3
>> [   13.348113] btusb_bulk_complete: hci0 urb ffff8801367f6528 failed
>> to resubmit (19)
>> [   13.349111] btusb_intr_complete: hci0 urb ffff8801367f6840 failed
>> to resubmit (19)
>> [   13.349143] btusb_bulk_complete: hci0 urb ffff8801367fa630 failed
>> to resubmit (19)
>> [   13.409856] general protection fault: 0000 [#1] PREEMPT SMP
>> [   13.413340] last sysfs file:
>> /sys/devices/pci0000:00/0000:00:19.0/net/eth0/uevent
>> [   13.413340] CPU 0
>> [   13.413340] Modules linked in: ipt_REJECT xt_physdev xt_state
>> iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
>> nf_conntrack nf_defrag_ipv4 ip_tables x_tables dm_mirror
>> dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb bluetooth
>> virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr aead
>> crypto_algapi iwl3945 iwl_legacy snd_hda_intel snd_hda_codec usbhid
>> snd_seq snd_seq_device mac80211 hid iTCO_wdt iTCO_vendor_support
>> snd_pcm psmouse i2c_i801 serio_raw cfg80211 thinkpad_acpi snd_timer
>> snd e1000e soundcore snd_page_alloc nvram wmi evdev i915
>> drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 pcmcia
>> uhci_hcd ehci_hcd sdhci_pci sdhci sr_mod mmc_core yenta_socket cdrom
>> usbcore video backlight [last unloaded: scsi_wait_scan]
>> [   13.413340]
>> [   13.413340] Pid: 815, comm: bluetoothd Not tainted
>> 2.6.39-rc2-00144-gca71856 #121 LENOVO 6464CTO/6464CTO
>> [   13.413340] RIP: 0010:[<ffffffff8109ae43>]  [<ffffffff8109ae43>]
>> module_put+0x33/0x1b0
>> [   13.413340] RSP: 0018:ffff8801389e1d68  EFLAGS: 00010296
>> [   13.413340] RAX: ffffffffa04a32a6 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
>> [   13.413340] RDX: 0000000000000000 RSI: ffffffffa04a32a6 RDI: ffffffff8109ae43
>> [   13.413340] RBP: ffff8801389e1d98 R08: 0000000000000000 R09: 0000000000000000
>> [   13.413340] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88013b028590
>> [   13.413340] R13: 00000000ffffffed R14: ffff8801390ac7b0 R15: 000000000000000a
>> [   13.413340] FS:  00007fe99d67d720(0000) GS:ffff88013ba00000(0000)
>> knlGS:0000000000000000
>> [   13.413340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [   13.413340] CR2: 00007fe99d4902b0 CR3: 0000000134dea000 CR4: 00000000000006f0
>> [   13.413340] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   13.413340] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   13.413340] Process bluetoothd (pid: 815, threadinfo
>> ffff8801389e0000, task ffff8801387d23a0)
>> [   13.413340] Stack:
>> [   13.413340]  ffff88013b028000 ffff88013b028000 ffff88013b028590
>> 00000000ffffffed
>> [   13.413340]  ffff8801390ac7b0 000000000000000a ffff8801389e1de8
>> ffffffffa04a32a6
>> [   13.413340]  ffff8801389e1db8 ffffffff8124f11a ffff8801389e1dd8
>> 00000000400448c9
>> [   13.413340] Call Trace:
>> [   13.413340]  [<ffffffffa04a32a6>] hci_dev_open+0x96/0x3f0 [bluetooth]
>> [   13.413340]  [<ffffffff8124f11a>] ? security_capable+0x2a/0x30
>> [   13.413340]  [<ffffffffa04b0172>] hci_sock_ioctl+0x1e2/0x4b0 [bluetooth]
>
>> So - it looks like disabling BT in runtime is not enough  to avoid problems ;)
>>
>> So I've blacklisted  bluetooth & btusb -  and made quite several
>> suspend/resume cycles  -
>> and without  a single problem.
>>
>> So I'll keep an eye on this - but so far complete deactivation of BT
>> either in BIOS or modules blacklisting solves the problem of weird
>> USB deadlocking.
>
> Clearly there's something going wrong in the Bluetooth drivers.  You
> should try posting some of this on the linux-bluetooth mailing list.

I've created:

https://bugzilla.kernel.org/show_bug.cgi?id=33062

and I'm cc-ing linux-bluetooth.

Zdenek
