Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2LSXoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:44:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2LSXoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:44:02 -0500
Message-ID: <50D25128.7030205@zytor.com>
Date: Wed, 19 Dec 2012 15:43:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
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
References: <50CCEE49.3080801@zytor.com> <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com> <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <50D24C25.5050604@zytor.com> <CAE9FiQWuC+34=q1K5oj8j+U1XjbXPDz5k1VKvs4vnoZDAzFzRg@mail.gmail.com>
In-Reply-To: <CAE9FiQWuC+34=q1K5oj8j+U1XjbXPDz5k1VKvs4vnoZDAzFzRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:40 PM, Yinghai Lu wrote:
> On Wed, Dec 19, 2012 at 3:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> The other bit is that building the real kernel page tables iteratively
>> (ignoring the early page tables here) is safer, since the real page
>> table builder is fully aware of the memory map.  This means any
>> "spillover" from the early page tables gets minimized to regions where
>> there are data objects that have to be accessed early.  Since Yinghai
>> already had iterative page table building working, I don't see any
>> reason to not use that capability.
>
> that is v6, right?
>
> including that patch
>

No, that's just a different way to create the early page tables (and it 
doesn't solve anything, quite on the contrary.)  I'm talking about the 
strategy for creating the *permanent* page tables

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

