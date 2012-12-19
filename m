Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2LSX44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:56:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48121 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2LSX4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:56:48 -0500
Message-ID: <50D25426.5020804@zytor.com>
Date: Wed, 19 Dec 2012 15:56:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
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
References: <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com> <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <20121219232134.GA4816@jshin-Toonie>
In-Reply-To: <20121219232134.GA4816@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:21 PM, Jacob Shin wrote:
> On Thu, Dec 20, 2012 at 12:03:29AM +0100, Borislav Petkov wrote:
>> On Wed, Dec 19, 2012 at 04:59:41PM -0600, Jacob Shin wrote:
>>> I can check but right, they might be used up. But even if we had slots
>>> available, the memory range that needs to be covered is in large
>>> enough address and aligned in such a way that you cannot cover it with
>>> variable range MTRRs.
>>
>> Actually, if I'm not mistaken, you only need to cover the HT hole with
>> one MTRR - the rest remains WB. And in order the mask bits to work, we
>> could make it a little bigger - we waste some memory but that's nothing
>> in comparison to the MCE.
>
> Actually all memory hole above 4GB and under TOM2 needs to be marked
> as UC, if the kernel just blanket calls init_memory_mapping from 4GB
> to top of memory.
>
> Right we would be loosing memory, and I think depending on the
> alignment of the boundary and how many MTRRs you have avaiable to use,
> significant chunks of memory could be lost. I need to go refresh on
> how variable range MTRRs are programmed, it has been a while.
>

In this particular case an MTRR at 0xe000000000 would lose 896 MB of 
RAM, or just under 0.1% of the total.

If it is only the HT region that causes trouble and not the rest of the 
hole you could just plant an MTRR at 0xfc00000000 and not lose any 
memory at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

