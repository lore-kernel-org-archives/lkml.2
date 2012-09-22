Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2IVJ50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:57:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53145 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2IVJ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:57:24 -0400
Message-ID: <505D8B81.8090301@kernel.org>
Date: Sat, 22 Sep 2012 10:57:21 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: OOPS/panic in iio_dummy (v3.6-rc6-176-gabef3bd)
References: <201209220413.36295.PeterHuewe@gmx.de> <505D725A.4010708@metafoo.de>
In-Reply-To: <505D725A.4010708@metafoo.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 09:10 AM, Lars-Peter Clausen wrote:
> On 09/22/2012 04:13 AM, Peter Hüwe wrote:
>> Hi,
>>
>> loading iio_dummy results in kernel panic as the call to 
>> iio_buffer_register in iio_dummy_probe is performed with indio_dev->buffer == 
>> NULL and thus the access to indio_dev->buffer->attrs results in this 
>> oops/panic.
>>
>> Thanks,
>> Peter
>>
> 
> Hi,
> 
> I sent a patch or this a couple of days ago. See
> http://comments.gmane.org/gmane.linux.kernel.iio/5550
> 
> - Lars

Sorry, I'd completely forgotten that was queued up in my fixes branch.
As it's only in the dummy driver I've changed my mind and pulled it into
the togreg branch which will merge for 3.7. It's late in the cycle and
we are afterall talking about a fix for 'fake' hardware.

> 
> 
>> Steps to reproduce:
>>
>> #modprobe iio_dummy
>> iio_dummy: module is from the staging directory, the quality is unknown, you 
>> have been warned.
>>
>> Modules linked in: iio_dummy(C+) industrialio
>> Pid: 615, comm: modprobe Tainted: G         C   3.6.0-rc6-00180-g68d0383-dirty
>> RIP: 0033:[<00000000a089d846>]
>> RSP: 000000009f4ffd30  EFLAGS: 00010206
>> RAX: 0000000000000004 RBX: 00000000a08be6a0 RCX: 0000000000000000
>> RDX: 000000006036a320 RSI: 0000000000000008 RDI: 0000000000000000
>> RBP: 000000009f4ffda0 R08: 000000009f4ff900 R09: 0000000060406da8
>> R10: 000000000000004a R11: 0000000000000246 R12: 00000000602a58bc
>> R13: 0000000000000005 R14: 000000006005f170 R15: 000000009f6b0400
>> Call Trace: 
>> 603675d8:  [<6001d53d>] segv+0x1bd/0x340
>> 603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
>> 60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
>> 60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
>> 60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
>> 603676a8:  [<6001d713>] segv_handler+0x53/0xb0
>> 603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
>> 603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
>> 60367708:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367718:  [<602a58bc>] printk+0x0/0xa8
>> 60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 60367818:  [<60016c34>] _einittext+0x2572/0x38f6
>> 60367828:  [<60016728>] _einittext+0x2066/0x38f6
>> 60367908:  [<60016c34>] _einittext+0x2572/0x38f6
>> 603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
>> 60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
>> 60367a90:  [<602a58bc>] printk+0x0/0xa8
>> 60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b08:  [<602a58bc>] printk+0x0/0xa8
>> 60367b18:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>>
>> Kernel panic - not syncing: Kernel mode fault at addr 0x68, ip 0xa089d846
>> Call Trace: 
>> 603674b0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603674c8:  [<602a5751>] panic+0x146/0x2b1
>> 60367500:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 60367508:  [<602a560b>] panic+0x0/0x2b1
>> 60367520:  [<6007a4d4>] __module_text_address+0x14/0x70
>> 60367538:  [<6007ec20>] is_module_text_address+0x10/0x20
>> 60367548:  [<600582c7>] __kernel_text_address+0x87/0xc0
>> 60367568:  [<6001bc1f>] show_trace+0x7f/0xf0
>> 60367598:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603675c0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603675d8:  [<6001d55b>] segv+0x1db/0x340
>> 603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
>> 60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
>> 60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
>> 60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
>> 603676a8:  [<6001d713>] segv_handler+0x53/0xb0
>> 603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
>> 603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
>> 60367708:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367718:  [<602a58bc>] printk+0x0/0xa8
>> 60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 60367818:  [<60016c34>] _einittext+0x2572/0x38f6
>> 60367828:  [<60016728>] _einittext+0x2066/0x38f6
>> 60367908:  [<60016c34>] _einittext+0x2572/0x38f6
>> 603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
>> 60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
>> 60367a90:  [<602a58bc>] printk+0x0/0xa8
>> 60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b08:  [<602a58bc>] printk+0x0/0xa8
>> 60367b18:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>>
>>
>> Modules linked in: iio_dummy(C+) industrialio
>> Pid: 615, comm: modprobe Tainted: G         C   3.6.0-rc6-00180-g68d0383-dirty
>> RIP: 0033:[<00000000402eff9a>]
>> RSP: 0000007fbfbf6798  EFLAGS: 00000246
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: ffffffffffffffff
>> RDX: 000000000060e110 RSI: 00000000000148c9 RDI: 0000000040024000
>> RBP: 0000000000611b70 R08: 000000000060e100 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060e110
>> R13: 0000000000000000 R14: 000000000060e010 R15: 0000000000611b88
>> Call Trace: 
>> 60367448:  [<6001db1e>] panic_exit+0x3e/0x60
>> 60367478:  [<600616ad>] notifier_call_chain+0x4d/0x70
>> 603674a0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603674b8:  [<60061708>] atomic_notifier_call_chain+0x18/0x20
>> 603674c8:  [<602a5784>] panic+0x179/0x2b1
>> 60367500:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 60367508:  [<602a560b>] panic+0x0/0x2b1
>> 60367520:  [<6007a4d4>] __module_text_address+0x14/0x70
>> 60367538:  [<6007ec20>] is_module_text_address+0x10/0x20
>> 60367548:  [<600582c7>] __kernel_text_address+0x87/0xc0
>> 60367568:  [<6001bc1f>] show_trace+0x7f/0xf0
>> 60367598:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603675c0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 603675d8:  [<6001d55b>] segv+0x1db/0x340
>> 603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
>> 60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
>> 60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
>> 60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
>> 603676a8:  [<6001d713>] segv_handler+0x53/0xb0
>> 603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
>> 603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
>> 60367708:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367718:  [<602a58bc>] printk+0x0/0xa8
>> 60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>> 60367818:  [<60016c34>] _einittext+0x2572/0x38f6
>> 60367828:  [<60016728>] _einittext+0x2066/0x38f6
>> 60367908:  [<60016c34>] _einittext+0x2572/0x38f6
>> 603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
>> 60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
>> 60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
>> 60367a90:  [<602a58bc>] printk+0x0/0xa8
>> 60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b08:  [<602a58bc>] printk+0x0/0xa8
>> 60367b18:  [<6005f170>] __mutex_init+0x0/0x20
>> 60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
>>
>>
>> Tested on recent linus' tree (v3.6-rc6-176-gabef3bd)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
