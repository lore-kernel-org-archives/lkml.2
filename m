Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2HIXy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:54:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39225 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2HIXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:54:27 -0400
Message-ID: <50244D9A.2070000@gmail.com>
Date: Thu, 09 Aug 2012 16:54:02 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracepoints: Move the work out of line from hotpath
 sections
References: <1344544823.6935.82.camel@gandalf.stny.rr.com>  <20120809205053.GB15109@Krystal> <1344551131.6935.90.camel@gandalf.stny.rr.com> <502444CC.8030906@linux.intel.com>
In-Reply-To: <502444CC.8030906@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 04:16 PM, H. Peter Anvin wrote:
> On 08/09/2012 03:25 PM, Steven Rostedt wrote:
>>>
>>> It might be better to improve gcc to move really cold branches out of
>>> line (really, really far away), and use the compiler to do this, rather
>>> than to use an extra indirection that adds bloat and complexity to the
>>> kernel.

Oh, you mean like: -freorder-blocks-and-partition

>>
>> I think modifying gcc is something that can help more than tracing. But
>> that's been a pipe dream for such a long time that I've started dreaming
>> about winning a gold medal in the Olympics instead. Standing on the
>> podium listening to the crowd chanting your name along with your country
>> is more fun to dream about than seeing your unlikely code stop becoming
>> hurdles for the CPU sprinters.
>>
>
> At one point, maybe, but lately we have had a lot more traction from the
> gcc developers, giving us features like __fentry__ and asm goto.
>

I don't claim that -freorder-blocks-and-partition is bug free, but I 
imagine that the GCC developers would be open to fixing any bugs found.

David Daney

