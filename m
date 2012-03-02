Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2CBG4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:56:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2CBG42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:56:28 -0500
Message-ID: <4F506EE2.1050705@zytor.com>
Date: Thu, 01 Mar 2012 22:55:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v12 06/13] seccomp: add system call filtering using BPF
References: <1330559620-23543-1-git-send-email-wad@chromium.org>    <1330559620-23543-6-git-send-email-wad@chromium.org>    <a6fdbe9d1daf6864589c9affc7048965.squirrel@webmail.greenhost.nl>    <4F50603B.7040505@zytor.com> <bc1b4ec8fbad5a5931a928f108a6095f.squirrel@webmail.greenhost.nl>
In-Reply-To: <bc1b4ec8fbad5a5931a928f108a6095f.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 10:43 PM, Indan Zupancic wrote:
> On Fri, March 2, 2012 06:52, H. Peter Anvin wrote:
>> On 03/01/2012 09:45 PM, Indan Zupancic wrote:
>>>
>>>> + * @nr: the system call number
>>>> + * @arch: indicates system call convention as an AUDIT_ARCH_* value
>>>> + *        as defined in <linux/audit.h>.
>>>> + * @instruction_pointer: at the time of the system call.
>>>
>>> If the vDSO is used this will always be the same, so what good is this?
>>> I haven't gotten an answer to this yet.
>>>
>>
>> And if it isn't, or you're on an architecture which doesn't use the vdso
>> as the launching point, it's not.
> 
> True, but then what?
> 

Ok, fail on my part - I misread the above to refer to @arch, not
@instruction_pointer.

>> -- Pin is a great example.
> Is that http://www.pintool.org/?
> 
> Can you explain how knowing the IP is useful for Pin?
> 
> All I am asking for is just one use case for providing the IP. Is that
> asking for too much?

However, it still applies.  For something like Pin, Pin may want to trap
on all or a subset from the instrumented program, while the
instrumentation code -- which lives in the same address space -- needs
to execute those same instructions.

Yes, it's useless for *security* (unless perhaps if you keep very strict
tabs on the flow of control by using debug registers, dynamic
translation or whatnot), but it can be highly useful for
*instrumentation*, where you want to analyze the behavior of a
non-malicious program.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

