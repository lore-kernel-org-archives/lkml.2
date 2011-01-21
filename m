Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1AUSGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:06:09 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:40052 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1AUSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:06:08 -0500
Message-ID: <4D39CB0C.8070308@oldelvet.org.uk>
Date: Fri, 21 Jan 2011 18:06:04 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
References: <20110119221327.GA23544@Krystal> <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal>
In-Reply-To: <20110121000421.GA5014@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/01/2011 00:04, Mathieu Desnoyers wrote:
> * David Miller (davem@davemloft.net) wrote:
>> From: Mathieu Desnoyers<mathieu.desnoyers@efficios.com>
>> Date: Wed, 19 Jan 2011 17:33:39 -0500
>>
>>> So I guess we go for the following. Is it verbose enough ?
>>
>> It's got all of the details that seem to matter, thanks.
>
> I'm letting people following this thread and the bug report know that I posted
> the patch we discussed about here in the following thread:
>
> https://lkml.org/lkml/2011/1/19/509
>
> Feedback is welcome,
>
Hi Mathieu,

Thanks for this.

The good news is that I have a 2.6.37 kernel + your patches booting and 
it has been running for about an hour on sparc64/Sun Fire V120. I did a 
bit of poking around in /debug and turned on/off a bit of tracing and 
nothing broke.

I did have a few problems applying your patch series. Your diffs have 
semicolons at the end of a couple of the macros that don't appear in the 
mainline 2.6.37. One was circa line 174 of include/linux/tracepoint.h 
but I don't have the other to hand at the moment and I don't have much 
time before I need to go out.

I'm also getting a lot of Kernel unaligned access errors from the 
kernel. I don't know if they are related to this or not and this is the 
first time that I personally have got 2.6.37 to boot on sparc64. The 
messages that I am getting seem to be repeats of

[ 4376.807811] Kernel unaligned access at TPC[456e94] 
try_to_wake_up+0x58/0xec
[ 4376.807908] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
[ 4376.808044] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
[ 4376.808871] Kernel unaligned access at TPC[456e94] 
try_to_wake_up+0x58/0xec
[ 4376.808965] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
[ 4381.813354] log_unaligned: 337 callbacks suppressed

I have to go out now but will be around later/over the weekend.

Regards

Richard

