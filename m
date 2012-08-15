Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2HOWDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:03:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2HOWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:03:31 -0400
Date: Wed, 15 Aug 2012 15:03:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        John David Anglin <dave.anglin@bell.net>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [ALPHA] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop
 the casts
Message-Id: <20120815150328.e1fb3676.akpm@linux-foundation.org>
In-Reply-To: <20120812021405.GB8442@localhost>
References: <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
	<20120723114258.GV9222@suse.de>
	<20120723122905.GA22476@localhost>
	<BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
	<20120724074844.GA9519@localhost>
	<BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
	<1343193053.3139.6.camel@dabdike>
	<CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com>
	<20120802150209.GA26601@localhost>
	<502707D5.7020602@orcon.net.nz>
	<20120812021405.GB8442@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2012 10:14:05 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> From: Mel Gorman <mgorman@suse.de>
> 
> The following build error occurred during an alpha build:
> 
> net/core/sock.c:274:36: error: initializer element is not constant
> 
> Dave Anglin says:
> > Here is the line in sock.i:
> >
> > struct static_key memalloc_socks = ((struct static_key) { .enabled =
> > ((atomic_t) { (0) }) });
> 
> The above line contains two compound literals.  It also uses a designated
> initializer to initialize the field enabled.  A compound literal is not a
> constant expression.
> 
> The location of the above statement isn't fully clear, but if a compound
> literal occurs outside the body of a function, the initializer list must
> consist of constant expressions.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

I'll remvoe the Cc:stable from this one - the regression is post-3.5.
