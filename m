Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2FDRCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:02:38 -0400
Received: from natasha.panasas.com ([67.152.220.90]:43292 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2FDRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:02:37 -0400
Message-ID: <4FCCE866.7050203@panasas.com>
Date: Mon, 4 Jun 2012 19:55:02 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, Jeff Dike <jdike@addtoit.com>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        <alan@linux.intel.com>
Subject: Re: [uml-devel] [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at> <4FCCD224.1020307@suse.cz> <4FCCD44A.3090500@nod.at> <4FCCD70D.5010908@suse.cz> <4FCCD774.5040003@nod.at> <4FCCE1D4.7080805@panasas.com> <4FCCE255.4080705@nod.at>
In-Reply-To: <4FCCE255.4080705@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:29 PM, Richard Weinberger wrote:

> Am 04.06.2012 18:27, schrieb Boaz Harrosh:
>> On 06/04/2012 06:42 PM, Richard Weinberger wrote:
>>
>>> Am 04.06.2012 17:41, schrieb Jiri Slaby:
>>>> Hmm, I remember. I suggest you to split the patch into several pieces.
>>>> For example moving the code from ->open into ->install can be done
>>>> separately. Otherwise it's hard to tell what's wrong with the patch as
>>>> a whole.
>>>>
>>>> Also, it would be good to see the patch rebased on the top of my
>>>> patch, because tty_port_set/get pieces would be gone from your patch too.
>>>
>>> Okay, I'll redo it!
>>> I've a much cleaner version in my local queue.
>>>
>>
>>
>> Can you send it my way, I'm still running broken, 3.4 Based ?
>>
> 
> Can you please first give Jiri's patches a try?
> 
> [PATCH 12/24] TTY: um/line, add tty_port
> [PATCH 13/24] TTY: um/line, use tty from tty_port
> 


No still crashing the same, way. BTW I do not have a systemd Distro. It's
plain old FC12. Though in the lab I have the same crash with FC15.

The crash is immediately after I login at the initial prompt. (every time)

Here is the crash print, what ever that is worth in UML.
(Can we make the crash dump stack trace a bit less terrible?)

----
Modules linked in: nfsd nfs lockd auth_rpcgss nfs_acl sunrpc osd libosd ipv6 binfmt_misc [last unloaded: scsi_wait_scan]
Pid: 1243, comm: login Not tainted 3.4.0-pnfs+
RIP: 0033:[<00000000601bbf7f>]
RSP: 0000000077ed7ad0  EFLAGS: 00010202
RAX: 00000000601bbf6b RBX: 00000000000001d8 RCX: 000000000000000b
RDX: 00000000600206dc RSI: 00000000601c4c14 RDI: 00000000000001d8
RBP: 0000000077ed7b20 R08: 0000000000000000 R09: 0000000077ed7c30
R10: 0000000000000000 R11: 0000003ea3882a83 R12: 0000000000000000
R13: 0000000000000fff R14: 0000000000000002 R15: 0000000077ed7c30
Call Trace: 
603556c8:  [<6001c6ac>] segv+0x2f6/0x31c
603556e0:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355708:  [<6007d89f>] rcu_sched_qs+0xb8/0xbc
60355740:  [<600191c8>] do_IRQ+0x0/0x54
60355748:  [<6002bdf3>] os_waiting_for_events+0x0/0xb9
603557a8:  [<60018d98>] to_irq_stack+0x0/0xa1
603557b8:  [<6001c75e>] segv_handler+0x8c/0x96
603557d8:  [<600194c9>] sigio_handler+0x88/0x93
60355808:  [<6002d733>] sig_handler_common+0x9f/0xb3
60355860:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355870:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355878:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355890:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
603558b0:  [<601b331d>] radix_tree_lookup_slot+0x4d/0x5c
60355920:  [<6001669c>] _einittext+0x18d1/0x2b55
60355930:  [<600161a8>] _einittext+0x13dd/0x2b55
60355a08:  [<6001669c>] _einittext+0x18d1/0x2b55
60355aa0:  [<60017e28>] _init+0x508/0x870
60355aa8:  [<60018d98>] to_irq_stack+0x0/0xa1
60355b28:  [<60017e28>] _init+0x508/0x870
60355b38:  [<6002d906>] sig_handler+0x4c/0x5e
60355b58:  [<6002db99>] hard_handler+0x89/0xcb
60355c30:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355c48:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355c50:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355c68:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121

Kernel panic - not syncing: Kernel mode fault at addr 0x1dc, ip 0x601bbf7f
Call Trace: 
603555b8:  [<60280af4>] panic+0x170/0x2e0
603555f0:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
603555f8:  [<60280984>] panic+0x0/0x2e0
60355610:  [<6006d5fd>] __module_text_address+0x14/0x5a
60355628:  [<6006d653>] is_module_text_address+0x10/0x18
60355638:  [<60050ced>] __kernel_text_address+0x97/0x9d
60355640:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355658:  [<6001afc0>] show_trace+0xd4/0xdf
603556c8:  [<6001c6d2>] segv_handler+0x0/0x96
603556e0:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355708:  [<6007d89f>] rcu_sched_qs+0xb8/0xbc
60355740:  [<600191c8>] do_IRQ+0x0/0x54
60355748:  [<6002bdf3>] os_waiting_for_events+0x0/0xb9
603557a8:  [<60018d98>] to_irq_stack+0x0/0xa1
603557b8:  [<6001c75e>] segv_handler+0x8c/0x96
603557d8:  [<600194c9>] sigio_handler+0x88/0x93
60355808:  [<6002d733>] sig_handler_common+0x9f/0xb3
60355860:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355870:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355878:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355890:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
603558b0:  [<601b331d>] radix_tree_lookup_slot+0x4d/0x5c
60355920:  [<6001669c>] _einittext+0x18d1/0x2b55
60355930:  [<600161a8>] _einittext+0x13dd/0x2b55
60355a08:  [<6001669c>] _einittext+0x18d1/0x2b55
60355aa0:  [<60017e28>] _init+0x508/0x870
60355aa8:  [<60018d98>] to_irq_stack+0x0/0xa1
60355b28:  [<60017e28>] _init+0x508/0x870
60355b38:  [<6002d906>] sig_handler+0x4c/0x5e
60355b58:  [<6002db99>] hard_handler+0x89/0xcb
60355c30:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355c48:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355c50:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355c68:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121


Modules linked in: nfsd nfs lockd auth_rpcgss nfs_acl sunrpc osd libosd ipv6 binfmt_misc [last unloaded: scsi_wait_scan]
Pid: 1243, comm: login Not tainted 3.4.0-pnfs+
RIP: 0033:[<00000030914d8318>]
RSP: 0000007fbfe72740  EFLAGS: 00000202
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: ffffffffffffffff
RDX: 0000007fbfe72710 RSI: 0000000000005404 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000007fbfe74c40 R09: 0000000000000000
R10: 0000007fbfe72710 R11: 0000000000000202 R12: 0000007fbfe74c40
R13: 0000007fbfe72ac7 R14: 0000007fbfe72a50 R15: 0000000000000000
Call Trace: 
60355538:  [<6001c8c5>] panic_exit+0x3e/0x5c
60355540:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355568:  [<60058a76>] notifier_call_chain+0x32/0x5e
603555a8:  [<60058ad2>] atomic_notifier_call_chain+0x1a/0x1c
603555b8:  [<60280b24>] panic+0x1a0/0x2e0
603555f0:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
603555f8:  [<60280984>] panic+0x0/0x2e0
60355610:  [<6006d5fd>] __module_text_address+0x14/0x5a
60355628:  [<6006d653>] is_module_text_address+0x10/0x18
60355638:  [<60050ced>] __kernel_text_address+0x97/0x9d
60355640:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355658:  [<6001afc0>] show_trace+0xd4/0xdf
603556c8:  [<6001c6d2>] segv_handler+0x0/0x96
603556e0:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
60355708:  [<6007d89f>] rcu_sched_qs+0xb8/0xbc
60355740:  [<600191c8>] do_IRQ+0x0/0x54
60355748:  [<6002bdf3>] os_waiting_for_events+0x0/0xb9
603557a8:  [<60018d98>] to_irq_stack+0x0/0xa1
603557b8:  [<6001c75e>] segv_handler+0x8c/0x96
603557d8:  [<600194c9>] sigio_handler+0x88/0x93
60355808:  [<6002d733>] sig_handler_common+0x9f/0xb3
60355860:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355870:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355878:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355890:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
603558b0:  [<601b331d>] radix_tree_lookup_slot+0x4d/0x5c
60355920:  [<6001669c>] _einittext+0x18d1/0x2b55
60355930:  [<600161a8>] _einittext+0x13dd/0x2b55
60355a08:  [<6001669c>] _einittext+0x18d1/0x2b55
60355aa0:  [<60017e28>] _init+0x508/0x870
60355aa8:  [<60018d98>] to_irq_stack+0x0/0xa1
60355b28:  [<60017e28>] _init+0x508/0x870
60355b38:  [<6002d906>] sig_handler+0x4c/0x5e
60355b58:  [<6002db99>] hard_handler+0x89/0xcb
60355c30:  [<601c4c14>] tty_chars_in_buffer+0x0/0x17
60355c48:  [<600206dc>] line_chars_in_buffer+0x0/0x82
60355c50:  [<601bbf6b>] do_raw_spin_lock+0x0/0x121
60355c68:  [<601bbf7f>] do_raw_spin_lock+0x14/0x121
----

BTW I suspect that UML is unable to catch an invalid pointer execution
and just dumps core and exits. Let me explain.

A:
	foo == ((foo_t *)NULL)->member_not_first
 A NULL access backtrace will be generated before UML exit

but ..
B: a function call
	((foo_op *)NULL)->function_member_not_first(...);

 Will crap out without any kind of stack trace.

Is that possible?

Thanks
Boaz
