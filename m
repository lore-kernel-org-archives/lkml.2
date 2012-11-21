Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422637Ab2KUUya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:54:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39910 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422626Ab2KUUy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:54:28 -0500
Date: Wed, 21 Nov 2012 12:54:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Turquette <mturquette@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121121205424.GA25470@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121204324.21126.99677@nucleus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:43:24PM -0800, Mike Turquette wrote:
> Quoting Viresh Kumar (2012-11-20 02:13:55)
> > On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > We'll need to invoke clk_unprepare() via a pointer in our devm_*
> > > conversion so let's uninline the pair.
> > 
> > Sorry, but you aren't doing this :(
> > This routine is already uninlined as it is in clk.c
> > 
> > Instead you are just moving clk_prepare(), etc calls within
> > #ifdef CONFIG_HAVE_CLK
> > #else
> > #endif
> > 
> > I doubt why they have been added under #ifdef CONFIG_HAVE_CLK_PREPARE
> > earlier. Can they exist without CONFIG_HAVE_CLK
> > 
> > @Mike: ?
> > 
> 
> HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
> selecting HAVE_CLK_PREPARE without HAVE_CLK.
> 
> Looking through the code I see that this used to be the case.  Commit
> 93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
> clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
> commit was authored by you.  Can you elaborate on why that aspect of the
> patch was needed?
> 

BTW, it looks like the only place where we select HAVE_CLK_PREPARE is
IMX platform and it also selects COMMON_CLK so I think HAVE_CLK_PREPARE
can be removed now.

Thanks.

-- 
Dmitry
