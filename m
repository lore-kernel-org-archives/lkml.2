Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1H0RbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 13:31:12 -0400
Received: from [206.117.179.246] ([206.117.179.246]:38921 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750974Ab1H0RbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 13:31:09 -0400
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
From: Joe Perches <joe@perches.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Andy Walls <awalls@md.metrocast.net>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110827190538.21357785@tele>
References: <cover.1313966088.git.joe@perches.com>
	 <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com>
	 <1314182047.2253.3.camel@palomino.walls.org>
	 <1314222175.15882.8.camel@Joe-Laptop>
	 <1314451740.2244.7.camel@palomino.walls.org>
	 <1314463352.6852.5.camel@Joe-Laptop>  <20110827190538.21357785@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 10:31:06 -0700
Message-ID: <1314466266.6852.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-27 at 19:05 +0200, Jean-Francois Moine wrote:
> On Sat, 27 Aug 2011 09:42:32 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Andy, I fully understand how this stuff works.
> > You apparently don't (yet).
> > 
> > Look at include/linux/printk.h
> > 
> > #ifndef pr_fmt
> > #define pr_fmt(fmt) fmt
> > #endif
> > 
> > A default empty define is used when one
> > is not specified before printk.h is
> > included.  kernel.h includes printk.h
> 
> Hi Joe,
> 
> Yes, but, what if pr_fmt is redefined in some driver specific include
> by:
> 
> #undef pr_fmt
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Of course that's possible.

But any pr_<level> that is used by any .h file
that is included before this redefine like
for instance netdevice.h doesn't have a
properly specified pr_fmt.


