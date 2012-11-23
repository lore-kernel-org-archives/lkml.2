Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030289Ab2KWIJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:09:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65440 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2KWIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:09:02 -0500
Date: Fri, 23 Nov 2012 00:08:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121123080858.GA22619@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
 <20121121205424.GA25470@core.coreip.homeip.net>
 <20121121223859.GQ3290@n2100.arm.linux.org.uk>
 <20121122021750.GD25470@core.coreip.homeip.net>
 <20121122093033.GA5764@n2100.arm.linux.org.uk>
 <20121123071931.GB12631@core.coreip.homeip.net>
 <CAKohpo=8-rduLZgEyHOtxrJLYfo3F5Op7Z_S8hpLS=nRmMgqmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=8-rduLZgEyHOtxrJLYfo3F5Op7Z_S8hpLS=nRmMgqmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 12:57:54PM +0530, Viresh Kumar wrote:
> On 23 November 2012 12:49, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Ahh, I see. Then I think my first patch was correct albeit it had bad changelog
> > message. If provided stubs for clk_prepare()/clk_unprepare() for
> > platforms that did not define HAVE_CLK and pushed the check for
> > HAVE_CLK_PREPARE down into drivers/clk/clk.c so __clk_prepare() would
> > either call platform implementation or just be an empty function.
> >
> > Am I correct or I am still missing something?
> 
> I believe you are still missing it :)
> 
> clk.c will only be compiled when we have COMMON_CLK and
> COMMON_CLK selects HAVE_CLK_PREPARE.
> 
> So, using HAVE_CLK_PREPARE in clk.c is useless, as its always true.
> I feel, the best solution would be to simply drop patch 1 and apply others.

Right... OK, I'll drop the first patch.

-- 
Dmitry
