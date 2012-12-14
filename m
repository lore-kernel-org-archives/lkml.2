Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2LNUps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:45:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50124 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab2LNUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:45:46 -0500
Message-ID: <50CB8FA5.30101@zytor.com>
Date: Fri, 14 Dec 2012 12:44:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQVMkAF8Qk6h3QtKam5jahfS3HE01R4fynyXR-spknJkBA@mail.gmail.com>
In-Reply-To: <CAE9FiQVMkAF8Qk6h3QtKam5jahfS3HE01R4fynyXR-spknJkBA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:14 PM, Yinghai Lu wrote:
> On Fri, Dec 14, 2012 at 12:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Dec 14, 2012 at 12:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Fri, Dec 14, 2012 at 11:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>
>>>> I suspect we don't need init_level4_pgt at all and should just plan to
>>>> get rid of it.  Is there any reason we can't just build the proper
>>>> kernel page table set in pagetable_init() and switch to it there?
>>>
>>> then how to pass the info to AP?
>>
>> also we should merge early_level4_pgt with init_level4_pgt.
>>
>> and #PE handler could just extend to use BRK ...
>>
>> but need to make sure BRK get mapped at first, and BRK could cross the
>> 1G, 512G boundary ...
>>
>> that could make things less impact to all.
> 
> your current switchover setup in arch/x86/kernel/head_64.S could
> handle above 512g and cross boundary?
> 

Yes, that's the purpose of the funny aliasing games I play there.

	-hpa

