Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1CJS6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:58:03 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10773 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1CJS6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:58:02 -0500
Message-ID: <4D791F31.6040100@caviumnetworks.com>
Date: Thu, 10 Mar 2011 10:57:53 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com>	 <1299728191.15854.319.camel@gandalf.stny.rr.com>	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>	 <1299771504.15854.347.camel@gandalf.stny.rr.com>	 <4D790A13.4060705@caviumnetworks.com>	 <1299780241.15854.393.camel@gandalf.stny.rr.com>	 <20110310182000.GB2906@redhat.com>	 <1299782143.15854.402.camel@gandalf.stny.rr.com>	 <4D791CAA.7090108@caviumnetworks.com> <1299783236.15854.405.camel@gandalf.stny.rr.com>
In-Reply-To: <1299783236.15854.405.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2011 18:57:58.0381 (UTC) FILETIME=[1261E1D0:01CBDF55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 10:53 AM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 10:47 -0800, David Daney wrote:
>
>> The alignment requested by the assembler will have to satisfy *all* the
>> requested alignments, so manually forcing everything to .align 8 (or
>> .align 4 for 32-bit) should ensure that the linker doesn't put in any holes.
>
> I would agree with the assessment although, I don't know that it is
> documented anywhere that this is what happens. As the previous "bug"
> with the trace_events was solved by me adding .align(4) everywhere, I
> would think that .align(sizeof(long)) would work here too.
>
> It may be a good ideal to force this alignment, and not add wasted
> space. If anything, if this (hypothetical) bug appears, it will most
> likely show up as a crash on boot up. I'm not too concerned about it.
>

If the linker put in gratuitous holes, things like  __ex_table would 
break too.


David Daney
