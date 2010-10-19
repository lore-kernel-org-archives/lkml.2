Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0JSP3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:29:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab0JSP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <1287487757.24189.40.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Oct 2010 08:28:27 -0700
Message-ID: <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 4:29 AM, Mike Galbraith <efault@gmx.de> wrote:
> It was suggested that I show a bit more info.

Yes, I was going to complain that the numbers in the commit message
made no sense without something to compare the numbers to.

> The same load without per tty task groups.

Very impressive. This definitely looks like something people will notice.

That said, I do think we should think carefully about calling this a
"tty" feature. I think we might want to leave the door open to other
heuristics than _just_ the tty group. I think the tty group approach
is wonderful for traditional Unix loads in a desktop environment, but
I suspect we might hit issues with IDE's etc too. I don't know if we
can notice things like that automatically, but I think it's worth
thinking about.

So I think the patch looks pretty good, and the numbers seem to look
just stunningly so, but I'd like to name the feature more along the
lines of "automatic process group scheduling" rather than about tty's
per se.

And you actually did that for the Kconfig option, which makes me quite happy.

The one other thing I do wonder about is how noticeable the group
scheduling overhead is. If people compare with a non-CGROUP_SCHED
kernel, will a desktop-optimized kernel suddenly have horrible pipe
latency due to much higher scheduling cost? Right now that whole
feature is hidden by EXPERIMENTAL, I don't know how much it hurts, and
I never timed it when I tried it out long ago..

                            Linus
