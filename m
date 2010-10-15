Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0JOVWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:22:36 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10782 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab0JOVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:22:35 -0400
Message-ID: <4CB8C61A.2050008@caviumnetworks.com>
Date: Fri, 15 Oct 2010 14:22:34 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 8/9] jump label: Make arch_jump_label_text_poke_early()
 optional
References: <20101015200949.134732894@goodmis.org>	 <20101015201037.703989993@goodmis.org>  <1287176815.1998.117.camel@laptop> <1287176910.16971.2.camel@gandalf.stny.rr.com>
In-Reply-To: <1287176910.16971.2.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2010 21:22:50.0935 (UTC) FILETIME=[1F3CDC70:01CB6CAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 02:08 PM, Steven Rostedt wrote:
> On Fri, 2010-10-15 at 23:06 +0200, Peter Zijlstra wrote:
>> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
>>> +
>>> +#ifdef HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
>>>   extern void arch_jump_label_text_poke_early(jump_label_t addr);
>>> +#else
>>> +static inline void arch_jump_label_text_poke_early(jump_label_t addr) {}
>>> +#endif
>>> +
>>
>> How often is this called, do we really need to avoid that call? It looks
>> like init code.
>
> Yeah, that's a good point.
>
> What's the harm in doing a stub in the mips code here?
>

Really the SPARC code (and any architectures added in the future with a 
well defined optimal NOP) should be doing nothing here as well.

So I could turn the question around and ask:  How many empty definitions 
of this thing do you want in the tree?

I will defer to Steven.  If he wants to push the empty stubs into all 
the architectures, I will update the MIPS patch and he can remove/revert 
the 'jump label: Make arch_jump_label_text_poke_early() optional' patch.

Let me know which option you would prefer.

David Daney

