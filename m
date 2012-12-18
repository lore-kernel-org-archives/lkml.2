Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2LRBvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:51:55 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45623 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LRBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:51:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXbBXucvAkDf6O3XFS-6mFDW0U9qKfA8CZbDRpq=e0OrQ@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
	<CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
	<50CB8213.9000908@zytor.com>
	<CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
	<CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
	<CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
	<50CCCFD0.7030704@linux.intel.com>
	<CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
	<50CCEE49.3080801@zytor.com>
	<CAE9FiQV6tmHqnwOX8Rh3heaG1PQ9YQNN45esMQjqZP8Upw0Y-g@mail.gmail.com>
	<CAE9FiQUSve-5zuD8JyOK-eeJwTu6-E7ZnYCvc74jPVWwxhLP4g@mail.gmail.com>
	<CAE9FiQUWFaOkLNc8fJw=bEUwOkusadriMn0Oajk+F64vo5Eysw@mail.gmail.com>
	<CAE9FiQVG1WvtoUNK3ecfmSCocJZt694yrm7=iaOciD47GN=9EA@mail.gmail.com>
	<50CFA6A4.7010805@zytor.com>
	<CAE9FiQUx-T2ZFyBtrdLjzkUO50LObMv_nOEUNPwU+wPQscD1_A@mail.gmail.com>
	<CAE9FiQXbBXucvAkDf6O3XFS-6mFDW0U9qKfA8CZbDRpq=e0OrQ@mail.gmail.com>
Date: Mon, 17 Dec 2012 17:51:52 -0800
X-Google-Sender-Auth: 7Vx6VMRWEaO94UtsL-WEJASi0-U
Message-ID: <CAE9FiQWe+5+Oh7gKT1mCKn+sEm0P8_azfLV=WN6xWHKp2j-eUA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jan Kiszka <jan.kiszka@web.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 5:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 17, 2012 at 3:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Dec 17, 2012 at 3:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/17/2012 02:47 PM, Yinghai Lu wrote:
>>>>
>>>>
>>>> Peter, can you check that branch again?
>>>>
>>>> I moved the early_trap_init after init_mem_mapping.
>>>> so for 64bit native, init_mem_mapping will setup page table for ram from
>>>> blank.
>>>>
>>>
>>> Looks better, at first glance at least.  There are a couple of unnecessary
>>> changes (the counter in head_64.S cannot exceed 32 bits once computed, so
>>> the change from %rcx to %ecx change is pointless.)
>>
>> ok,  return to use %ecx
>>
>>>
>>> There is another bug in my patch: it either needs to mask off the NX bit if
>>> we are running on non-NX-enabled hardware, or it needs to not set the NX bit
>>> (which is mostly okay that early on, I suspect.)
>>
>> i test that in kvm guest, and westmere, current version seem ok.
>>
>> will repost the patchset to list to get more review.
>>
>
> not sure if i could move that early_trap_init down.
>
> jason,
>
> We need to move down early_trap_init after init_memory_mapping to use
> early #PF handler to set page table.
>
> So can we do that? for kgdb it is that ok to move it down?

adding to Jan.
