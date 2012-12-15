Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2LOVln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:41:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60097 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2LOVll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:41:41 -0500
Message-ID: <50CCEE49.3080801@zytor.com>
Date: Sat, 15 Dec 2012 13:40:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com> <50CCCFD0.7030704@linux.intel.com> <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
In-Reply-To: <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 12:55 PM, Yinghai Lu wrote:
> On Sat, Dec 15, 2012 at 11:30 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> What is the point of only managing 2M at a time?  Now you have to have
>> more conditionals and you don't get any more memory efficiency.
>
> We don't need to, because real_data is less than 2M, and ramdisk is about 16M.
>

In other words, you make magic assumptions (some of which are very wrong 
in many real-life scenarios -- people can and do use gigabyte-plus 
initramfs).  That is exactly the wrong thing to do.  Furthermore it 
doesn't buy you anything, because you still have to allocate the PMDs.

> Also if we set map too large, could have chance to cover mem hole near
> 1T for AMD HT system.

Again, should not be cachable in the MTRRs, and even so, is 1G aligned 
already.

>> Filling arbitrarily into the brk is not acceptable... the brk is an O(1)
>> area and all brk allocations need to be reserved at compile time, so the
>> overflow handling is still necessary.
>
> if run out of BRK, we will get panic, because early_make_pgtable will return -1.

And you consider that panic an acceptable failure mode????

> and current BRK already have 64 slop space.
>
> BTW, did you look at smp boot problem with early_level4_pgt version?

No, I have been busy with non-Linux stuff today.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

