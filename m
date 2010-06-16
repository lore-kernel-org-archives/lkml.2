Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0FPDnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:43:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48026 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0FPDm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=aLrxtv9wcDvtHKYAt7WGBMqoje0DF8Pg3Squv8l9RbJUN97RVdl0AijeFK+6bWTicw
         kZrl5/ONrlnANQ7aa7R5ifwP2aN3EJCctw0JxQwZ2G82GWgRivr2cn9GaL4JT9BfT0od
         610cgUsxkef/892HMf5mjBt/L1kQEYvZ5wCME=
MIME-Version: 1.0
In-Reply-To: <20100613160757.GB5623@liondog.tnic>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.KHH.75OFMB@chimera>
	<AANLkTikKQBrH6rvsj-6chzYqd8NUsmEQBGD2jvTvpJVf@mail.gmail.com>
	<20100613160757.GB5623@liondog.tnic>
Date: Tue, 15 Jun 2010 23:42:57 -0400
Message-ID: <AANLkTiltJI8I5zMdzBF1fRIRkgq6K71aaRfrdNHGDrD6@mail.gmail.com>
Subject: Re: [Bug #16054] UML broken for CONFIG_SLAB
From: Parag Warudkar <parag.lkml@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Parag Warudkar <parag.lkml@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 12:07 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Parag Warudkar <parag.lkml@gmail.com>
> Date: Sun, Jun 13, 2010 at 11:35:34AM -0400
>
>> On Sun, Jun 13, 2010 at 10:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16054
>> > Subject         : UML broken for CONFIG_SLAB
>> > Submitter       : Parag Warudkar <parag.lkml@gmail.com>
>> > Date            : 2010-05-23 21:40 (22 days old)
>> > Message-ID      : <alpine.DEB.2.00.1005231149100.605@parag-laptop>
>> > References      : http://marc.info/?l=linux-kernel&m=127465083806617&w=2
>>
>> Borislav,
>>
>> I believe both of the issues I encountered that are part of this bug
>> entry (missing/superfluous slab inclusion issues and cfq related boot
>> crash due to popcnt/hweight stuff) have a known fix [1] but I am not
>> sure if any of it actually landed in -git. Quick search through
>> git.kernel.org log doesn't show anything relevant.
>
> I don't know whether the SLAB issue is related but
> the hweight fix is in -tip and hasn't gone mainline yet:
> http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6
>

I applied the fix by hand and still no dice. So although
cfq_close_cooperator still shows up in the oops - this seems to be
unrelated to the hweight fix?

I should update the bug report - SLAB is separate issue, cfq one is
another and happens with SLUB.

Thanks

Parag


Modules linked in:
Pid: 30, comm: kblockd/0 Not tainted 2.6.35-rc3
RIP: 0033:[<00000000600ea2e0>]
RSP: 00000000601ff680  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000080481800 RCX: 0000000000050000
RDX: 0000000000000000 RSI: 0000000000001c10 RDI: 0000000000000000
RBP: 00000000601ff690 R08: 0000000000001c10 R09: 000000000000001e
R10: 0000000000000001 R11: 0000000060278b28 R12: 00000000805af3c0
R13: 00000000805af3c0 R14: 00000000805ae7b0 R15: 0000000000000001
Call Trace:
601ff178:  [<60014a79>] segv+0x70/0x212
601ff188:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff258:  [<60014c7a>] segv_handler+0x5f/0x65
601ff288:  [<60021680>] sig_handler_common+0x84/0x98
601ff310:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff3b8:  [<600217c6>] sig_handler+0x30/0x3b
601ff3d8:  [<600219f8>] handle_signal+0x6d/0xa3
601ff428:  [<600233b0>] hard_handler+0x10/0x14
601ff4e8:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff538:  [<60029a35>] try_to_wake_up+0x82/0x94
601ff588:  [<60029a54>] default_wake_function+0xd/0xf
601ff598:  [<60040bbb>] autoremove_wake_function+0x11/0x34
601ff5b8:  [<60040c06>] wake_bit_function+0x28/0x2e
601ff5d8:  [<6007920b>] kmem_cache_free+0x85/0x92
601ff618:  [<60057406>] mempool_free_slab+0x12/0x14
601ff628:  [<600574d4>] mempool_free+0x6f/0x76
601ff658:  [<6009e47e>] bio_free+0x4d/0x52
601ff678:  [<600ea2ce>] cfq_close_cooperator+0x135/0x160
601ff698:  [<600ea70b>] cfq_completed_request+0x375/0x4db
601ff6f8:  [<600dee9a>] elv_completed_request+0x4e/0xaf
601ff718:  [<600e036a>] __blk_put_request+0x37/0xbd
601ff748:  [<600e057b>] blk_finish_request+0x18b/0x198
601ff788:  [<600e0831>] blk_end_bidi_request+0x38/0x4b
601ff7b8:  [<600e0876>] blk_end_request+0xb/0xd
601ff7c8:  [<6001cf70>] ubd_intr+0x55/0xd7
601ff808:  [<600527d2>] handle_IRQ_event+0x20/0x9a
601ff838:  [<600528b9>] __do_IRQ+0x6d/0xb0
601ff868:  [<6001217d>] do_IRQ+0x27/0x3f
601ff898:  [<6001234d>] sigio_handler+0x4b/0x5f
601ff8b8:  [<60021680>] sig_handler_common+0x84/0x98
601ff8d8:  [<600122f9>] reactivate_fd+0x54/0x5d
601ff918:  [<6001cf8b>] ubd_intr+0x70/0xd7
601ff938:  [<60054856>] rcu_qsctr_help+0x41/0x4a
601ff968:  [<600549f6>] rcu_sched_qs+0x1f/0x34
601ff988:  [<60054a98>] rcu_enter_nohz+0x21/0x25
601ff9a8:  [<600163d2>] free_irqs+0x72/0xd4
601ff9e8:  [<600216df>] unblock_signals+0x4b/0x5d
601ffa08:  [<6002166d>] sig_handler_common+0x71/0x98
601ffa90:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ffab0:  [<6002480a>] __delay+0xa/0x14
601ffb38:  [<600217c6>] sig_handler+0x30/0x3b
601ffb58:  [<600219f8>] handle_signal+0x6d/0xa3
601ffba8:  [<600233b0>] hard_handler+0x10/0x14
601ffc68:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160

Kernel panic - not syncing: Segfault with no mm
Call Trace:
601ff088:  [<6016916f>] panic+0xe4/0x14f
601ff0e8:  [<6004db5b>] is_module_text_address+0x9/0x11
601ff0f8:  [<6003ece4>] __kernel_text_address+0x65/0x6b
601ff100:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff118:  [<60013a12>] show_trace+0x8e/0x95
601ff148:  [<60026e14>] show_regs+0x2b/0x2f
601ff178:  [<60014b03>] segv+0xfa/0x212
601ff188:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff258:  [<60014c7a>] segv_handler+0x5f/0x65
601ff288:  [<60021680>] sig_handler_common+0x84/0x98
601ff310:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff3b8:  [<600217c6>] sig_handler+0x30/0x3b
601ff3d8:  [<600219f8>] handle_signal+0x6d/0xa3
601ff428:  [<600233b0>] hard_handler+0x10/0x14
601ff4e8:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff538:  [<60029a35>] try_to_wake_up+0x82/0x94
601ff588:  [<60029a54>] default_wake_function+0xd/0xf
601ff598:  [<60040bbb>] autoremove_wake_function+0x11/0x34
601ff5b8:  [<60040c06>] wake_bit_function+0x28/0x2e
601ff5d8:  [<6007920b>] kmem_cache_free+0x85/0x92
601ff618:  [<60057406>] mempool_free_slab+0x12/0x14
601ff628:  [<600574d4>] mempool_free+0x6f/0x76
601ff658:  [<6009e47e>] bio_free+0x4d/0x52
601ff678:  [<600ea2ce>] cfq_close_cooperator+0x135/0x160
601ff698:  [<600ea70b>] cfq_completed_request+0x375/0x4db
601ff6f8:  [<600dee9a>] elv_completed_request+0x4e/0xaf
601ff718:  [<600e036a>] __blk_put_request+0x37/0xbd
601ff748:  [<600e057b>] blk_finish_request+0x18b/0x198
601ff788:  [<600e0831>] blk_end_bidi_request+0x38/0x4b
601ff7b8:  [<600e0876>] blk_end_request+0xb/0xd
601ff7c8:  [<6001cf70>] ubd_intr+0x55/0xd7
601ff808:  [<600527d2>] handle_IRQ_event+0x20/0x9a
601ff838:  [<600528b9>] __do_IRQ+0x6d/0xb0
601ff868:  [<6001217d>] do_IRQ+0x27/0x3f
601ff898:  [<6001234d>] sigio_handler+0x4b/0x5f
601ff8b8:  [<60021680>] sig_handler_common+0x84/0x98
601ff8d8:  [<600122f9>] reactivate_fd+0x54/0x5d
601ff918:  [<6001cf8b>] ubd_intr+0x70/0xd7
601ff938:  [<60054856>] rcu_qsctr_help+0x41/0x4a
601ff968:  [<600549f6>] rcu_sched_qs+0x1f/0x34
601ff988:  [<60054a98>] rcu_enter_nohz+0x21/0x25
601ff9a8:  [<600163d2>] free_irqs+0x72/0xd4
601ff9e8:  [<600216df>] unblock_signals+0x4b/0x5d
601ffa08:  [<6002166d>] sig_handler_common+0x71/0x98
601ffa90:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ffab0:  [<6002480a>] __delay+0xa/0x14
601ffb38:  [<600217c6>] sig_handler+0x30/0x3b
601ffb58:  [<600219f8>] handle_signal+0x6d/0xa3
601ffba8:  [<600233b0>] hard_handler+0x10/0x14
601ffc68:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160


Modules linked in:
Pid: 30, comm: kblockd/0 Not tainted 2.6.35-rc3
RIP: 0033:[<00007f7624535d57>]
RSP: 00007fff27cfa1c8  EFLAGS: 00000202
RAX: 0000000000000000 RBX: 0000000000001482 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000013 RDI: 0000000000001482
RBP: 00007fff27cfa200 R08: 0000000000000000 R09: 00007fff27cfa200
R10: 00007fff27cf9f70 R11: 0000000000000202 R12: 000000000000147e
R13: 00007f7624ca36a8 R14: 00007fff27cfa410 R15: 00007fff27cfc66e
Call Trace:
601ff018:  [<60014de7>] panic_exit+0x2f/0x45
601ff020:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff038:  [<600441f2>] notifier_call_chain+0x32/0x5e
601ff078:  [<60044238>] atomic_notifier_call_chain+0xf/0x11
601ff088:  [<6016918a>] panic+0xff/0x14f
601ff0e8:  [<6004db5b>] is_module_text_address+0x9/0x11
601ff0f8:  [<6003ece4>] __kernel_text_address+0x65/0x6b
601ff100:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff118:  [<60013a12>] show_trace+0x8e/0x95
601ff148:  [<60026e14>] show_regs+0x2b/0x2f
601ff178:  [<60014b03>] segv+0xfa/0x212
601ff188:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff258:  [<60014c7a>] segv_handler+0x5f/0x65
601ff288:  [<60021680>] sig_handler_common+0x84/0x98
601ff310:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff3b8:  [<600217c6>] sig_handler+0x30/0x3b
601ff3d8:  [<600219f8>] handle_signal+0x6d/0xa3
601ff428:  [<600233b0>] hard_handler+0x10/0x14
601ff4e8:  [<600ea2e0>] cfq_close_cooperator+0x147/0x160
601ff538:  [<60029a35>] try_to_wake_up+0x82/0x94
601ff588:  [<60029a54>] default_wake_function+0xd/0xf
601ff598:  [<60040bbb>] autoremove_wake_function+0x11/0x34
601ff5b8:  [<60040c06>] wake_bit_function+0x28/0x2e
601ff5d8:  [<6007920b>] kmem_cache_free+0x85/0x92
601ff618:  [<60057406>] mempool_free_slab+0x12/0x14
601ff628:  [<600574d4>] mempool_free+0x6f/0x76
601ff658:  [<6009e47e>] bio_free+0x4d/0x52
601ff678:  [<600ea2ce>] cfq_close_cooperator+0x135/0x160
601ff698:  [<600ea70b>] cfq_completed_request+0x375/0x4dbSegmentation fault
