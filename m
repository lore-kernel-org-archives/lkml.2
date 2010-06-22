Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0FVEnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 00:43:31 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:51870 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0FVEna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 00:43:30 -0400
Date: Tue, 22 Jun 2010 07:43:10 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20100622044310.GB26865@jasper.tkos.co.il>
References: <1277098513.947165.104554431018.0.gpush@pororo>
 <1277098513.947633.945838133095.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277098513.947633.945838133095.1.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Mon, Jun 21, 2010 at 01:35:13PM +0800, Jeremy Kerr wrote:
> We currently have 21 definitions of struct clk in the ARM architecture,
> each defined on a per-platform basis. This makes it difficult to define
> platform- (or architecture-) independent clock sources without making
> assumptions about struct clk, and impossible to compile two
> platforms with different struct clks into a single image.
> 
> This change is an effort to unify struct clk where possible, by defining
> a common struct clk, containing a set of clock operations. Different
> clock implementations can set their own operations, and have a standard
> interface for generic code. The callback interface is exposed to the
> kernel proper, while the clock implementations only need to be seen by
> the platform internals.
> 
> This allows us to share clock code among platforms, and makes it
> possible to dynamically create clock devices in platform-independent
> code.
> 
> Platforms can enable the generic struct clock through
> CONFIG_USE_COMMON_STRUCT_CLK. In this case, the clock infrastructure
> consists of a common struct clk:
> 
> struct clk {
> 	const struct clk_ops	*ops;
> 	unsigned int		enable_count;
> 	struct mutex		mutex;
> };
> 
> And a set of clock operations (defined per type of clock):
> 
> struct clk_operations {

That's clk_ops above, and in the code.

>        int             (*enable)(struct clk *);
>        void            (*disable)(struct clk *);
>        unsigned long   (*get_rate)(struct clk *);
>        [...]
> };
> 
> To define a hardware-specific clock, machine code can "subclass" the
> struct clock into a new struct (adding any device-specific data), and
> provide a set of operations:
> 
> struct clk_foo {
> 	struct clk	clk;
> 	void __iomem	*some_register;
> };
> 
> struct clk_operations clk_foo_ops = {

Ditto.

> 	.get_rate = clk_foo_get_rate,
> };
> 
> The common clock definitions are based on a development patch from Ben
> Herrenschmidt <benh@kernel.crashing.org>.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
