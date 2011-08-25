Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1HYLj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:39:26 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54760 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab1HYLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:39:24 -0400
Subject: Re: 3.1-rc3 fails to boot on my pandaboard
From: Luciano Coelho <coelho@ti.com>
To: Govindraj <govindraj.ti@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
In-Reply-To: <CAAL8m4whQJSXQw+E52qF2vLSBrt=RsA-r-B2q2gaW3XGiR4tYg@mail.gmail.com>
References: <1314268769.2296.283.camel@cumari>
	 <CAAL8m4whQJSXQw+E52qF2vLSBrt=RsA-r-B2q2gaW3XGiR4tYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 14:39:18 +0300
Message-ID: <1314272358.2296.296.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 17:05 +0530, Govindraj wrote: 
> On Thu, Aug 25, 2011 at 4:09 PM, Luciano Coelho <coelho@ti.com> wrote:
> > Hi,
> >
> > There seems to be a problem with 3.1-rc3, which prevents it from booting
> > on my PandaBoard (ARM OMAP4).
> >
> > 3.1-rc2 works fine, so I have bisected the problem and it turns out to
> > be caused by this:
> >
> > commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464
> > Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Date:   Thu Jul 7 22:32:17 2011 +0200
> >
> >    irq: Always set IRQF_ONESHOT if no primary handler is specified
> >
> > After reverting this commit, -rc3 boots fine.  I'm not sure where
> > exactly the problem is.  Maybe it's something in the omap code which is
> > broken and this patch causes the bug to show up?
> >
> > What happens is that the booting process hangs after printing out this:
> >
> 
> fyi,
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=69dd3d8e29e294caaf63eb5e8a72d250279f9e5f;hp=fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c

Ah, thanks.  Now I see where the irq == 74 comes from. :) Still, I don't
see that on my system.

-- 
Cheers,
Luca.

