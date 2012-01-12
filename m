Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2ALJNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:13:04 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45974 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2ALJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:13:00 -0500
Message-ID: <4F0EA47C.9000405@oss.ntt.co.jp>
Date: Thu, 12 Jan 2012 18:14:36 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Nadav Amit <namit@cs.technion.ac.il>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Exception during emulation decode should propagate
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il> <20120112071137.303628cea69b79868956d860@gmail.com> <4F0E28C7.2010409@oss.ntt.co.jp> <0C475788-593F-46AA-8BE0-274E6765D46D@gmail.com>
In-Reply-To: <0C475788-593F-46AA-8BE0-274E6765D46D@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/12 18:07), Nadav Amit wrote:
>
> On Jan 12, 2012, at 2:26 AM, Takuya Yoshikawa wrote:
>
>> (2012/01/12 7:11), Takuya Yoshikawa wrote:
>>> On Wed, 11 Jan 2012 18:53:30 +0200
>>> Nadav Amit<namit@cs.technion.ac.il>   wrote:
>>>
>>>> An exception might occur during decode (e.g., #PF during fetch).
>>>> Currently, the exception is ignored and emulation is performed.
>>
>> Note that the decode/emulation will not be continued in such a case.
>>
>> insn_fetch() is a bit tricky macro and it contains "goto done" to outside.
>> So if an error happens during fetching the instruction, x86_decode_insn()
>> will handle the X86EMUL_* fault value and returns FAIL immediately.
>
> You got a point. Yet, a problem still exists.
> I now notice I was originally working on previous version (3.0.0)
> where the return-code of x86_decode_insn is handled differently.
> Nonetheless, I think the current implementation might report emulation
> error in such a scenario (instead of triggering #PF/#GP in the guest).

It's me who did that fix.

>
>>>
>>> When I cleaned up insn_fetch(), I thought that fetching the instruction
>>> which is being executed by the guest cannot cause #PF.
>>>
>>> The possibility that a meaningless userspace might similtaneously unmap
>>> the page, noted by Avi IIRC, was ignored intentionally, so we just fail
>>> in such a case.
>>>
>>> Did you see any real problem?
>
> Well, I run some research project for which I emulate instructions quite
> often. I do see a real problem with Linux 3.0.0. Please note AFAIK #GP
> might occur as well during instruction fetch. I don't think failing is the
> right behavior in such case - there is no real reason to fail.
>
> Please tell me whether you are OK with KVM failing in such a scenario.
> If not - I'll send an updated patch (in which x86_decode_insn returns
> EMULATION_OK when rc == X86EMUL_PROPAGATE_FAULT).

You need comments from maintainers.

	Takuya
