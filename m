Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1K1DrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:47:04 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51656 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1K1DrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:47:03 -0500
Date: Sun, 27 Nov 2011 22:46:58 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        drivers_pci@kernel-bugs.osdl.org,
        =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug 41132] [BISECTED][REGRESSION] Regression with the IRQ
 subsystem introduced in 2.6.39 (and present in the 3.x version)
Message-ID: <20111128034658.GA3503@Brahman>
References: <bug-41132-5003@https.bugzilla.kernel.org/>
 <201108160554.p7G5soeq002083@demeter2.kernel.org>
 <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
 <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all -

On Sun, Nov 27, 2011 at 12:22:54PM -0800, Linus Torvalds wrote:
> Thomas, Ingo?
> 
> I haven't seen any response to this one, and while clearly commit
> fa27271bc8d2 ("genirq: Fixup poll handling") was *supposed* to be a
> no-op, it isn't.
> 
> The commit message says "Shorter version with the same
> functionality.", but since it causes a regression, it clearly is not
> with the same functionality at all. And I assume that Thomas doesn't
> have a machine that actually ever triggers the spurious irq issue to
> begin with, so it probably was never tested.
> 
> In short, it really sounds like this should just be reverted, since
> the code clearly doesn't do what the commit message claims it does.
> 
> Comments?
> 
>               Linus


I experienced the regression in fa2727, too, and recently submitted a
patch; I believe Thomas has it queued for review.  I'll repost here.
The commit won't need to be fully reverted--it wouldn't be a simple
reversion, amidst the rest of the 2.6.39 irq overhaul, and Thomas'
rewrite is indeed better organized, I think.

I isolated the regression to the new version of 'try_one_irq' not
testing for:

  (action->handler(irq, action->dev_id) == IRQ_HANDLED)

before trying to deal with the interrupt, as the old did.  My patch
puts it with the other tests in the restructured code.

Happy to revise, or test suggestions against my bad-irq boxes.

Thanks -

Edward
