Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268Ab2AFKVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:21:40 -0500
Received: from nat.nue.novell.com ([195.135.221.2]:60911 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196Ab2AFKVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:21:39 -0500
Message-Id: <4F06D979020000780006AC49@nat.nue.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Fri, 06 Jan 2012 11:22:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
 <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com>
 <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com>
 <20120106094922.GU11715@one.firstfloor.org>
In-Reply-To: <20120106094922.GU11715@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 10:49, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Jan 05, 2012 at 06:03:23PM -0800, H. Peter Anvin wrote:
>> On 01/05/2012 05:47 PM, Andi Kleen wrote:
>> >>
>> >> Is that still true, and do we even use string instructions still on
>> >> those old CPUs?  Jan's fixes don't introduce any additional delays in
>> >> the non-string-instruction paths.
>> > 
>> > Yes various of the CPUs with bugs used string instructions.
>> > 
>> 
>> Which CPUs are you talking about here?
> 
> This was various iterations of K8 and PSC. Early Meroms may also have
> had issues (not 100% sure).

I checked the most recent K8 (Hammer) and Pentium4 documentation,
and didn't find mention of anything related. So pointing out where you
found something relevant would be helpful. (And yes, as indicated in
my original mail I too seem to recall there being problems in this area,
but upon closer checking yesterday they all turned out unrelated to
this code.)

>> > Both string and non string instructions are used on modern CPUs,
>> > so making any of that slower is not a good idea.
>> > 
>> 
>> Obviously not, but I'm perfectly fine turning REP_GOOD off on old broken
>> CPUs.
> 
> That would be even worse.

How could you allow a CPU fall under REP_GOOD is its rep
implementation is buggy.

> You would slow a critical fast path operation down for something
> that never happens?!?

It does happen, just (so far) not in-tree. It's a latent problem that's
just waiting for someone else to run into. Apart from large bootmem
allocations (where not even the latency of the memory clearing
matters in any way, there's nothing I know of that would prevent
someone from vmalloc()-ing a huge block of memory and then
calling memset() on it (which ought to be tolerable in a preemptable
kernel at least).

Jan

