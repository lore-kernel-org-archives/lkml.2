Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2LOVdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:33:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2LOVdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:33:06 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com> <50CCCFD0.7030704@linux.intel.com> <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update ucode on Intel's CPU
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 15 Dec 2012 13:31:35 -0800
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Message-ID: <6684d9ac-52a7-483a-8eaf-bfc79de484c1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mem hole at 1T should not be marked cachable in the MTRRs.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Sat, Dec 15, 2012 at 11:30 AM, H. Peter Anvin <hpa@linux.intel.com>
>wrote:
>> What is the point of only managing 2M at a time?  Now you have to
>have
>> more conditionals and you don't get any more memory efficiency.
>
>We don't need to, because real_data is less than 2M, and ramdisk is
>about 16M.
>
>Also if we set map too large, could have chance to cover mem hole near
>1T for AMD HT system.
>
>>
>> Filling arbitrarily into the brk is not acceptable... the brk is an
>O(1)
>> area and all brk allocations need to be reserved at compile time, so
>the
>> overflow handling is still necessary.
>
>if run out of BRK, we will get panic, because early_make_pgtable will
>return -1.
>
>and current BRK already have 64 slop space.
>
>BTW, did you look at smp boot problem with early_level4_pgt version?
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
