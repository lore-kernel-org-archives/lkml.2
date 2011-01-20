Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1ATQxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:53:24 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:50016 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039Ab1ATQxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:53:23 -0500
Message-ID: <4D38687A.6040307@fluff.org>
Date: Thu, 20 Jan 2011 16:53:14 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111101314.GA774@linux-sh.org>	<201101111830.18597.jeremy.kerr@canonical.com> <20110111121816.GB774@linux-sh.org>
In-Reply-To: <20110111121816.GB774@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 12:18, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 06:30:18PM +0800, Jeremy Kerr wrote:
>> Hi Paul,
>>
>>> No, the sleeping clock case is and always will be a corner case, and I
>>> have no interest in pretending otherwise. On SH we have hundreds of
>>> clocks that are all usable in the atomic context and perhaps less than a
>>> dozen that aren't (and even in those cases much of the PLL negotiation is
>>> handled in hardware so there's never any visibility for the lock-down
>>> from the software side, other architectures also have similar behaviour).
>>
>> I'm not too worried about the corner-cases on the *implementation* side, more 
>> the corner-cases on the API side: are we seeing more users of the API that 
>> require an atomic clock, or more that don't care?
>>
> Again, you are approaching it from the angle that an atomic clock is a
> special requirement rather than the default behaviour. Sleeping for
> lookup, addition, and deletion are all quite acceptable, but
> enable/disable pairs have always been intended to be usable from atomic
> context. Anyone that doesn't count on that fact is either dealing with
> special case clocks (PLLs, root clocks, etc.) or simply hasn't bothered
> implementing any sort of fine grained runtime power management for their
> platform.

No, the API has always been defined to ensure clk_enable() returns once
a clock is running and usable, so if the case where there are PLLs in
the way is inconvenient to you, then sorry but they exist already.
