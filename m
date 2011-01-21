Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1AUSxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:53:04 -0500
Received: from mail.openrapids.net ([64.15.138.104]:38610 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752805Ab1AUSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:53:01 -0500
Date: Fri, 21 Jan 2011 13:52:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110121185259.GA13198@Krystal>
References: <20110119221327.GA23544@Krystal> <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal> <4D39CB0C.8070308@oldelvet.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D39CB0C.8070308@oldelvet.org.uk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:50:10 up 58 days, 23:53,  4 users,  load average: 0.08, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Mortimer (richm@oldelvet.org.uk) wrote:
>
>
> On 21/01/2011 00:04, Mathieu Desnoyers wrote:
>> * David Miller (davem@davemloft.net) wrote:
>>> From: Mathieu Desnoyers<mathieu.desnoyers@efficios.com>
>>> Date: Wed, 19 Jan 2011 17:33:39 -0500
>>>
>>>> So I guess we go for the following. Is it verbose enough ?
>>>
>>> It's got all of the details that seem to matter, thanks.
>>
>> I'm letting people following this thread and the bug report know that I posted
>> the patch we discussed about here in the following thread:
>>
>> https://lkml.org/lkml/2011/1/19/509
>>
>> Feedback is welcome,
>>

Hi Richard,

> Hi Mathieu,
>
> Thanks for this.
>
> The good news is that I have a 2.6.37 kernel + your patches booting and  
> it has been running for about an hour on sparc64/Sun Fire V120. I did a  
> bit of poking around in /debug and turned on/off a bit of tracing and  
> nothing broke.

That's a good start :)

> I did have a few problems applying your patch series. Your diffs have  
> semicolons at the end of a couple of the macros that don't appear in the  
> mainline 2.6.37. One was circa line 174 of include/linux/tracepoint.h  
> but I don't have the other to hand at the moment and I don't have much  
> time before I need to go out.

I know what's causing this, I'll rebase my patch before my next post (I was
working at the tail of my lttng patch queue). Thanks for letting me know.

> I'm also getting a lot of Kernel unaligned access errors from the  
> kernel. I don't know if they are related to this or not and this is the  
> first time that I personally have got 2.6.37 to boot on sparc64. The  
> messages that I am getting seem to be repeats of
>
> [ 4376.807811] Kernel unaligned access at TPC[456e94]  
> try_to_wake_up+0x58/0xec
> [ 4376.807908] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
> [ 4376.808044] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
> [ 4376.808871] Kernel unaligned access at TPC[456e94]  
> try_to_wake_up+0x58/0xec
> [ 4376.808965] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
> [ 4381.813354] log_unaligned: 337 callbacks suppressed
>
> I have to go out now but will be around later/over the weekend.

Can you send me your .config ? I'd really like to see which of tracepoint/static
jump patching are enabled.

Do you get this message as soon as the system boots, or only when you enable
tracing ?

Thanks,

Mathieu

>
> Regards
>
> Richard
>

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
