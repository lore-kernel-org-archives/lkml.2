Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DBJCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:02:44 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55058 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:02:43 -0400
Date: Mon, 02 Apr 2012 05:00:42 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Vorontsov <cbou@mail.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Woodhouse <dwmw2@infradead.org>, dri-devel@lists.freedesktop.org,
        David@freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: broken nouveau dependency on power supply
Message-ID: <6373b480-2185-4651-b12d-8498c806ff69@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1333338803.30734.37.camel@pasglop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.7.3]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Ok, not that trivial...
> 
> The problem is more like POWER_SUPPLY should be a bool, not a
> tristate.
> 
> If you think about it: you don't want things like nouveau to depend
> on a
> random subsystem like that, people will never get it. In fact,
> POWER_SUPPLY provides empty inline stubs when not enabled, so that's
> really designed to not have depends...
> 
> However that -cannot- work if POWER_SUPPLY is modular and the drivers
> who use it are not. The only fixes here that make sense I can think
> of
> that don't also involve Kconfig horrors are:
> 
>  - Ugly: in power_supply.h, use the extern variant if
> 
> 	defined(CONFIG_POWER_SUPPLY) ||
> 	 (defined(CONFIG_POWER_SUPPLY_MODULE) && defined(MODULE))
> 
> IE. use the stub if power supply is a module and what is being built
> is
> built-in. Of course that's not only ugly, it somewhat sucks from a
> user
> perspective as the subsystem now exists but can't be used by some
> drivers...
> 
>  - Better: Just make the bloody thing a bool :-) The power supply
> framework itself is small enough, just make it a boolean option and
> avoid the problem entirely. The actual power supply sub drivers can
> remain modular of course.

We can just do select POWER_SUPPLY.

Yes it reduces the option range for some stupid corner case but really I don't care, removing features from the kernel that a driver depends on is just leading to insane state combination and QA problems.

Dave.
