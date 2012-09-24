Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2IXSzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:55:22 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59151 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab2IXSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:55:20 -0400
Message-ID: <5060AC71.2080609@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 00:24:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Conny Seidel <conny.seidel@amd.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
References: <20120924102324.GA22303@aftab.osrc.amd.com> <50603829.9050904@linux.vnet.ibm.com> <20120924110554.GC22303@aftab.osrc.amd.com> <50604047.7000908@linux.vnet.ibm.com> <20120924113447.GA25182@localhost> <20120924122053.GD22303@aftab.osrc.amd.com> <20120924122900.GA28627@localhost> <20120924125632.GE22303@aftab.osrc.amd.com>
In-Reply-To: <20120924125632.GE22303@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092418-3864-0000-0000-000004C51BC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 06:26 PM, Borislav Petkov wrote:
> On Mon, Sep 24, 2012 at 08:29:00PM +0800, Fengguang Wu wrote:
>> On Mon, Sep 24, 2012 at 02:20:53PM +0200, Borislav Petkov wrote:
>>> On Mon, Sep 24, 2012 at 07:34:47PM +0800, Fengguang Wu wrote:
>>>> Will you test such a line? At least the generic do_div() only uses the
>>>> lower 32bits for division.
>>>>
>>>>         WARN_ON(!(den & 0xffffffff));
>>>
>>> But, but, the asm output says:
>>>
>>>   28:   48 89 c8                mov    %rcx,%rax
>>>   2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
>>>   2e:   31 d2                   xor    %edx,%edx
>>>
>>> and this version of DIV does an unsigned division of RDX:RAX by the
>>> contents of a *64-bit register* ... in our case %rdi.
>>>
>>> Srivatsa's oops  shows the same:
>>>
>>>   28:   48 89 f0                mov    %rsi,%rax
>>>   2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
>>>   2e:   41 8b 94 24 74 02 00    mov    0x274(%r12),%edx
>>>
>>> Right?
>>
>> Right, that's why I said "at least". As for x86, I'm as clueless as you..
> 
> Right, both oopses are on x86 so I don't think it is the bitness of the
> division.
> 
> Another thing those two have in common is that both happen when a CPU
> comes online. Srivatsa's is when CPU9 comes online (oops is detected on
> CPU9) and in our case CPU4 comes online but the oops says CPU0.
> 

I had posted another dump from one of my tests. That one triggers while
offlining a CPU (CPU 9).

https://lkml.org/lkml/2012/9/14/235

> So it has to be hotplug-related.

Regards,
Srivatsa S. Bhat


