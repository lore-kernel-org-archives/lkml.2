Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0FCVJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:09:35 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:51624 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754525Ab0FCVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:09:34 -0400
Message-ID: <4C081A09.1020706@bluewatersys.com>
Date: Fri, 04 Jun 2010 09:09:29 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
References: <1275479804.137633.565764505843.0.gpush@pororo>	<1275479804.138101.137592675542.1.gpush@pororo>	<20100602120356.GQ7248@trinity.fluff.org>	<201006031121.21896.jeremy.kerr@canonical.com> <20100603081354.GA4720@trinity.fluff.org>
In-Reply-To: <20100603081354.GA4720@trinity.fluff.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Thu, Jun 03, 2010 at 11:21:19AM +0800, Jeremy Kerr wrote:
>> Hi Ben,
>>
>>>> And a set of clock operations (defined per type of clock):
>>>>
>>>> struct clk_operations {
>>>>
>>>>        int             (*enable)(struct clk *);
>>> I'd rather the enable/disable calls where simply a set
>>> and a bool on/off, very rarelyt is the enable and disable
>>> operartions different.
>> I thought about merging these, but decided against it. It does work for the 
>> simple case where we're setting a bit in a register:
>>
>> static int clk_foo_set_state(struct clk *_clk, int enable)
>> {
>> 	struct clk_foo *clk = to_clk_foo(_clk)
>> 	u32 reg;
>>
>> 	reg = raw_readl(foo->some_register);
>> 	if (enable)
>> 		reg |= FOO_ENABLE;
>> 	else
>> 		reg &= ~FOO_ENABLE;
>> 	raw_writel(foo->some_register, reg);
>>
>> 	return 0;
>> }
>>
>> However, for anything more complex than this - for example, if there's a 
>> parent clock - then we start getting pretty messy:
>>
>> static int clk_foo_set_state(struct clk *_clk, int enable)
>> {
>> 	struct clk_foo *clk = to_clk_foo(_clk)
>> 	u32 reg;
> 
> Yuck. I think this should really be handled by the base clk_enable()
> and clk_disable() calls. Roughly based on what is currently in the
> plat-samsung clock implementation:

I think its a good idea to do this incrementally. The proposed patches
don't require much code rewrite because the interface is basically the
same. I think the best approach is to get the proposed patches applied,
which basically just makes the common interface from
include/linux/clock.h generic, and _all_ of the mach implementations
(and possibly other archs such as powerpc) converted and tested first.
Then we can go from there to see what other common functionality can be
moved into the generic clock framework.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
