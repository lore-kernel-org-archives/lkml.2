Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab2C1QWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:22:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55982 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754840Ab2C1QWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:22:46 -0400
Message-ID: <1332951765.16535.38.camel@joe2Laptop>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 28 Mar 2012 09:22:45 -0700
In-Reply-To: <20120328094609.GA3232@opensource.wolfsonmicro.com>
References: <1332869030.2213.46.camel@joe2Laptop>
	 <4F72BD4F.9020305@ladisch.de> <1332919803.16535.22.camel@joe2Laptop>
	 <20120328094609.GA3232@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 10:46 +0100, Mark Brown wrote:
> On Wed, Mar 28, 2012 at 12:30:03AM -0700, Joe Perches wrote:
> > On Wed, 2012-03-28 at 09:27 +0200, Clemens Ladisch wrote:
> > > Joe Perches wrote:
> > > > +regulator-y := core.o dummy.o fixed-helper.o
> > > > +regulator-objs := $(regulator-y)
> > > > -obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
> > > > +obj-$(CONFIG_REGULATOR) += regulator.o
> > > > Any objections or other suggestions/improvements?
> This seems an incredibly obscure approach.
> > > Instead of doing a Makefile change that has no _obvious_ connection with
> > > printk, wouldn't it be better to just define pr_fmt with "regulator: "?
> This seems like a much better idea if we're going to do anything; it
> means that we don't end up embedding module names in things (which are
> after all a bit of an implementation detail) and get to pick the name so
> we can do something like get the prefix which is used for the symbols in
> the code even if things are split over multiple modules.

A negative is that requires #defines in multiple
source files or rearranging #includes to centralize
that #define.

A negative of the Makefile approach is the name is
obscurely chosen.  A positive is it's only chosen
once.

> In the case above we don't support modular build in the first place.

Unrelated but is there any particular reason why
the regulator core code couldn't be build as a
module?

