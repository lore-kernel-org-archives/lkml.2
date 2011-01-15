Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1AORVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:21:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47187 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1AORVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:21:32 -0500
Date: Sat, 15 Jan 2011 17:20:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christer Weinigel <christer@weinigel.se>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110115172033.GM15996@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk> <4D31A8F1.4080301@weinigel.se> <20110115145358.GC15996@n2100.arm.linux.org.uk> <4D31D45A.8080509@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D31D45A.8080509@weinigel.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 06:07:38PM +0100, Christer Weinigel wrote:
> On 01/15/2011 03:53 PM, Russell King - ARM Linux wrote:
>> On Sat, Jan 15, 2011 at 03:02:25PM +0100, Christer Weinigel wrote:
>>> On platforms that need to sleep to enable the UART clock, configuring
>>> the UART as the kernel console should be equivalent to userspace opening
>>> the UART device, i.e. enable the clock.  At least to me that feels like
>>> an acceptable tradeoff, and if I wanted to save the last bit of power
>>> I'll have to refrain from using UART as the kernel console.
>>
>> Well, we're not discussing a _new_ API here - we're discussing an API
>> with existing users which works completely fine on the devices its
>> used, with differing expectations between implementations.
>
> Yes, so to fulfil the requirement that printk needs to call clk_enable  
> from atomic contexts, document that clk_enable can not sleep.  Or add  
> the clk_enable_atomic call and modify printk to use it.

You really need to read the entire thread - I've already said that yet
discussion continues about how to solve the problem.  This thread which
has been running for a number of days now has been entirely about how
to solve this.

>> There's been a lot of talk on this issue for ages with no real progress
>> that I'm just going to repeat: let's unify those implementations which
>> use a spinlock for their clks into one consolidated solution, and
>> a separate consolidated solution for those which use a mutex.
>>
>> This will at least allow us to have _some_ consolidation of the existing
>> implementations - and it doesn't add anything to the problem at hand.
>> It might actually help identify what can be done at code level to resolve
>> this issue.
>
> Won't that cause a lot of code duplication?  If it's possible to have  
> one sane implementation, why not go for it at once?

No one can agree on what the one sane implementation should be.

Consider this: is it better to continue talking about this for the next
six months, while still having N spinlock based implementations, and M
mutex based implementations.

Or is it better to consolidate the N spinlock based implementations
down to one spinlock implementation, and M mutex based implementations
down to one mutex implementation, and then discuss how to resolve the
differences between the two implementations?

I personally don't care whether we stick with the ever growing number of
clk API implementations, whether we continue discussing it for the next
six months, or whether we consolidate what we can.  I suspect there are
people who do care greatly, so I'm trying to suggest a way we can see
_some_ kind of progress on this consolidation effort.
