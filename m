Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1DKM3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:29:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50467 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1DKM3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q7+0gRb/+U4lW9zvOX7UgTqXGZcmfrkgBqXKk0IzWBFJvlc+FRI/0vEaYiVYBu025t
         lfFg1WskJO8EtMn6pIkil2k8ZhRpuMnCRuPVEKW5ePR866iO1t6NWhQ5v6/y4IEURwQo
         /qRuom8HzoHgWyfN+AWv6qlnc7TgKORGDgp3A=
MIME-Version: 1.0
In-Reply-To: <BANLkTimh+k+m1Mw9k6cAWDwZ1nUwBJ=Byw@mail.gmail.com>
References: <BANLkTikwsDtEgA4c55BSFcvh=kjM84c7JQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1104081444020.1992-100000@iolanthe.rowland.org>
	<BANLkTimh+k+m1Mw9k6cAWDwZ1nUwBJ=Byw@mail.gmail.com>
Date: Mon, 11 Apr 2011 14:29:37 +0200
Message-ID: <BANLkTin3Qg1dHqAVXfZR1g_AK2JuSKLmdg@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2011/4/8 Alan Stern <stern@rowland.harvard.edu>:
>> On Fri, 8 Apr 2011, Zdenek Kabelac wrote:
>>
>>> Most probably because I've run  in the loop
>>>
>>> while : ; do pm-suspend ; sleep 5; done
>>>
>>> for debug purposes...
>>>
>>>
>>> >> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
>>> >> to resubmit (19)
>>> >> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
>>> >> to resubmit (19)
>>> >> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
>>> >> to resubmit (19)
>>> >> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
>>> >> [   54.127633] systemd[1]: Service bluetooth.target is not needed
>>> >> anymore. Stopping.
>>> >> [   54.205292] PM: Syncing filesystems ... done.
>>> >> [   54.216056] PM: Preparing system for mem sleep
>>> >>
>>> >> And system was 'dead' - (Moon sign on laptop was already blinking at
>>> >> this moment)
>>> >
>>> > Why did the system suspend like this?  A software undock shouldn't
>>> > cause a suspend.
>>>
>>> pm-suspend - with  script executed on suspend which undocks laptop
>>> (otherwise when I'd forget to press button on docking station before
>>> suspend - it would stay 'red' mode - thus all buses are connected -
>>> and as I've noticed in past - it's not working well, when I unplug
>>> laptop in this 'still connected'  mode - so this software 'undock'
>>> solved this problem)
>>
>> All right.  It looks like there are two possible sources of problems
>> here: the undock and the suspend.  It would be best to debug them
>> separately.
>>
>> For example, if you change the loop above to just do the undock and
>> redock without suspending, do the problems still occur?
>>
>> Another thing to try: Suspend by doing "echo ram >/sys/power/state"
>> instead of running pm_suspend.
>
> hmm - using   "echo mem >/sys/power/state" revealed probably
> completely new problem - unsure how this is related to this USB
> problem - but it leaves the machine in completely 'frozen' picture on
> desktop after resume.
>
> So here is cut&paste captured on serial console:
> (Kernel without USB_DEBUG - bluetooth enabled)
>
>

