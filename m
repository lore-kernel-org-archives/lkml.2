Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0JHT6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab0JHT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:58:48 -0400
Date: Fri, 8 Oct 2010 12:58:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-Id: <20101008125803.e5bc7306.akpm@linux-foundation.org>
In-Reply-To: <20101007192245.GC26435@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 20:22:45 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> > Many drivers are broken, and there's no alternative in sight. Such a big
> > change should stay as a warning for now, and only later should it
> > actually fail.
> > 
> > The drivers are not doing something correct, we get it, but for now it's
> > better to allow them to work (they do 99% of the time anyway) rather
> > than to force everyone to revert this patch in their internal trees
> > until there's a solution. A slightly broken functionality is better than
> > no functionality at all.
> > 
> > A warning lets people know that what they are doing is not right, and
> > they should fix it.
> 
> So what are _you_ going to do to fix these drivers?  Continue reverting
> this patch?  Or are you just going to ignore the issue entirely?
> 
> Unless people can come up with a plan to fix their drivers using ioremap
> on system RAM thereby violating the architecture specification, I'm
> _not_ going to apply this patch.

We *do* have a plan: as of 2.6.36, the kernel will emit a WARN_ON trace
when a driver does this.  Offending code will be discovered, developers
will get bug reports from worried users, etc.  This is usually pretty
effective.

