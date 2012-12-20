Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2LTQ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:56:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46519 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2LTQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:56:12 -0500
MIME-Version: 1.0
In-Reply-To: <50D0DB1A.5010407@zytor.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-7-git-send-email-yinghai@kernel.org>
	<CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
	<50D0D6D1.70400@zytor.com>
	<CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
	<50D0DB1A.5010407@zytor.com>
Date: Thu, 20 Dec 2012 08:56:11 -0800
X-Google-Sender-Auth: FWoEYiT1g1S1cKDB7tAh19LYhk8
Message-ID: <CAE9FiQV2U+Am0zCz__6YL4CoOeie5McE9=g-L3A_udRNN1rPTw@mail.gmail.com>
Subject: Re: [PATCH v7 06/27] x86, 64bit: early #PF handler set page table
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@web.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 1:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/18/2012 12:55 PM, Yinghai Lu wrote:
>> On Tue, Dec 18, 2012 at 12:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/18/2012 12:43 PM, Yinghai Lu wrote:
>>
>>>
>>> That is putting the cart before the horse.  What is the specific requirement
>>> with kgdb here (I didn't see any email on that, please don't have private
>>> back conversations)?  Either way, however, kgdb is a tool to debug the
>>> kernel... having it a barrier for proper functionality of the kernel is not
>>> acceptable.
>>
>> did not hear back from Jason or Jan.
>>
>> Looks like last mail in LKML from Jason is about Oct 20
>>
>> looks like kgdb is want DB, BP, and PF are set at first.
>>
>> and just after that early_param for kgdbwait will get into to hold the kernel.
>>
>> then command from kgdb could dump ram etc.
>>
>
> So in that case, kgdb is broken and will need to be fixed up.  That
> happens all the time with debugging tools.
>

If there is a way that we can make all parties happy, we really should
not break KGDB.

Please reconsider to stop #PF handler in x86_64_start_kernel. in that case
1. microcode update still can use #PF handler to find microcode in
ramdisk and use it.
2. kernel that is loaded above 4G, could set mapping in C instead of
set that in head_64.S
   and use ioremap to access zero_page
3. KGDB still can call early_trap_init early before init_mem_mapping.

I put the change in for-x86-boot-v8 branch.
core patch is:
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=6fa4f1e68f0b67d0dc13d30c5ce6c3932697d08f

Thanks

Yinghai
