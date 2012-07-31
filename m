Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2GaQIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:08:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2GaQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:08:19 -0400
Message-ID: <1343750888.5463.5.camel@phoenix>
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 01 Aug 2012 00:08:08 +0800
In-Reply-To: <20120731154153.GI4468@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix>
	 <20120730153309.GK4468@opensource.wolfsonmicro.com>
	 <1343701316.7557.1.camel@phoenix>
	 <20120731154153.GI4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2012-07-31 於 16:41 +0100，Mark Brown 提到：
> On Tue, Jul 31, 2012 at 10:21:56AM +0800, Axel Lin wrote:
> > 於 一，2012-07-30 於 16:33 +0100，Mark Brown 提到：
> > > On Mon, Jul 30, 2012 at 07:47:13AM +0800, Axel Lin wrote:
> 
> > > >  		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
> > > > -				     (void *)best_val);
> > > > +				     (void *)(uintptr_t)best_val);
> 
> > > This also looks problematic, you should never need to cast a pointer to
> > > or from void.
> 
> > If I remove the cast to (void *), I got below build warning:
> 
> >   CC      drivers/regulator/core.o
> > drivers/regulator/core.c: In function '_regulator_do_set_voltage':
> > drivers/regulator/core.c:2183:10: warning: passing argument 3 of
> > '_notifier_call_chain' makes pointer from integer without a cast
> > [enabled by default]
> > drivers/regulator/core.c:94:13: note: expected 'void *' but argument is
> > of type 'long unsigned int'
> 
> So the above cast probably isn't right...  you shouldn't need a double
> cast here.

The issue of original warning is: ( I compile the kernel on x86_64 )
        warning: cast to pointer from integer of different size

What this patch does is:
cast best_val to uintptr_t, which is an unsigned integer large enough to
hold a void* pointer.

And then cast it to (void *).

Thus I did (void *)(uintptr_t)best_val.

Regards,
Axel



