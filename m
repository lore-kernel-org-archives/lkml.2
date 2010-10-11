Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0JKXYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:24:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab0JKXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:24:36 -0400
Date: Mon, 11 Oct 2010 16:23:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
Message-Id: <20101011162356.cd0ddcc1.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=Q=09b8UPcNm0sXGebYQKP3cfxroy+kLWP8EQ_@mail.gmail.com>
References: <20101008023356.6280.9969.stgit@dungbeetle.mtv.corp.google.com>
	<20101011154348.d3b24fa4.akpm@linux-foundation.org>
	<AANLkTi=Q=09b8UPcNm0sXGebYQKP3cfxroy+kLWP8EQ_@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 16:18:52 -0700
Salman Qazi <sqazi@google.com> wrote:

> On Mon, Oct 11, 2010 at 3:43 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>
> > Poeple are using BUG waaaaay too often.
> >
> 
> If people are attentive about WARN_ON_ONCE, then I suppose that is a
> better alternative.
> 
> One of the reasons why I personally like BUG_ON is that it catches
> problems early and makes people look (i.e. one can't ignore it, just
> because one didn't notice, understand or care) before it compounds any
> further.  It is very hard to debug a corrupted radix tree.  It is much
> easier to understand and fix the fact that our assumptions regarding
> the hrtimer state and locking are incorrect.
> 
> I'd rather have a BUG_ON firing 100 times, close to the root cause,
> instead of one case of unexplained data corruption far from the root
> cause.  Just my $0.02.

You're assuming that you are the one who observes the BUG_ON.  In a
large number of cases (probably the majority) it's some random person
on another continent.  Their box is dead and after a reboot there's
nothing in the logs.  Now what?

