Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2GaPl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:41:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39203 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555Ab2GaPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:41:55 -0400
Date: Tue, 31 Jul 2012 16:41:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
Message-ID: <20120731154153.GI4468@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix>
 <20120730153309.GK4468@opensource.wolfsonmicro.com>
 <1343701316.7557.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343701316.7557.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:21:56AM +0800, Axel Lin wrote:
> 於 一，2012-07-30 於 16:33 +0100，Mark Brown 提到：
> > On Mon, Jul 30, 2012 at 07:47:13AM +0800, Axel Lin wrote:

> > >  		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
> > > -				     (void *)best_val);
> > > +				     (void *)(uintptr_t)best_val);

> > This also looks problematic, you should never need to cast a pointer to
> > or from void.

> If I remove the cast to (void *), I got below build warning:

>   CC      drivers/regulator/core.o
> drivers/regulator/core.c: In function '_regulator_do_set_voltage':
> drivers/regulator/core.c:2183:10: warning: passing argument 3 of
> '_notifier_call_chain' makes pointer from integer without a cast
> [enabled by default]
> drivers/regulator/core.c:94:13: note: expected 'void *' but argument is
> of type 'long unsigned int'

So the above cast probably isn't right...  you shouldn't need a double
cast here.
