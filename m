Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1CJXZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:25:08 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18828 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1CJXZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:25:06 -0500
Message-ID: <4D795DCE.7050807@caviumnetworks.com>
Date: Thu, 10 Mar 2011 15:25:02 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <1299780241.15854.393.camel@gandalf.stny.rr.com>	 <20110310182000.GB2906@redhat.com>	 <1299782143.15854.402.camel@gandalf.stny.rr.com>	 <4D791CAA.7090108@caviumnetworks.com>	 <1299783236.15854.405.camel@gandalf.stny.rr.com>	 <4D791F31.6040100@caviumnetworks.com>	 <1299785143.15854.407.camel@gandalf.stny.rr.com>	 <1299786329.15854.409.camel@gandalf.stny.rr.com>	 <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>	 <1299793339.15854.430.camel@gandalf.stny.rr.com>	 <BLU0-SMTP101D168109508CC1B82F0E496C80@phx.gbl> <1299798970.15854.484.camel@gandalf.stny.rr.com>
In-Reply-To: <1299798970.15854.484.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2011 23:25:02.0287 (UTC) FILETIME=[615FE5F0:01CBDF7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 03:16 PM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 17:48 -0500, Mathieu Desnoyers wrote:
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>> On Thu, 2011-03-10 at 16:22 -0500, Mathieu Desnoyers wrote:
>>>
>>>>> Anyway, I think the best thing for now is to have Jason add
>>>>> the .align(sizeof(long)) in the inline assembly for all locations and be
>>>>> done with it.
>>>>
>>>> You seem to be contradicting yourself here. I'm concerned about having
>>>> "structures" of a size not power of two. Can we simply either
>>>
>>> But we don't have structures. We have data that has been allocated in
>>> assembly. Come to think of it, it may be best to keep these as
>>> ".align 4".
>>
>> The .align 4 is certainly not the right answer, because it will trigger
>> unaligned accesses on some 64-bit architectures, as we have faced with
>> trace event.
>
> Will it? Seems that sparc does this regardless.
>
> Remember, this is 3 natural word sized objects, and vmlinux.ld starts
> the section off with .ALIGN 8, hence, the section is already 8 byte
> aligned, all objects within this section are 8 bytes (for 64bit archs,
> and 4 bytes for 32bit), why would saying ".align 4" cause the linker to
> add holes to make it 4 byte aligned when it is already 8 byte aligned.
> The ".align 4" should work with both 32bit and 64bit archs.
>

It should work, but it hurts my eyes to see the source code forcing a 
64-bit word to 32-bit alignment.

David Daney
