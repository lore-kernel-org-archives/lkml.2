Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0DNGRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:17:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38950 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0DNGRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:17:52 -0400
Date: Wed, 14 Apr 2010 08:17:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: 2.6.34-rc4 : OOPS in unmap_vma
Message-ID: <20100414061746.GA23153@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
	Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org
References: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Parag Warudkar <parag.lkml@gmail.com>
Date: Tue, Apr 13, 2010 at 09:53:46PM -0400

(adding kexec people to Cc)

> Not sure if this is related to the recent mm/vma fixes - got this 
> while rebooting (kexec) latest git -

[..]

> [   11.437727] BUG: unable to handle kernel paging request at 0000000000002203
> [   11.437745] IP: [<ffffffff810e4107>] unmap_vmas+0x227/0xa90
> [   11.437764] PGD 0 
> [   11.437771] Oops: 0000 [#1] PREEMPT SMP 
> [   11.437782] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:86:09.4/local_cpus
> [   11.437792] CPU 1 
> [   11.437796] Modules linked in: binfmt_misc lp kvm_intel kvm tpm_infineon snd_hda_codec_atihdmi snd_hda_codec_analog fbcon tileblit font bitblit softcursor snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi joydev snd_seq_midi_event iwlagn radeon snd_seq iwlcore ttm snd_timer drm_kms_helper hp_accel mac80211 hp_wmi sdhci_pci ppdev sdhci snd_seq_device coretemp intel_agp yenta_socket lis3lv02d rsrc_nonstatic drm cfg80211 input_polldev parport_pc video snd tpm_tis psmouse serio_raw mmc_core pcmcia_core tpm parport output tpm_bios rfkill wmi soundcore i2c_algo_bit led_class snd_page_alloc acpi_cpufreq agpgart ext3 jbd mbcache xfs exportfs ahci libata e1000e ehci_hcd
> [   11.437986] 
> [   11.437994] Pid: 484, comm: udevd Not tainted 2.6.34-rc4 #19 30E7/HP EliteBook 8530p
> [   11.438001] RIP: 0010:[<ffffffff810e4107>]  [<ffffffff810e4107>] unmap_vmas+0x227/0xa90
> [   11.438015] RSP: 0018:ffff88013dae5cb8  EFLAGS: 00010206
> [   11.438023] RAX: 0000000000002203 RBX: 00007f5fffe49000 RCX: 00007f5fffe49fff
> [   11.438030] RDX: 0000000000001a13 RSI: ffff880001d0d818 RDI: 00007f5fffe4a000
> [   11.438039] RBP: ffff88013dae5df8 R08: 0000000000000000 R09: 0000000000000000
> [   11.438047] R10: ffff8800019eff68 R11: dead000000100100 R12: 00007f5fffe49000
> [   11.438055] R13: 0000000000005e00 R14: ffff88013dacf240 R15: ffff88013ded9500
> [   11.438064] FS:  0000000000000000(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
> [   11.438072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   11.438078] CR2: 0000000000002203 CR3: 0000000001805000 CR4: 00000000000406e0
> [   11.438085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   11.438094] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   11.438102] Process udevd (pid: 484, threadinfo ffff88013dae4000, task ffff88013dae8000)
> [   11.438108] Stack:
> [   11.438112]  0000000000000000 0000000000000000 0000000000000000 ffffea00045150c8
> [   11.438125] <0> ffff88013fb0daa8 0000000000000000 ffff88013dae5e08 ffff88013ded9500
> [   11.438138] <0> ffff88013dae5fd8 000000013fb0dab0 ffffffffffffffff 0000000000000000
> [   11.438155] Call Trace:
> [   11.438170]  [<ffffffff810e9cfb>] exit_mmap+0xcb/0x1d0
> [   11.438180]  [<ffffffff81045772>] mmput+0x42/0x110
> [   11.438190]  [<ffffffff8104a419>] exit_mm+0x109/0x140
> [   11.438203]  [<ffffffff813f87c6>] ? _raw_spin_unlock_irq+0x26/0x50
> [   11.438213]  [<ffffffff8108ce20>] ? acct_collect+0x160/0x1b0
> [   11.438222]  [<ffffffff8104c47c>] do_exit+0x68c/0x7a0
> [   11.438233]  [<ffffffff8104c5e1>] do_group_exit+0x51/0xc0
> [   11.438242]  [<ffffffff8104c667>] sys_exit_group+0x17/0x20
> [   11.438253]  [<ffffffff810030f2>] system_call_fastpath+0x16/0x1b
> [   11.438260] Code: b8 00 00 00 00 80 ff ff ff 48 21 45 80 48 8b 45 80 48 ff c8 48 3b 85 40 ff ff ff 48 8b 85 50 ff ff ff 48 0f 42 7d 80 48 89 7d 80 <48> 8b 38 48 85 ff 0f 84 f5 04 00 00 48 b8 fb 0f 00 00 00 c0 ff

hmm, it doesn't look like it. Your code translates to something like

   0:   b8 00 00 00 00          mov    $0x0,%eax
   5:   80 ff ff                cmp    $0xff,%bh
   8:   ff 48 21                decl   0x21(%rax)
   b:   45 80 48 8b 45          rex.RB orb    $0x45,-0x75(%r8)
  10:   80 48 ff c8             orb    $0xc8,-0x1(%rax)
  14:   48 3b 85 40 ff ff ff    cmp    -0xc0(%rbp),%rax
  1b:   48 8b 85 50 ff ff ff    mov    -0xb0(%rbp),%rax
  22:   48 0f 42 7d 80          cmovb  -0x80(%rbp),%rdi
  27:   48 89 7d 80             mov    %rdi,-0x80(%rbp)
  2b:*  48 8b 38                mov    (%rax),%rdi     <-- trapping instruction
  2e:   48 85 ff                test   %rdi,%rdi
  31:   0f 84 f5 04 00 00       je     0x52c
  37:   48                      rex.W
  38:   b8 fb 0f 00 00          mov    $0xffb,%eax
  3d:   00 c0                   add    %al,%al
  3f:   ff                      .byte 0xff


which I could correlate with what I get here (comments added):

	.loc 1 1051 0
	movabsq	$549755813888, %rax	#, tmp158	PGDIR_SIZE
.LVL392:
	leaq	(%r12,%rax), %rax	#,
	movq	%rax, -88(%rbp)	#, %sfp
	movabsq	$-549755813888, %rax	#, tmp159	PGDIR_MASK
	andq	%rax, -88(%rbp)	# tmp159, %sfp
	movq	-88(%rbp), %rdx	# %sfp, tmp160
	movq	-72(%rbp), %rax	# %sfp, tmp161
	decq	%rdx	# tmp160			__boundary
	decq	%rax	# tmp161			__end
	cmpq	%rax, %rdx	# tmp161, tmp160	rFLAGS
	movq	-72(%rbp), %rax	# %sfp,
	cmovb	-88(%rbp), %rax	# %sfp,,
	movq	-112(%rbp), %rdx	# %sfp,		pgd
	movq	%rax, -88(%rbp)	#, %sfp
	movq	(%rdx), %rax	# <variable>.pgd, pgd$pgd

and if this output is correct and if you scroll back a little in your
assemble output, you should probably see that the value computed in
pgd_offset() is being saved in -0x80(%rbp) and reloaded again for use.

So you oops when dereferencing that pgd value in %rax (%rdx in my case),
*pgd in pgd_none_or_clear_bad(pgd) which is called in the below fragment
of unmap_page_range().

	pgd = pgd_offset(vma->vm_mm, addr);
	do {
		next = pgd_addr_end(addr, end);
		if (pgd_none_or_clear_bad(pgd)) {
			(*zap_work)--;
			continue;
		}
		next = zap_pud_range(tlb, vma, pgd, addr, next,
						zap_work, details);
	} while (pgd++, addr = next, (addr != end && *zap_work > 0));

so it looks like it tries to find a page table rooted at that address
but the pointer value of 0000000000002203 is bogus.

Which might be because when we iterate over the vmas in unmap_vmas, one
of those vma->vm_start is invalid...

-- 
Regards/Gruss,
    Boris.
