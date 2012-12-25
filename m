Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2LYEEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 23:04:22 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50220 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2LYEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 23:04:20 -0500
MIME-Version: 1.0
In-Reply-To: <50D8F054.20404@zytor.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-7-git-send-email-yinghai@kernel.org>
	<CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
	<50D0D6D1.70400@zytor.com>
	<CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
	<50D0DB1A.5010407@zytor.com>
	<CAE9FiQV2U+Am0zCz__6YL4CoOeie5McE9=g-L3A_udRNN1rPTw@mail.gmail.com>
	<50D8F054.20404@zytor.com>
Date: Mon, 24 Dec 2012 20:04:18 -0800
X-Google-Sender-Auth: N9CoKAks6Acu66ePTAfKojUDCqE
Message-ID: <CAE9FiQW_mjUr6F0q7PhZWCcDzZ+NJpi0-xjxvwJoZ1K+XAUjSQ@mail.gmail.com>
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

On Mon, Dec 24, 2012 at 4:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/20/2012 08:56 AM, Yinghai Lu wrote:
>>>
>>>
>>> So in that case, kgdb is broken and will need to be fixed up.  That
>>> happens all the time with debugging tools.
>>
>>
>> If there is a way that we can make all parties happy, we really should
>> not break KGDB.
>>
>> Please reconsider to stop #PF handler in x86_64_start_kernel. in that case
>> 1. microcode update still can use #PF handler to find microcode in
>> ramdisk and use it.
>> 2. kernel that is loaded above 4G, could set mapping in C instead of
>> set that in head_64.S
>>     and use ioremap to access zero_page
>> 3. KGDB still can call early_trap_init early before init_mem_mapping.
>>
>
> Yinghai, this is total and utter bullshit.
>
> We should *fix* kgdb, not pave around it.  I refuse to have kgdb be yet
> another Xen turning random kernel internals into ABIs.

well, I updated for-x86-boot-v7 that stop #PF handler after init_mem_mapping.

it has fix for AMD system aka reverting far jmp to ret.

Yinghai
