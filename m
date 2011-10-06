Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1JFSPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:15:17 -0400
Received: from claw.goop.org ([74.207.240.146]:33949 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1JFSPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:15:16 -0400
Message-ID: <4E8DF02B.7010406@goop.org>
Date: Thu, 06 Oct 2011 11:15:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com> <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
In-Reply-To: <20111006181055.GA2505@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 11:10 AM, Jason Baron wrote:
> On Thu, Oct 06, 2011 at 10:53:29AM -0700, Jeremy Fitzhardinge wrote:
>> On 10/05/2011 05:17 PM, H. Peter Anvin wrote:
>>> On 10/05/2011 05:16 PM, Jeremy Fitzhardinge wrote:
>>>> On 10/04/2011 09:30 AM, H. Peter Anvin wrote:
>>>>> On 10/04/2011 07:10 AM, Jason Baron wrote:
>>>>>> 1) The jmp +0, is a 'safe' no-op that I know is going to initially
>>>>>> boot for all x86. I'm not sure if there is a 5-byte nop that works on
>>>>>> all x86 variants - but by using jmp +0, we make it much easier to debug
>>>>>> cases where we may be using broken no-ops.
>>>>>>
>>>>> There are *plenty*.  jmp+0 is about as pessimal as you can get.
>>>> As an aside, do you know if a 2-byte unconditional jmp is any more
>>>> efficient than 5-byte, aside from just being a smaller instruction and
>>>> taking less icache?
>>>>
>>> I don't know for sure, no.  I probably depends on the CPU.
>> Looks like jmp2 is about 5% faster than jmp5 on Sandybridge with this
>> benchmark.
>>
>> But insignificant difference on Nehalem.
>>
>>     J
> It would be cool if we could make the total width 2-bytes, when
> possible.  It might be possible by making the initial 'JUMP_LABEL_INITIAL_NOP'
> as a 'jmp' to the 'l_yes' label. And then patching that with a no-op at boot
> time or link time - letting the compiler pick the width. In that way we could
> get the optimal width...

I'll have a look at it later today if I get a moment.  Should be fairly
straightforward.

What about the rest of the series.  Do you think it looks cooked enough
for next mergewindow?

    J
