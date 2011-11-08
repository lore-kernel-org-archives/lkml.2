Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1KHXRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:17:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1KHXRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:17:54 -0500
Date: Tue, 8 Nov 2011 15:17:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Wilson <wilsons@start.ca>,
        Alexey Dobriyan <adobriyan@gmail.com>, security@kernel.org
Subject: Re: [PATCH] proc: restrict access to /proc/$PID/{sched,schedstat}
Message-Id: <20111108151752.b2e37741.akpm@linux-foundation.org>
In-Reply-To: <20111108115900.GA14587@albatros>
References: <20111105104828.GA3489@albatros>
	<20111108115900.GA14587@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011 15:59:00 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> (CC'ed l-k)

security@kernel.org isn't working, btw.

> On Sat, Nov 05, 2011 at 14:48 +0400, Vasiliy Kulikov wrote:
> > /proc/$PID/{sched,schedstat} contain debugging scheduler counters, which
> > should not be world readable.  They may be used to gather private information
> > about processes' activity.  E.g. it can be used to count the number of
> > characters typed in gksu dialog:
> > 
> > http://www.openwall.com/lists/oss-security/2011/11/05/3
> > 
> > This infoleak is similar to io (1d1221f375c) and stat's eip/esp (f83ce3e6b02d)
> > infoleaks.  Probably other 0644/0444 procfs files are vulnerable to
> > similar infoleaks.

Grumble.

The obvious issue with this patch is its non-back-compatibility.  What
existing code will break, in what manner and what is the seriousness of
the breakage?

You *know* this is the main issue, yet you didn't address it at all! 
You just leave the issue out there for other people to work out, and to
ask the obvious questions.

This happens over and over and I'm getting rather tired of the charade.

So I'm going to ignore this patch and I ask that you and other security
people never do this again.

If you're going to submit a patch which you know will change kernel
interfaces in a non-backward-compatible fashion then don't just pretend
that it didn't happen!  Please provide us with a complete description
of the breakage and at least some analysis of the downstream
implications of the change.  So that we are better able to decide
whether the security improvements justify the disruption.