> [   92.222524] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
> [   92.234736] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
> [   92.240592] [drm:drm_helper_probe_single_connector_modes],
> [CONNECTOR:15:DVI-D-1] disconnected
> [   92.516709] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [   92.520001] IP: [<          (null)>]           (null)
> [   92.520001] PGD 0
> [   92.520001] Oops: 0010 [#1] PREEMPT SMP
> [   92.520001] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/voltage_now
> [   92.520001] CPU 0


Ok - add some more memory debug:

[   13.347268] usb 1-1: USB disconnect, device number 3
[   13.348113] btusb_bulk_complete: hci0 urb ffff8801367f6528 failed
to resubmit (19)
[   13.349111] btusb_intr_complete: hci0 urb ffff8801367f6840 failed
to resubmit (19)
[   13.349143] btusb_bulk_complete: hci0 urb ffff8801367fa630 failed
to resubmit (19)
[   13.409856] general protection fault: 0000 [#1] PREEMPT SMP
[   13.413340] last sysfs file:
/sys/devices/pci0000:00/0000:00:19.0/net/eth0/uevent
[   13.413340] CPU 0
[   13.413340] Modules linked in: ipt_REJECT xt_physdev xt_state
iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 ip_tables x_tables dm_mirror
dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb bluetooth
virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr aead
crypto_algapi iwl3945 iwl_legacy snd_hda_intel snd_hda_codec usbhid
snd_seq snd_seq_device mac80211 hid iTCO_wdt iTCO_vendor_support
snd_pcm psmouse i2c_i801 serio_raw cfg80211 thinkpad_acpi snd_timer
snd e1000e soundcore snd_page_alloc nvram wmi evdev i915
drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 pcmcia
uhci_hcd ehci_hcd sdhci_pci sdhci sr_mod mmc_core yenta_socket cdrom
usbcore video backlight [last unloaded: scsi_wait_scan]
[   13.413340]
[   13.413340] Pid: 815, comm: bluetoothd Not tainted
2.6.39-rc2-00144-gca71856 #121 LENOVO 6464CTO/6464CTO
[   13.413340] RIP: 0010:[<ffffffff8109ae43>]  [<ffffffff8109ae43>]
module_put+0x33/0x1b0
[   13.413340] RSP: 0018:ffff8801389e1d68  EFLAGS: 00010296
[   13.413340] RAX: ffffffffa04a32a6 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
[   13.413340] RDX: 0000000000000000 RSI: ffffffffa04a32a6 RDI: ffffffff8109ae43
[   13.413340] RBP: ffff8801389e1d98 R08: 0000000000000000 R09: 0000000000000000
[   13.413340] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88013b028590
[   13.413340] R13: 00000000ffffffed R14: ffff8801390ac7b0 R15: 000000000000000a
[   13.413340] FS:  00007fe99d67d720(0000) GS:ffff88013ba00000(0000)
knlGS:0000000000000000
[   13.413340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   13.413340] CR2: 00007fe99d4902b0 CR3: 0000000134dea000 CR4: 00000000000006f0
[   13.413340] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   13.413340] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   13.413340] Process bluetoothd (pid: 815, threadinfo
ffff8801389e0000, task ffff8801387d23a0)
[   13.413340] Stack:
[   13.413340]  ffff88013b028000 ffff88013b028000 ffff88013b028590
00000000ffffffed
[   13.413340]  ffff8801390ac7b0 000000000000000a ffff8801389e1de8
ffffffffa04a32a6
[   13.413340]  ffff8801389e1db8 ffffffff8124f11a ffff8801389e1dd8
00000000400448c9
[   13.413340] Call Trace:
[   13.413340]  [<ffffffffa04a32a6>] hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.413340]  [<ffffffff8124f11a>] ? security_capable+0x2a/0x30
[   13.413340]  [<ffffffffa04b0172>] hci_sock_ioctl+0x1e2/0x4b0 [bluetooth]
[   13.413340]  [<ffffffff8107c0a3>] ? up_read+0x23/0x40
[   13.413340]  [<ffffffff813ca9c1>] sock_do_ioctl.constprop.17+0x21/0x60
[   13.413340]  [<ffffffff813caa62>] sock_ioctl+0x62/0x2d0
[   13.413340]  [<ffffffff8115f268>] do_vfs_ioctl+0x98/0x570
[   13.413340]  [<ffffffff8114d901>] ? fget_light+0x3c1/0x430
[   13.413340]  [<ffffffff8149ac1c>] ? sysret_check+0x27/0x62
[   13.413340]  [<ffffffff8115f7d1>] sys_ioctl+0x91/0xa0
[   13.413340]  [<ffffffff8149abeb>] system_call_fastpath+0x16/0x1b
[   13.413340] Code: 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0
4c 89 7d f8 0f 1f 44 00 00 48 85 ff 48 89 fb 74 49 bf 01 00 00 00 e8
dd be 3f 00
[   13.413340]  8b 83 40 02 00 00 65 ff 40 04 4c 8b 6d 08 0f 1f 44 00 00 83
[   13.413340] RIP  [<ffffffff8109ae43>] module_put+0x33/0x1b0
[   13.413340]  RSP <ffff8801389e1d68>
[   13.414647] ---[ end trace 061b48d6d00e7105 ]---
[   13.414651] note: bluetoothd[815] exited with preempt_count 1
[   13.414654] BUG: sleeping function called from invalid context at
kernel/rwsem.c:21
[   13.414657] in_atomic(): 1, irqs_disabled(): 0, pid: 815, name: bluetoothd
[   13.414658] INFO: lockdep is turned off.
[   13.414661] Pid: 815, comm: bluetoothd Tainted: G      D
2.6.39-rc2-00144-gca71856 #121
[   13.414663] Call Trace:
[   13.414667]  [<ffffffff81037ce7>] __might_sleep+0xf7/0x120
[   13.414672]  [<ffffffff81491eb6>] down_read+0x26/0x93
[   13.414677]  [<ffffffff810a6abb>] acct_collect+0x4b/0x1b0
[   13.414683]  [<ffffffff81054ba2>] do_exit+0x632/0x8e0
[   13.414686]  [<ffffffff81051ec9>] ? kmsg_dump+0x79/0x170
[   13.414690]  [<ffffffff81494b02>] oops_end+0xa2/0xf0
[   13.414694]  [<ffffffff81005ca8>] die+0x58/0x90
[   13.414697]  [<ffffffff81494462>] do_general_protection+0x162/0x170
[   13.414701]  [<ffffffff81493bf4>] ? restore_args+0x30/0x30
[   13.414704]  [<ffffffff81493daf>] general_protection+0x1f/0x30
[   13.414711]  [<ffffffffa04a32a6>] ? hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414717]  [<ffffffffa04a32a6>] ? hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414721]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414723]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414726]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414732]  [<ffffffffa04a32a6>] hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414735]  [<ffffffff8124f11a>] ? security_capable+0x2a/0x30
[   13.414742]  [<ffffffffa04b0172>] hci_sock_ioctl+0x1e2/0x4b0 [bluetooth]
[   13.414746]  [<ffffffff8107c0a3>] ? up_read+0x23/0x40
[   13.414749]  [<ffffffff813ca9c1>] sock_do_ioctl.constprop.17+0x21/0x60
[   13.414752]  [<ffffffff813caa62>] sock_ioctl+0x62/0x2d0
[   13.414755]  [<ffffffff8115f268>] do_vfs_ioctl+0x98/0x570
[   13.414759]  [<ffffffff8114d901>] ? fget_light+0x3c1/0x430
[   13.414762]  [<ffffffff8149ac1c>] ? sysret_check+0x27/0x62
[   13.414765]  [<ffffffff8115f7d1>] sys_ioctl+0x91/0xa0
[   13.414768]  [<ffffffff8149abeb>] system_call_fastpath+0x16/0x1b
[   13.414789] BUG: scheduling while atomic: bluetoothd/815/0x10000002
[   13.414791] INFO: lockdep is turned off.
[   13.414792] Modules linked in: ipt_REJECT xt_physdev xt_state
iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 ip_tables x_tables dm_mirror
dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb bluetooth
virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr aead
crypto_algapi iwl3945 iwl_legacy snd_hda_intel snd_hda_codec usbhid
snd_seq snd_seq_device mac80211 hid iTCO_wdt iTCO_vendor_support
snd_pcm psmouse i2c_i801 serio_raw cfg80211 thinkpad_acpi snd_timer
snd e1000e soundcore snd_page_alloc nvram wmi evdev i915
drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 pcmcia
uhci_hcd ehci_hcd sdhci_pci sdhci sr_mod mmc_core yenta_socket cdrom
usbcore video backlight [last unloaded: scsi_wait_scan]
[   13.414835] Pid: 815, comm: bluetoothd Tainted: G      D
2.6.39-rc2-00144-gca71856 #121
[   13.414837] Call Trace:
[   13.414841]  [<ffffffff8148775f>] __schedule_bug+0x72/0x77
[   13.414844]  [<ffffffff8148fe7d>] schedule+0xcbd/0xce0
[   13.414848]  [<ffffffff8111e51b>] ? unmap_vmas+0x3bb/0xa80
[   13.414852]  [<ffffffff81048328>] __cond_resched+0x18/0x30
[   13.414855]  [<ffffffff814901c5>] _cond_resched+0x35/0x40
[   13.414858]  [<ffffffff8111e973>] unmap_vmas+0x813/0xa80
[   13.414862]  [<ffffffff81493595>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   13.414867]  [<ffffffff811266bd>] exit_mmap+0xed/0x1c0
[   13.414870]  [<ffffffff8104caf3>] mmput+0x73/0x110
[   13.414873]  [<ffffffff81052550>] exit_mm+0x120/0x150
[   13.414877]  [<ffffffff8149360b>] ? _raw_spin_unlock_irq+0x5b/0x60
[   13.414880]  [<ffffffff810546c6>] do_exit+0x156/0x8e0
[   13.414883]  [<ffffffff81051ec9>] ? kmsg_dump+0x79/0x170
[   13.414886]  [<ffffffff81494b02>] oops_end+0xa2/0xf0
[   13.414889]  [<ffffffff81005ca8>] die+0x58/0x90
[   13.414892]  [<ffffffff81494462>] do_general_protection+0x162/0x170
[   13.414895]  [<ffffffff81493bf4>] ? restore_args+0x30/0x30
[   13.414899]  [<ffffffff81493daf>] general_protection+0x1f/0x30
[   13.414906]  [<ffffffffa04a32a6>] ? hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414912]  [<ffffffffa04a32a6>] ? hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414915]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414918]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414920]  [<ffffffff8109ae43>] ? module_put+0x33/0x1b0
[   13.414927]  [<ffffffffa04a32a6>] hci_dev_open+0x96/0x3f0 [bluetooth]
[   13.414930]  [<ffffffff8124f11a>] ? security_capable+0x2a/0x30
[   13.414936]  [<ffffffffa04b0172>] hci_sock_ioctl+0x1e2/0x4b0 [bluetooth]
[   13.414940]  [<ffffffff8107c0a3>] ? up_read+0x23/0x40
[   13.414943]  [<ffffffff813ca9c1>] sock_do_ioctl.constprop.17+0x21/0x60
[   13.414947]  [<ffffffff813caa62>] sock_ioctl+0x62/0x2d0
[   13.414950]  [<ffffffff8115f268>] do_vfs_ioctl+0x98/0x570
[   13.414953]  [<ffffffff8114d901>] ? fget_light+0x3c1/0x430
[   13.414957]  [<ffffffff8149ac1c>] ? sysret_check+0x27/0x62
[   13.414960]  [<ffffffff8115f7d1>] sys_ioctl+0x91/0xa0
[   13.414963]  [<ffffffff8149abeb>] system_call_fastpath+0x16/0x1b
[   14.411762] =============================================================================
[   14.411765] BUG kmalloc-4096: Poison overwritten
[   14.411767] -----------------------------------------------------------------------------
[   14.411768]
[   14.411771] INFO: 0xffff88013b028058-0xffff88013b028058. First byte
0x6a instead of 0x6b
[   14.411785] INFO: Allocated in hci_alloc_dev+0x30/0x90 [bluetooth]
age=1314 cpu=1 pid=565
[   14.411793] INFO: Freed in bt_host_release+0x16/0x20 [bluetooth]
age=305 cpu=0 pid=242
[   14.411796] INFO: Slab 0xffffea00044e88c0 objects=7 used=6
fp=0xffff88013b028000 flags=0x80000000000040c1
[   14.411799] INFO: Object 0xffff88013b028000 @offset=0 fp=0x          (null)
[   14.411801]
[   14.411803]   Object 0xffff88013b028000:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   14.411814]   Object 0xffff88013b028010:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
....  skipped ....
[   14.413340]   Object 0xffff88013b028fc0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   14.413340]   Object 0xffff88013b028fd0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   14.413340]   Object 0xffff88013b028fe0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   14.413340]   Object 0xffff88013b028ff0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[   14.413340]  Redzone 0xffff88013b029000:  bb bb bb bb bb bb bb bb
                      »»»»»»»»
