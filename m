Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2LRW5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:57:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51554 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LRW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:57:12 -0500
MIME-Version: 1.0
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220470F89E7@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
	<50CE4097.2020104@zytor.com>
	<CAE9FiQXmz07SUEwJdr0QD8Y2Uro6Sizkeg4KfFkJSuQLFW3Fow@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F81EE@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQUqJVJ6JSeGzFH+OtRA4syrbXZh-RJLSghvB8fdBt97oQ@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F8584@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQVQMumUSgJ91rT5Zr2_Q=Wk=jBy+MEA3Li0Y215OHQT_Q@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F89E7@ORSMSX105.amr.corp.intel.com>
Date: Tue, 18 Dec 2012 14:57:11 -0800
X-Google-Sender-Auth: KkIHHmVU-H4XW1NV28iLjgpENAY
Message-ID: <CAE9FiQVS4eryY5E1SJ8OA57aHFUwMKnnTJGopYxC6+CPEvWG8Q@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
From: Yinghai Lu <yinghai@kernel.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 2:55 PM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
>> Yinghai Lu
>> On Mon, Dec 17, 2012 at 3:30 PM, Yu, Fenghua <fenghua.yu@intel.com>
>> wrote:
>> >
>> > OSV may need the patchset based on old kernel. So I'll have the
>> patchset ready. Is this the right place to call load_ucode_bsp() in the
>> upstream kernel?
>> >
>> > diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
>> > index a512f56..e94b90e 100644
>> > --- a/arch/x86/kernel/head64.c
>> > +++ b/arch/x86/kernel/head64.c
>> > @@ -93,6 +88,11 @@ void __init x86_64_start_kernel(char *
>> real_mode_data)
>> >         }
>> >         load_idt((const struct desc_ptr *)&idt_descr);
>> >
>> > +       /*
>> > +        * Load microcode early on BSP.
>> > +        */
>> > +       load_ucode_bsp(__va(real_mode_data));
>> > +
>> >         if (console_loglevel == 10)
>> >                 early_printk("Kernel alive\n");
>> >
>> it has to be after #PF handler set page table patch...
>>
>> otherwise when ramdisk is above 1G, customer will get early PF
>> exception.
>
> If based on your for_x86_boot tree, is load_ucode_bsp() called afer load_idt()?
>

yes.

Please do try your patches on system with more than 4G ram.

Thanks

Yinghai
