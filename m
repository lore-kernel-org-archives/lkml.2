Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1D3UGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:06:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41214 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1D3UGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:06:31 -0400
Message-ID: <4DBC6BC1.5090102@linux.vnet.ibm.com>
Date: Sat, 30 Apr 2011 13:06:25 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Carl Love <carll@us.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com> <20110429172525.GA2745@tassilo.jf.intel.com> <alpine.LFD.2.02.1104291938240.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1104291938240.3005@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 10:42 AM, Thomas Gleixner wrote:
> On Fri, 29 Apr 2011, Andi Kleen wrote:
>
>>>>   2.  Users are too stupid to use the raw functionality properly;
>>>>       we should only allow a kernel-developer-approved small subset
>>>>       of the features provided by the CPU as described in the intel
>>>>       developers manuals.
>>>>
>>>> #2 seems like a gross misinterpretation of the whole "Linux gives you
>>>> enough rope to shoot yourself in the foot" policy from days passed, but
>>>> maybe things have moved on.
>>>
>>> That's a gross misrepresentation of what Ingo has been saying on LKML.
>>> Really, learn to work with relevant maintainers before you ask Linus
>>> to revert something.
>>
>> Ingo may not have explicitely said (2), but at least his revert (disabling
>> the raw interface users are asking for) is practically implementing (2).
>>
>> Actions speak louder than words.
>>
>> That is either you have a raw interface or you only have the cooked
>> interface or you have both. Since he reverted raw only cooked
>> is left, which is (2)
>>
>> I agree with Vince it's a bad policy.
>
> No, it's not the raw interface will be made available when the proper
> set of abstracted functionality has been added and settled down,
> simply because it might to change the way the raw event is exposed. As
> long there are open questions which might have an influence on the
> exposure of the raw event, it's completely correct to keep it
> disabled.

Carl Love and I recently completed some work to add perf_events support 
for the IBM Blue Waters machine's "CPU networking" chip, called the 
Torrent chip.  We did all of this work based on a RHEL 6 kernel 
(2.6.32ish), which doesn't have Peter's more recent multi-PMU support.

I would say that most if not all of the events are not generalizable in 
the sense that you are talking about; the events are very specific to 
the Torrent chip.  For example, the Torrent chip communicates with four 
POWER7 chips via a high-speed serial interconnect, called the W, X, Y, 
and Z links, and it also has similar links which connect to other 
Torrent chips, and to other nodes.  The events measure certain types of 
activity on these various links, for example "X link receive idle".

So if I'm understanding what you have said correctly, we would not be 
able to get a forward port of this code committed without abstracting 
these events in a away that's acceptable to the kernel community.  Is 
that right?  If so, this is important for us to know so that we can 
correctly size the work effort involved in the forward port.

Thanks for your consideration,

- Corey
