Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2AUD3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 22:29:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61496 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2AUD3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 22:29:33 -0500
Message-ID: <4F1A3080.2080701@gmail.com>
Date: Sat, 21 Jan 2012 03:26:56 +0000
From: Vasco Dias <rafa.vasco@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, mikew@google.com,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Problem with efibootmgr on asus 1215b
References: <CAH1LqYj0pPnv-2dTx5gCXO=S8ypk_fSO6PDpwX-dToJp9ZWOnQ@mail.gmail.com> <1327060106.3618.53.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1327060106.3618.53.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 11:48 AM, Matt Fleming wrote:
> (Adding Matthew Garrett to Cc..)
>
> On Sun, 2012-01-01 at 06:20 +0000, Vasco Dias wrote:
>> Hi,
>>
>> the problem is that after booting the system from uefi (with the uefi
>> shell) and after loading
>> the module efivars i can't create a new boot entry because the system
>> just locks completely.
>
> [...]
>
>> I'm reporting here on the list after asking about it on the arch linux
>> forums ( https://bbs.archlinux.org/viewtopic.php?pid=1024451 ).
>
> Your report on the above forum shows a page fault in the dmesg. Are both
> the page fault and lockup reproducible?
>
> I think that the page fault is the most interesting error,
>
> [  313.519164] EFI Variables Facility v0.08 2004-May-17
> [  441.370854] BUG: unable to handle kernel paging request at 00000000ffe1fbc8
> [  441.370854] IP: [<ffff8800a7d44c1f>] 0xffff8800a7d44c1e
> [  441.370854] PGD 131775067 PUD 0
> [  441.370854] Oops: 0000 [#1] PREEMPT SMP
> [  441.370854] CPU 1
> [  441.370854] Modules linked in: nls_cp437 vfat fat efivars ipv6 fuse btusb bluetooth uvcvideo videodev media v4l2_compat_ioctl32 joydev snd_hda_codec_realtek bcma arc4 snd_hda_codec_hdmi brcmsmac(C) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm brcmutil(C) ohci_hcd snd_timer mac80211 snd eeepc_wmi i2c_piix4 asus_wmi soundcore ehci_hcd cfg80211 sparse_keymap serio_raw pci_hotplug snd_page_alloc rfkill crc_ccitt xhci_hcd usbcore pcspkr psmouse evdev sp5100_tco k10temp atl1c wmi processor battery video ac button ext4 mbcache jbd2 crc16 sd_mod ahci libahci libata scsi_mod radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> [  441.416767]
> [  441.416767] Pid: 1217, comm: efibootmgr Tainted: G         C  3.0-ARCH #1 ASUSTeK Computer INC. 1215B/1215B
> [  441.416767] RIP: 0010:[<ffff8800a7d44c1f>]  [<ffff8800a7d44c1f>] 0xffff8800a7d44c1e
> [  441.416767] RSP: 0018:ffff880132463ab0  EFLAGS: 00010082
> [  441.416767] RAX: 00000000ffe1fbc8 RBX: 000000000000000a RCX: 00000000ffe1fbc8
> [  441.416767] RDX: 0000000000000000 RSI: ffff880132463bea RDI: ffff880132463b40
> [  441.416767] RBP: 00000000ffe1fbc8 R08: 0000000000000000 R09: 0000000000000038
> [  441.416767] R10: 00000000000000ff R11: ffffc9001101fbca R12: 0000000000000001
> [  441.416767] R13: 0000000000000000 R14: ffffc9001101fbc8 R15: ffff880132463be0
> [  441.416767] FS:  00007fb40f3d2700(0000) GS:ffff88013ed00000(0000) knlGS:0000000000000000
> [  441.416767] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  441.416767] CR2: 00000000ffe1fbc8 CR3: 00000001328c6000 CR4: 00000000000006e0
> [  441.416767] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  441.416767] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  441.416767] Process efibootmgr (pid: 1217, threadinfo ffff880132462000, task ffff88013210cf10)
> [  441.416767] Stack:
> [  441.416767]  ffffc90011010000 ffff880132463b78 0000000000010000 ffff8800a7d4401d
> [  441.416767]  0000000000000070 ffff88013249b400 0000000000000084 ffff8800a7d45738
> [  441.416767]  ffffc9001101fbc8 ffff8800a7d4331c 000000000000000a ffffc9001101fbc8
> [  441.416767] Call Trace:
> [  441.416767]  [<ffffffff811c71ed>] ? open+0x10d/0x1b0
> [  441.416767]  [<ffffffff81155a93>] ? __dentry_open+0x323/0x390
> [  441.416767]  [<ffffffff811c70e0>] ? bin_vma_open+0x70/0x70
> [  441.416767]  [<ffffffff8104378b>] ? efi_call5+0x4b/0x80
> [  441.416767]  [<ffffffff810431cf>] ? virt_efi_set_variable+0x2f/0x40
> [  441.416767]  [<ffffffffa060fea3>] ? efivar_create+0x1e3/0x280 [efivars]
> [  441.416767]  [<ffffffff811c73a4>] ? write+0x114/0x190
> [  441.416767]  [<ffffffff81157a5f>] ? vfs_write+0xaf/0x180
> [  441.416767]  [<ffffffff81157d8a>] ? sys_write+0x4a/0x90
> [  441.416767]  [<ffffffff813f4c42>] ? system_call_fastpath+0x16/0x1b
> [  441.416767] Code: ec 01 75 f0 41 bc 01 00 00 00 e8 e5 fb ff ff e8 e4 fc ff ff 33 c0 44 0f b7 c0 66 3b c3 73 20 41 0f b7 c0 41 0f b7 d0 03 c5 8b c8<8a>  00 42 38 04 3a 75 0a 66 45 03 c4 66 44 3b c3 72 e2 33 c0 66
> [  441.416767] RIP  [<ffff8800a7d44c1f>] 0xffff8800a7d44c1e
> [  441.416767]  RSP<ffff880132463ab0>
> [  441.416767] CR2: 00000000ffe1fbc8
> [  441.416767] ---[ end trace 8bfd3b1218aba64c ]---
>
> As Mike said, it looks like the runtime code is trying to access an MMIO
> address, which is weird.
>
> Mike, you also commented that,
>
> 	"It would appear that the efi-provided runtime services code is
> 	trying to do a mmio read from 0xffe1fbc8, which is in the IO hole
> 	(reading from *some* device, unsure which).  Either way, it looks
> 	like the runtime service code is probably 32bit, and isn't
> 	thunking out of paging mode, so the mmio access is totally bogus."
>
> What lead you to think that the runtime service code is 32bit? If that
> were the case I wouldn't have expected the machine to make it to
> userland. But I'm honestly not quite sure what's going on.
>
> Perhaps we should blacklist this EFI firmware from using efivars
> (assuming the rest of the firmware implementation is sound)?
>

I think that the page fault also happens (at least the other report on 
ubuntu 
http://askubuntu.com/questions/70025/how-do-i-install-on-an-uefi-asus-1215b-netbook 
seems to have it), but like I said the system completely dies and it's 
difficult to check the logs.

I was lucky that time because somehow the system kept running fine for a 
while. Even if I check all the logs after a reboot nothing appears 
related to it.

Even yesterday I tried again when the kernel updated to 3.2.1, the 
system died, I waited at least 30 minutes before rebooting and nothing 
on the logs.

So, if there's a better way for me to help with  the information you 
need please tell :)
