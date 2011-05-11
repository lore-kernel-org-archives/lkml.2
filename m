Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1EKVPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:15:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60096 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab1EKVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:14:59 -0400
Date: Wed, 11 May 2011 22:14:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6 0/5] Basic ARM devicetree support
Message-ID: <20110511211438.GM5315@n2100.arm.linux.org.uk>
References: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:44:49PM +0200, Grant Likely wrote:
> Right now it merges cleanly with linux-next and the resulting tree
> builds and boots at least on qemu.  Unless you really object, I'm
> going to ask Stephen to add the following branch to the /end/ of the
> list of trees for linux-next so it can easily be dropped it if it
> causes any problems.

As far as the set of five patches looks fine to me, I don't have any
objections against them.  So I think we can merge them for .40.

What I've always worried about is the platform stuff, and that's
something I'm going to continue worrying about because I don't think
we have sufficient review capacity to ensure that we don't end up
with lots of stupidities.

Eg, we need to properly sort out how we're going to represent stuff
so we don't end up with X IRQ controllers, Y clock events, etc.  In
other words, I don't want to see DT growing an AT91 IRQ controller,
PXA IRQ controller, SA1100 IRQ controller, etc.

One of the things we must deal with is how do we reduce the amount
of IRQ controller code, clock event code, etc that we have in the
kernel tree.  That means coming up with some generic representation
of these facilities and having the right DT properties in place to
be able to describe to the generic representation what's required of
it.

If we can't do that, then DT isn't solving the problem which Linus
has complained about, and we will still be in the situation where
platform X wants its own IRQ controller, clock event, etc code.
