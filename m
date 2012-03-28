Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2C1HaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:30:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34598 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752686Ab2C1HaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:30:05 -0400
Message-ID: <1332919803.16535.22.camel@joe2Laptop>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
From: Joe Perches <joe@perches.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 00:30:03 -0700
In-Reply-To: <4F72BD4F.9020305@ladisch.de>
References: <1332869030.2213.46.camel@joe2Laptop>
	 <4F72BD4F.9020305@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 09:27 +0200, Clemens Ladisch wrote:
> Joe Perches wrote:
> > With this change, objects like drivers/regulator/core.o
> > are prefixed with "core: ".  This is somewhat senseless
> > and may prompt Makefile changes to make the prefixes for
> > some objects more sensible.
> >
> > For example, modifying the Makefile to bundle objects
> > together with a specific name can change the prefixes.
> > Here the prefix becomes "regulator: "
> >
> > +++ b/drivers/regulator/Makefile
> >
> > +regulator-y := core.o dummy.o fixed-helper.o
> > +regulator-objs := $(regulator-y)
> >
> > -obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
> > +obj-$(CONFIG_REGULATOR) += regulator.o
> >
> > ------------------
> >
> > Any objections or other suggestions/improvements?
> 
> Instead of doing a Makefile change that has no _obvious_ connection with
> printk, wouldn't it be better to just define pr_fmt with "regulator: "?

Maybe, maybe not.

Bundling objects in a Makefile like this is pretty common
and can also produce better module names.


