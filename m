Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0KYGku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:40:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0KYGks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:40:48 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.224.233]
In-Reply-To: <536589.12568.qm@web180310.mail.gq1.yahoo.com>
References: <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com> <536589.12568.qm@web180310.mail.gq1.yahoo.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 25 Nov 2010 08:40:27 +0200
Message-ID: <AANLkTinQdNC0XaOqNyDbdYE6ZcP0QyzpN492j=Kovuea@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: David Brownell <david-b@pacbell.net>
Cc: MugdhaKamoolkar <mugdha@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        BenoitCousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        HariKanigeri <h-kanigeri2@ti.com>, SumanAnna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 5:59 AM, David Brownell <david-b@pacbell.net> wrote:
> My rule of thumb is that nothing is "generic"
> until at least three whatever-it-is instances
> plug in to it.  Sometimes this is called
> the "Rule of Three".
>
> Other than OMAP, what's providing hardware
> spinlocks that plug into this framework?

We are not aware of any.

That's why the first iteration was just an omap-specific misc driver.

But we were asked not to pollute device drivers with omap-specific
interfaces (see the discussion on [1]). I think it's a good goal (it
will keep the IPC drivers that will come from TI platform-agnostic),
so we split the driver into a generic interface plus small
omap-specific implementation.

This way platforms [2] can easily plug into the framework anything
they need to achieve multi-core synchronization. E.g., even in case a
platform doesn't have dedicated silicon, but still need this
functionality, it can still plug in an implementation which is based
on Peterson's shared memory mutual exclusion algorithm (see
http://en.wikipedia.org/wiki/Peterson's_algorithm).

The third alternative is to have this driver completely hidden inside
the omap folders and deliver pdata func pointer to drivers that use
it. I am not fond of this, since the driver really only have a tiny
omap-specific part, and most of it should really sit in drivers/. In
addition, it will probably kill the chance of others using it too.

[1] http://lkml.org/lkml/2010/10/22/317
[2] this is mainly aimed at non-coherent heterogeneous processors that
do not support fancy synchronization primitives

>
> - Dave
>
>
