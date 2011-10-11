Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1JKQZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:25:22 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:52320 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1JKQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:25:20 -0400
Message-ID: <4E946DBF.5050105@genband.com>
Date: Tue, 11 Oct 2011 10:24:31 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: starlight@binnacle.cx, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@gentwo.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@elte.hu>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Joe Perches <joe@perches.com>,
        Chetan Loke <Chetan.Loke@netscout.com>,
        Con Kolivas <conman@kolivas.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
References: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx> <1317966007.3457.47.camel@edumazet-laptop>
In-Reply-To: <1317966007.3457.47.camel@edumazet-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Oct 2011 16:24:34.0001 (UTC) FILETIME=[42F53410:01CC8832]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18444.000
X-TM-AS-Result: No--2.441000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 11:40 PM, Eric Dumazet wrote:
> Le jeudi 06 octobre 2011 à 23:27 -0400, starlight@binnacle.cx a écrit :

>> If the older kernels are switching to NAPI
>> for much of surge and the switching out
>> once the pulse falls off, it might
>> conceivably result in much better latency
>> and overall performance.

> Thats exactly the opposite : Your old kernel is not fast enough to
> enter/exit NAPI on every incoming frame.
>
> Instead of one IRQ per incoming frame, you have less interrupts :
> A napi run processes more than 1 frame.
>
> Now increase your incoming rate, and you'll discover a new kernel will
> be able to process more frames without losses.

I wonder if it would make sense to adjust the interrupt mitigation 
parameters in the NIC to allow it to accumulate a few packets before 
interrupting the CPU.  We had good luck using this to reduce interrupt 
rate on a quasi-pathological case where we were bouncing in and out of 
NAPI because we were *just* fast enough to keep up with incoming packets.

Chris



-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
