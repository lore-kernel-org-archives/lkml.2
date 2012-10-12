Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab2JLIYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:24:22 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:59138 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab2JLIYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:24:19 -0400
Date: Fri, 12 Oct 2012 10:24:12 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap : make lock/unlock functions customizable.
Message-ID: <20121012082412.GA9779@mail.gnudd.com>
References: <1349127064-432-1-git-send-email-ciminaghi@gnudd.com> <20121012062607.GN11726@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121012062607.GN11726@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 03:26:09PM +0900, Mark Brown wrote:
> On Mon, Oct 01, 2012 at 11:31:04PM +0200, ciminaghi@gnudd.com wrote:
> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > 
> > It is sometimes convenient for a regmap user to override the standard
> > regmap lock/unlock functions with custom functions.
> 
> This looks good overall but...
> 
> > -static void regmap_lock_mutex(struct regmap *map)
> > +static void regmap_lock_mutex(void *__map)
> >  {
> > +	struct regmap *map = (struct regmap *)__map;
> >  	mutex_lock(&map->mutex);
> 
> ...you should never need to cast away from or to void, if you do there's
> a bug somewhere.

regmap lock/unlock original functions just received a struct regmap * .
I needed a void * for the customized version of such functions, so just
replaced struct regmap * with void *

typedef void (*regmap_lock)(void *);
typedef void (*regmap_unlock)(void *);

The cast isn't actually needed (code compiles with no warnings without it).
I could also do something like this, if you think it's better:

typedef void (*regmap_lock)(struct regmap *, void *);
typedef void (*regmap_unlock)(struct regmap *, void *);

and then ignore the second argument in the default version of the functions.

Thanks and regards
Davide

