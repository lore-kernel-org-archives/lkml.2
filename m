Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2KNOr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:47:56 -0500
Received: from ns.iliad.fr ([212.27.33.1]:37055 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab2KNOry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:47:54 -0500
Message-ID: <1352904472.13818.66.camel@sakura.staff.proxad.net>
Subject: Re: [RFC] MIPS: BCM63XX: add initial Device Tree support
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 14 Nov 2012 15:47:52 +0100
In-Reply-To: <CAOiHx==1UxrmxB5kyeDQPF4HBYxY9h4Ha8mWErwm6znX=y75OA@mail.gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
	 <1352719094.10405.18.camel@sakura.staff.proxad.net>
	 <CAOiHx==1UxrmxB5kyeDQPF4HBYxY9h4Ha8mWErwm6znX=y75OA@mail.gmail.com>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-11-14 at 13:07 +0100, Jonas Gorski wrote:

Thanks for addressing my concerns

> > We can even build a single kernel that support all SOCs/boards.
> 
> That's not going to change with Device Tree, and I'm trying my best to
> keep this.

DT is said to be the solution to achieve this goal on ARM. I was just
pointing out that we already have this today.

> Not having to update board_bcm963xx.{c,h} because some vendor decided
> to add e.g. a previously unused gpio-bitbanged device. Not having to
> modify the kernel but just attach a (externally build) dtb to the
> kernel to support a new board. Ideally in the far future even using a
> CFE provided dtb. I'm sure there are more reasons.

Put the board description in DT, but please leave the SOC out and don't
try to describe them with DT, that's too preliminary.

Let's support more SOCs first, we cannot generalize on what we don't
know.

> And nobody wants to do that. But - as Kevin already mentioned - it
> would be nice if we get similar SoCs we already know about supported
> with the same code; or at least , like BCM33xx, BCM68xx or maybe even
> BCM7xxx (never looked at them, so I can't tell how viable that is).

DT is not the key here

code reuse/refactoring is

> These special clocks are so that the original behaviour of the clocks
> is kept.  I'd rather argue that the reset code does not belong into
> the clock code, and is actually the responsibility of the driver. It
> would make the clock code much simpler.

and IMO would make the driver code uglier. You don't read clock code
everyday, it's boring, you do read/change driver code much more often.

> What would you suggest? Please no "don't use Device Tree", as I don't
> think we can avoid that. I'm struggling to find something you are fine

As I said in my original email, I don't think bcm63xx codebase suffers
from any problem similar to what caused Linus' rant about ARM few years
ago.

Did someone threaten to stop merging our patches if we don't use DT ?

> I wouldn't treat this as stable until we got it into a satisfactory
> state with everything supported. Heck, I wouldn't even treat this as
> stable until Broadcom ships it in their SDKs to customers with CFEs
> providing DTBs to the kernel.

DT will succeed if chip designers start thinking the other way around:
making new chip backward compatible with existing code or DT bindings.
If that does not happen, we just moving C struct/arrays into another
format with no added benefits.

So we have to call it stable, otherwise there is no incentive to use
them.

And I just hate stable interfaces (which developer doesn't ?), they
require more maintenance/testing if you're serious about your work.

-- 
Maxime


