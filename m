Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2EaVJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:09:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58342 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2EaVJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:09:30 -0400
Message-ID: <4FC7DDF1.5070606@zytor.com>
Date: Thu, 31 May 2012 14:09:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
References: <20120531012829.160060586@goodmis.org>     <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>    <1338492300.13348.384.camel@gandalf.stny.rr.com>    <4FC7C62C.1020807@zytor.com>   <1338494431.13348.410.camel@gandalf.stny.rr.com>   <4FC7D1F7.8090405@zytor.com>  <1338496555.13348.429.camel@gandalf.stny.rr.com>  <4FC7D6EC.3000904@zytor.com> <1338497811.13348.443.camel@gandalf.stny.rr.com>
In-Reply-To: <1338497811.13348.443.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 01:56 PM, Steven Rostedt wrote:
> On Thu, 2012-05-31 at 13:39 -0700, H. Peter Anvin wrote:
>> On 05/31/2012 01:35 PM, Steven Rostedt wrote:
>>>
>>> Thus only the debug stack does the stack TSS trick.
>>>
>>> Is this what you were looking for? (God, it just shows how much time
>>> I've been spending on this crap, as I was able to find all this by
>>> memory and not grepping for it :-p )
>>>
>>
>> That's why I asked instead of pulled it up myself.
>>
>> However, what is missing is what the permitted transitions are.  This
>> affects the options.
> 
> Only the debug stack changes. These happen in the two places I already
> mentioned.
> 
> One, the switch of the IDT in NMI (to convert the IST from 4 to 0, and
> just keep the same stack).
> 
> Two, is the trick in the paranoidzeroentry_ist code (adding the debug
> stack). That changes the DEBUG stack pointer.
> 

No, I'm asking what environments (alternate stacks) are permitted where.
 That is the important information.

The interaction of the above two things is part of the problem, of
course, and I think it can (and should) be avoided.

	-hpa

