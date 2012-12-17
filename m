Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2LQWrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:47:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:47:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUWFaOkLNc8fJw=bEUwOkusadriMn0Oajk+F64vo5Eysw@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
	<CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
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
Date: Mon, 17 Dec 2012 14:47:17 -0800
X-Google-Sender-Auth: fCj8MUpWmkrDXrqMzheBN4Nl2YM
Message-ID: <CAE9FiQVG1WvtoUNK3ecfmSCocJZt694yrm7=iaOciD47GN=9EA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
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

On Sun, Dec 16, 2012 at 12:50 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Dec 15, 2012 at 9:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sat, Dec 15, 2012 at 6:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Sat, Dec 15, 2012 at 1:40 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 12/15/2012 12:55 PM, Yinghai Lu wrote:
>>>>>
>>>>> BTW, did you look at smp boot problem with early_level4_pgt version?
>>>>
>>>>
>>>> No, I have been busy with non-Linux stuff today.
>>>>
>>>
>>> ok, i sorted it out. I will split it to small pieces and post them.
>>
>> I updated for-x86-boot branch with it, and it is based on
>> linus:master
>> tip:x86/mm
>> tip:x86/urgent
>> tip:x86/mm2.
>>
>> also attach 7 new ones are just added to that branch.
>>
> just updated the branch to fix compiling problem that was found by
> Fengguang's kbuild test robot.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot

Peter, can you check that branch again?

I moved the early_trap_init after init_mem_mapping.
so for 64bit native, init_mem_mapping will setup page table for ram from blank.
