Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0HQTdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:33:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26712 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0HQTde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:33:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6077"; a="51337302"
Message-ID: <4C6AE40D.7090206@codeaurora.org>
Date: Tue, 17 Aug 2010 12:33:33 -0700
From: Bobby Crabtree <bobbyc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
References: <4C6ACF92.7050506@codeaurora.org> <20100817181557.GA5755@opensource.wolfsonmicro.com>
In-Reply-To: <20100817181557.GA5755@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Aug 17, 2010 at 11:06:10AM -0700, Bobby Crabtree wrote:
>> I'm looking to upstream a new feature in which the regulator core
>> aggregates voltage requests from multiple consumers and applies the best
>> fitting voltage (e.g. max voltage) to a shared supply. The core would
> 
> It's unlikely that the highest voltage would ever be the best choice...
> 
We do need the highest voltage. Let's say we have two consumers
(A and B). Both require 1.3V for "normal" operations. Then let's
say that consumer A can save power by reducing the voltage to 1.1V
(but it doesn't require 1.1V). If the core were to immediately apply
1.1V, then the 1.3V requirement of consumer B would not be satisfied.

>> recompute the best fitting voltage when a consumer requests a voltage
>> change or requests to enable/disable the regulator (similar logic to
>> DRMS).
> 
>> The reason we need this feature is for power savings. It would allow two
>> or more consumers to "vote" on a voltage that's lower than the normal
>> operating voltage.
> 
> This was actually a feature of the regulator API when originally
> proposed, it got dropped for ease of review but there's some remanants
> of this in the code so it shouldn't be hard to resurrect.  Whenever a
> voltage was set the code stored the range on the consumer then iterated
> over all consumers applying their ranges plus the machine constraints
> rather than just using the immediate value.
> 
I noticed some of the remnants. But I'm not sure I follow what you
are saying. What range would the core actually propagate to the
driver? The minimum min_uV and the maximum max_uV? We need the core
to propagate the maximum min_uV and the maximum max_uV.

>> 1. Introduce a new API:
> 
>> int regulator_set_optimum_voltage(struct regulator *regulator,
>>                 int min_uV, int max_uV);
> 
> Why would you want to do this?  This is just the same arguments as the
> standard regulator_set_voltage() call and if we're ever setting anything
> other than the optimal voltage we probably ought to just stop doing
> that.
> 
"Optimum" was a bad choice of words. Seems that a new API isn't
preferred, so let's scrap this option.

