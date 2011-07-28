Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1G1KQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:16:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G1KQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:16:07 -0400
Date: Thu, 28 Jul 2011 12:16:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Q] compiler no longer warning about undeclared struct?
In-Reply-To: <1311847409.3897.23.camel@thorin>
Message-ID: <Pine.LNX.4.64.1107281211120.20737@axis700.grange>
References: <Pine.LNX.4.64.1107271947490.7435@axis700.grange>
 <1311847409.3897.23.camel@thorin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:J2bjqk6dP6dI7ByS7V7mUVGhNP51jluU94gIHzr3TGZ
 HIypjMZhVn9jVRuokAgAE7kIQmOPd7lIRkQvgovjRUoTEU7qhG
 JCdbgVJ/Gqb/DhTY/sJpkbwBiZAIdvX8ZZ0VBQvh8mt90dMdGy
 bC6W0+CgnSIaTkSwAdmyzPXPNaMWHbyWYqzCKYYYOHA8nymUT7
 fGQOiBuoBT5HKcewoQI1VkX6QEz9fx8QYCtNEA646M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Bernd Petrovitsch wrote:

> Hi!
> 
> On Mit, 2011-07-27 at 19:57 +0200, Guennadi Liakhovetski wrote:
> [....]
> > I just ran across a driver in the kernel (drivers/media/video/ov2640.c, 
> > struct ov2640_priv::info), that does something like
> > 
> > struct xx {
> > 	struct yy *y;
> > };
> > 
> > static void z(void)
> > {
> > 	struct xx *x;
> > 	void *p;
> > 
> > 	x = ...;
> > 	p = ...;
> > 	x->y = p;
> > }
> > 
> > where "struct yy" is nowhere declared, and the compiler happily swallows 
> > this... Shouldn't it complain? Didn't it complain before?
> 
> It's normal C behaviour: As long as the compiler doesn't need the size
> or fields of struct yy, it doesn't complain that it doesn't know the
> details.

I always thought you need forward declarations for those, as in

struct yy;

before declaring struct xx above.

> Otherwise you could not define recursive structures as in
> ----  snip  ----
> struct a {
> 	struct *b;
> };
> struct b {
> 	struct *a;
> };
> ----  snip  ----

I would add a "struct b;" forward declaration before "struct a".

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
