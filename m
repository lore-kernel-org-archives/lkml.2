Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2JOA6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:58:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40398 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab2JOA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:58:19 -0400
Date: Mon, 15 Oct 2012 09:58:15 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap : make lock/unlock functions customizable.
Message-ID: <20121015005813.GB24935@opensource.wolfsonmicro.com>
References: <1349127064-432-1-git-send-email-ciminaghi@gnudd.com>
 <20121012062607.GN11726@opensource.wolfsonmicro.com>
 <20121012082412.GA9779@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012082412.GA9779@mail.gnudd.com>
X-Cookie: Beware the one behind you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:24:12AM +0200, Davide Ciminaghi wrote:
> On Fri, Oct 12, 2012 at 03:26:09PM +0900, Mark Brown wrote:
> > On Mon, Oct 01, 2012 at 11:31:04PM +0200, ciminaghi@gnudd.com wrote:

> > > +	struct regmap *map = (struct regmap *)__map;
> > >  	mutex_lock(&map->mutex);

> > ...you should never need to cast away from or to void, if you do there's
> > a bug somewhere.

> regmap lock/unlock original functions just received a struct regmap * .
> I needed a void * for the customized version of such functions, so just
> replaced struct regmap * with void *

You're not getting the point.  The issue is the casts, not the prototype
of the function.  If those casts when referencing the pointer do
anything at all it's masking a bug, you should never need to cast a
pointer to or from void.
