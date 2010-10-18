Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab0JRXXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:23:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0JRXXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:23:43 -0400
Message-ID: <4CBCD6E3.2020208@zytor.com>
Date: Mon, 18 Oct 2010 16:23:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6> <4CBCBBFC.1090500@zytor.com> <alpine.DEB.2.00.1010181431440.15782@chino.kir.corp.google.com> <4CBCBF9D.1060409@zytor.com> <alpine.DEB.2.00.1010181451030.18444@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010181451030.18444@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 03:00 PM, David Rientjes wrote:
>>
>> YES IT IS.  In fact, it is completely and totally bananas bonkers.
>>
>> By not pushing for a proper maintainable ABI, you will have an
>> indefinite forward compatibility problem, and when predictably it
>> breaks, you'll complain.  This is, however, backwards -- the right thing
>> would have been to say "I need this, this isn't available, I should add
>> a maintainable API and push it upstream", and perhaps add log parsing as
>> a backwards-compatibility solution.
> 
> The problem is deciding what should be an ABI and what shouldn't an ABI 
> when it isn't clear.  It would be great if everything that is logged or 
> shown to userspace would be part of an ABI and would be available no 
> matter how much information is emitted to the log.  That's not scalable, 
> so we have to decide what userspace may depend on and design ABIs that 
> provide that information in an extendable way that won't break or become 
> obsoleted in the foreseeable future.
> 
> Since we can't do that for everything and we have no idea what users will 
> find to parse from the dmesg, I'm advocating that if a change is proposed, 
> like was in this case with ti->flags, and someone has a usecase where the 
> information isn't available in any other way, that they speak up and come 
> up with a maintainable solution so that we've identified the parties 
> involved and can change that log message if necessary.  I only think that 
> should be done, though, when there is a compelling reason for the change.
> 
> I think that was done in this case by suggesting an alternative (printing, 
> at minimum, "M" when a thread has TIF_MEMDIE set instead of the raw flag 
> bits), but I don't think the change itself was compelling enough that it 
> has to be done.  That doesn't mean doing the change I suggested wasn't 
> still appropriate, but at least it was known as a prerequisite before 
> something like this should be merged.

Note: I have already said we shouldn't change TIF_ flags.  The thing I'm
objecting to is that in very short order you have made multiple requests
for API-type stability for things that are explicitly for human
consumption, like dmesg and Sysrq information.

Expecting *anything* in dmesg to remain stable in any way is aggravated
insanity and completely unreasonable.

	-hpa