[   14.413340]  Padding 0xffff88013b029040:  5a 5a 5a 5a 5a 5a 5a 5a
                      ZZZZZZZZ
[   14.413340] Pid: 842, comm: systemd-cgroups Tainted: G      D
2.6.39-rc2-00144-gca71856 #121
[   14.413340] Call Trace:
[   14.413340]  [<ffffffff8113d773>] print_trailer+0xf3/0x160
[   14.413340]  [<ffffffff8113d92d>] check_bytes_and_report+0xfd/0x140
[   14.413340]  [<ffffffff8113ea0a>] check_object+0x22a/0x270
[   14.413340]  [<ffffffff8116ff70>] ? seq_read+0x250/0x3f0
[   14.413340]  [<ffffffff8116ff70>] ? seq_read+0x250/0x3f0
[   14.413340]  [<ffffffff8148adab>] alloc_debug_processing+0x91/0x117
[   14.413340]  [<ffffffff8148b3e5>] __slab_alloc.constprop.25+0x2b1/0x2fe
[   14.413340]  [<ffffffff8116ff70>] ? seq_read+0x250/0x3f0
[   14.413340]  [<ffffffff8116fd5f>] ? seq_read+0x3f/0x3f0
[   14.413340]  [<ffffffff8116ff70>] ? seq_read+0x250/0x3f0
[   14.413340]  [<ffffffff8113ffc3>] kmem_cache_alloc_trace+0x243/0x250
[   14.413340]  [<ffffffff8116fd20>] ? seq_lseek+0x120/0x120
[   14.413340]  [<ffffffff8116ff70>] seq_read+0x250/0x3f0
[   14.413340]  [<ffffffff81496ce9>] ? sub_preempt_count+0xa9/0xe0
[   14.413340]  [<ffffffff8116fd20>] ? seq_lseek+0x120/0x120
[   14.413340]  [<ffffffff811a7dd3>] proc_reg_read+0x83/0xc0
[   14.413340]  [<ffffffff8114bb63>] vfs_read+0xb3/0x180
[   14.413340]  [<ffffffff8114bc7d>] sys_read+0x4d/0x90
[   14.413340]  [<ffffffff8149abeb>] system_call_fastpath+0x16/0x1b
[   14.413340] FIX kmalloc-4096: Restoring
0xffff88013b028058-0xffff88013b028058=0x6b
[   14.413340]
[   14.413340] FIX kmalloc-4096: Marking all objects used


So - it looks like disabling BT in runtime is not enough  to avoid problems ;)

So I've blacklisted  bluetooth & btusb -  and made quite several
suspend/resume cycles  -
and without  a single problem.

So I'll keep an eye on this - but so far complete deactivation of BT
either in BIOS or modules blacklisting solves the problem of weird
USB deadlocking.

Zdenek
