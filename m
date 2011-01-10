Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1AJN5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:57:42 -0500
Received: from www.tglx.de ([62.245.132.106]:55866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab1AJN5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:57:38 -0500
Date: Mon, 10 Jan 2011 14:54:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Rob <roblinux@gmail.com>, linux-kernel@vger.kernel.org,
        "Brown, Len" <lenb@kernel.org>
Subject: Re: TSC as clocksource
In-Reply-To: <1294667092.11896.0.camel@laptop>
Message-ID: <alpine.LFD.2.00.1101101452290.12146@localhost6.localdomain6>
References: <AANLkTikBu6vggpTUQy_MeTG_PJ9WWoHVyDL0OLPa6v=_@mail.gmail.com> <1294667092.11896.0.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Peter Zijlstra wrote:

> On Mon, 2011-01-10 at 09:54 +1100, Rob wrote:
> > Want to use TSC as clocksource
> > have a Intel Core2 Duo with constant_tsc flag
> > TSC should be stable at C1 + C2, it is debatable whether C3 is stable
> > 
> > Using processor.max_cstate=2 to use only C1 + C2 changes nothing, still get
> > Monitor-Mwait will be used to enter C-3 state
> > there should be checks before this is forced

We unconditinally set TSC unstable for anything > C1. The reason is
that we had a lot of troubles with BIOSes which advertise C2, but in
fact implement C3. Unfortunately we can't verify that.

Thanks,

	tglx
