Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2K3XVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:21:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab2K3XVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:21:51 -0500
Date: Fri, 30 Nov 2012 15:21:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH] Avoid dead lock of console related locks in panic case
Message-Id: <20121130152149.6f266216.akpm@linux-foundation.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A0339D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
	<20121130143023.2d67d817.akpm@linux-foundation.org>
	<A5ED84D3BB3A384992CBB9C77DEDA4D414A0339D@USINDEM103.corp.hds.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 22:59:13 +0000
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> > 
> > Let's step back a bit.  Please identify with great specificity the code sites which are stopping other CPUs before taking locks which
> > those other CPUs might have been holding.
> > 
> > Then let's see what we can do to fix up the callers, instead of trying to tidy up after they have made this mess.
> 
> OK.
> I will update my patch without adding complexity.
> The logic will be as follows, if I understand your comment correctly.
> 
>  - take console related locks (logbuf_lock, console_sem)
>  - stop other cpus
>  - release those locks

That would be one way around the problem.  It's still a bit messy,
because we'll have to take more and more locks in the future, as we
identify them.

What I actually meant was: can "this" CPU avoid stopping other CPUs so
early?  If we stop the other CPUs when this CPU is ready to stop itself
then there will never be such deadlocks.

