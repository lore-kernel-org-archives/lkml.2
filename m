Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2KVWbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2KVWbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:31:50 -0500
Date: Wed, 21 Nov 2012 22:38:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Turquette <mturquette@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121121223859.GQ3290@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com> <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com> <20121121204324.21126.99677@nucleus> <20121121205424.GA25470@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121205424.GA25470@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:54:24PM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 21, 2012 at 12:43:24PM -0800, Mike Turquette wrote:
> > Quoting Viresh Kumar (2012-11-20 02:13:55)
> > > On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > We'll need to invoke clk_unprepare() via a pointer in our devm_*
> > > > conversion so let's uninline the pair.
> > > 
> > > Sorry, but you aren't doing this :(
> > > This routine is already uninlined as it is in clk.c
> > > 
> > > Instead you are just moving clk_prepare(), etc calls within
> > > #ifdef CONFIG_HAVE_CLK
> > > #else
> > > #endif
> > > 
> > > I doubt why they have been added under #ifdef CONFIG_HAVE_CLK_PREPARE
> > > earlier. Can they exist without CONFIG_HAVE_CLK
> > > 
> > > @Mike: ?
> > > 
> > 
> > HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
> > selecting HAVE_CLK_PREPARE without HAVE_CLK.
> > 
> > Looking through the code I see that this used to be the case.  Commit
> > 93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
> > clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
> > commit was authored by you.  Can you elaborate on why that aspect of the
> > patch was needed?
> > 
> 
> BTW, it looks like the only place where we select HAVE_CLK_PREPARE is
> IMX platform and it also selects COMMON_CLK so I think HAVE_CLK_PREPARE
> can be removed now.

You've checked non-ARM architectures too?
