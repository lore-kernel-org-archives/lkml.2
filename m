Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2KWHTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:19:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60569 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab2KWHTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:19:35 -0500
Date: Thu, 22 Nov 2012 23:19:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121123071931.GB12631@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
 <20121121205424.GA25470@core.coreip.homeip.net>
 <20121121223859.GQ3290@n2100.arm.linux.org.uk>
 <20121122021750.GD25470@core.coreip.homeip.net>
 <20121122093033.GA5764@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122093033.GA5764@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 09:30:33AM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 21, 2012 at 06:17:50PM -0800, Dmitry Torokhov wrote:
> > > You've checked non-ARM architectures too?
> > 
> > Yes:
> > 
> > [dtor@dtor-d630 linux-next]$ grep -r HAVE_CLK_PREPARE .
> > ./arch/arm/Kconfig:     select HAVE_CLK_PREPARE
> > Binary file ./.git/objects/pack/pack-7dad5ee164f601f1327dc78648fa317772c2d872.pack matches
> > ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> > ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> > ./drivers/clk/Kconfig:config HAVE_CLK_PREPARE
> > ./drivers/clk/Kconfig:  select HAVE_CLK_PREPARE
> 
> Err, no you haven't, not with that grep.  What you've found are the places
> which enable this, and say "yes, I have clk_prepare".
> 
> What HAVE_CLK_PREPARE is about though is providing a transition path between
> drivers using clk_prepare() to platforms which _don't_ have a clk_prepare()
> implementation - and when it's unset, it provides a default implementation.

Ahh, I see. Then I think my first patch was correct albeit it had bad changelog
message. If provided stubs for clk_prepare()/clk_unprepare() for
platforms that did not define HAVE_CLK and pushed the check for
HAVE_CLK_PREPARE down into drivers/clk/clk.c so __clk_prepare() would
either call platform implementation or just be an empty function.

Am I correct or I am still missing something?

Thanks.

-- 
Dmitry
