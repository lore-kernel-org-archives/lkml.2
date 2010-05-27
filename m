Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0E0N1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:27:43 -0400
Received: from www.tglx.de ([62.245.132.106]:47374 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0E0N1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:27:42 -0400
Date: Thu, 27 May 2010 15:26:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Florian Mickler <florian@mickler.org>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1005271519460.3032@localhost.localdomain>
References: <20100526171106.0e44a736@schatten.dmk.lab> <alpine.LFD.2.00.1005261829540.2995@localhost.localdomain> <20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Alan Cox wrote:

> > The power efficiency of a mobile device is depending on a sane overall
> > software stack and not on the ability to mitigate crappy software in
> > some obscure way which is prone to malfunction and disappoint users.
> 
> Even if you believe the kernel should be containing junk the model that
> works and is used for everything else is resource management. Not giving
> various tasks the ability to override rules, otherwise you end up needing
> suspend blocker blockers next week.

We definitely will need them when we want to optimize the kernel
resource management on a QoS based scheme, which is the only sensible
way to go IMNSHO.

> A model based on the idea that a task can set its desired wakeup
> behaviour *subject to hard limits* (ie soft/hard process wakeup) works
> both for the sane system where its elegantly managing hard RT, and for
> the crud where you sandbox it to stop it making a nasty mess.

Right, the base system can set sensible defaults for "verified" apps,
which will work most of the time except for those which have special
requirements and need a skilled coder anyway. And for the sandbox crud
the sensible default can be "very long time" and allow the kernel to
ignore them at will.

> Do we even need a syscall or will adding RLIMIT_WAKEUP or similar do the
> trick ?

That might be a good starting point.

Thanks,

	tglx
