Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0HSJ6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0HSJ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:58:34 -0400
Message-ID: <4C6D003F.1030205@redhat.com>
Date: Thu, 19 Aug 2010 12:58:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
References: <20100819095429.GA5201@swordfish.minsk.epam.com>
In-Reply-To: <20100819095429.GA5201@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/19/2010 12:54 PM, Sergey Senozhatsky wrote:
> Hello,
>
> Got this trace (while echo 1>  /sys/devices/system/cpu/cpu3/online):
>
> [  313.320295] lockdep: fixing up alternatives.
> [  313.320303] SMP alternatives: switching to SMP code
> [  313.331090] Booting Node 0 Processor 3 APIC 0x5
> [  313.487258] kvm: enabling virtualization on CPU3
> [  313.487326] NMI watchdog enabled, takes one hw-pmu counter.
> [  313.489627] coretemp coretemp.3: TjMax is 105 C.
> [  315.344223] lockdep: fixing up alternatives.
> [  315.344236] Booting Node 0 Processor 2 APIC 0x4
> [  315.487292] ------------[ cut here ]------------
> [  315.487322] kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978!
> [  315.487352] invalid opcode: 0000 [#1] PREEMPT SMP
> [  315.487388] last sysfs file: /sys/devices/system/cpu/cpu2/online
> [  315.487415] CPU 2
> [  315.487425] Modules linked in: kvm_intel kvm ipv6 snd_seq_dummy ac battery snd_seq_oss snd_seq_midi_event snd_hwdep snd_seq snd_seq_device wmi usbhid hid snd_hda_codec_atihdmi radeon button snd_hda_codec_realtek snd_pcm_oss
> snd_mixer_oss snd_hda_intel snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc broadcom tg3 libphy psmouse serio_raw evdev ttm drm_kms_helper ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
> [  315.487728]
> [  315.487739] Pid: 27687, comm: qemu-kvm Not tainted 2.6.36-rc1-dbg-git2-00264-gd5a1964-dirty #134 Aspire 5741G    /Aspire 5741G
> [  315.487787] RIP: 0010:[<ffffffffa02f2446>]  [<ffffffffa02f2446>] kvm_handle_fault_on_reboot+0xf/0x11 [kvm]
> [  315.487839] RSP: 0000:ffff88013c333b18  EFLAGS: 00010246
> [  315.487863] RAX: ffff88013c333b40 RBX: ffff88012dcb0000 RCX: ffff88010c7e9000
> [  315.487893] RDX: ffff880002280000 RSI: ffff8801563e8728 RDI: ffff88010c7e9000
> [  315.487922] RBP: ffff88013c333b18 R08: ffff880002213cd0 R09: 00000000000003c7
> [  315.487952] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
> [  315.487982] R13: ffff88010c7e9000 R14: ffff8801563e8000 R15: 0000000000000000
> [  315.488012] FS:  00007f15014be710(0000) GS:ffff880002280000(0000) knlGS:0000000000000000
> [  315.488046] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [  315.488070] CR2: 0000000000000000 CR3: 0000000154b42000 CR4: 00000000000006e0
> [  315.488100] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  315.488130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  315.488160] Process qemu-kvm (pid: 27687, threadinfo ffff88013c332000, task ffff8801563e8000)
> [  315.488194] Stack:
> [  315.488205]  ffff88013c333b68 ffffffffa026d0a2 ffff88013c333b58 ffffffff81062e91
> [  315.488244]<0>  ffff8801563e8000 000000010c7e9000 ffff880157d78000 ffff88012dcb0000
> [  315.488290]<0>  0000000000000002 0000000000014240 ffff88013c333b98 ffffffffa02fb4cc
> [  315.488337] Call Trace:
> [  315.488353]  [<ffffffffa026d0a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
> [  315.488384]  [<ffffffff81062e91>] ? mark_held_locks+0x50/0x72
> [  315.488415]  [<ffffffffa02fb4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
> [  315.488446]  [<ffffffffa02f2cd8>] kvm_sched_in+0xd/0xf [kvm]
> [  315.488474]  [<ffffffff8102de1f>] finish_task_switch+0x90/0xd7
> [  315.488500]  [<ffffffff8102dd8f>] ? finish_task_switch+0x0/0xd7
> [  315.488529]  [<ffffffff81373381>] schedule+0x81d/0x8f2
> [  315.488553]  [<ffffffff81062e91>] ? mark_held_locks+0x50/0x72
> [  315.488584]  [<ffffffffa030d82c>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
> [  315.488617]  [<ffffffffa02f5057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
> [  315.488645]  [<ffffffff81052dbd>] ? autoremove_wake_function+0x0/0x34
> [  315.488678]  [<ffffffffa030024d>] kvm_arch_vcpu_ioctl_run+0x97d/0xca0 [kvm]
> [  315.488712]  [<ffffffffa030016a>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xca0 [kvm]
> [  315.488743]  [<ffffffff813747d1>] ? mutex_lock_nested+0x2f3/0x31b
> [  315.488771]  [<ffffffff8103441b>] ? sub_preempt_count+0x92/0xa5
> [  315.488800]  [<ffffffffa02f4164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
> [  315.488829]  [<ffffffff81376247>] ? _raw_spin_unlock_irq+0x3c/0x59
> [  315.488859]  [<ffffffff810e8d5b>] do_vfs_ioctl+0x4c1/0x502
> [  315.488885]  [<ffffffff810dc496>] ? fget_light+0xe0/0xf8
> [  315.488909]  [<ffffffff810dc408>] ? fget_light+0x52/0xf8
> [  315.490162]  [<ffffffff810e8ded>] sys_ioctl+0x51/0x74
> [  315.491403]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> [  315.492649] Code: 2f 02 00 85 c0 75 13 ba 01 00 00 00 31 f6 48 c7 c7 bb 27 2f a0 e8 6a db d4 e0 c9 c3 55 80 3d 59 2f 02 00 00 48 89 e5 74 02 eb fe<0f>  0b 55 48 89 e5 53 48 89 f3 48 83 ec 08 48 8b 87 90 00 00 00
> [  315.495975] RIP  [<ffffffffa02f2446>] kvm_handle_fault_on_reboot+0xf/0x11 [kvm]
> [  315.498317]  RSP<ffff88013c333b18>
> [  315.510526] ---[ end trace ac38cfaaa84a0bdf ]---
> [  315.510763] kvm: enabling virtualization on CPU2
> [  315.513518] note: qemu-kvm[27687] exited with preempt_count 1
> [  315.514858] NMI watchdog enabled, takes one hw-pmu counter.
>
>

What kernel is this?

-- 
error compiling committee.c: too many arguments to function

