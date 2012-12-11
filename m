Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2LKXxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:53:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45388 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2LKXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <50C76F9E.4080001@zytor.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
	<CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
	<20121211145716.GB8873@liondog.tnic>
	<CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
	<50C763C2.5020603@zytor.com>
	<CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
	<20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
Date: Tue, 11 Dec 2012 15:53:01 -0800
X-Google-Sender-Auth: lLoDgMmZky_N_hIth4L58XLQTF4
Message-ID: <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 9:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/11/2012 09:15 AM, Yinghai Lu wrote:
>>
>>
>> No, that is not right place. initrd could be loaded anywhere like way
>> high by bootloader.
>>
>
> Only *after* your changes... the current protocol doesn't allow that.

before for-x86-boot change,

bootloader put ramdisk just under 2g...

[    0.000000] memblock_reserve: [0x7d9dc000-0x7fffefff] RAMDISK

and arch/x86/kernel/head_64.S only set ident mapping for [0,1g)

so before init_memory_mapping, we need to use early_ioremap to access
ramdisk area.

also even after init_memory_mapping, we still need use early_ioremap to access
it because user could use memmap to skip it.

PS: this problem have nothing to do with mapping that is set by bootloader.
arch/x86/kernel/head_64.c will have it own mapping, and only cover [0,1g).

Yinghai

>
> Anyway, we need to deal with it, see below.
