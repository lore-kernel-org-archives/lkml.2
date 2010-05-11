Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0EKRZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:25:47 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38760 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0EKRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:25:46 -0400
Date: Tue, 11 May 2010 19:25:29 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/3] power/ds2760_battery: use factor of 20 for
 rated_capacity
Message-ID: <20100511172528.GD30801@buzzloop.caiaq.de>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-3-git-send-email-daniel@caiaq.de>
 <20100511171924.GA19428@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511171924.GA19428@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:19:24PM +0400, Anton Vorontsov wrote:
> On Tue, May 11, 2010 at 06:38:46PM +0200, Daniel Mack wrote:
> >  drivers/power/ds2760_battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
> > index b82bf92..7b3043f 100644
> > --- a/drivers/power/ds2760_battery.c
> > +++ b/drivers/power/ds2760_battery.c
> > @@ -78,7 +78,7 @@ MODULE_PARM_DESC(current_accum, "current accumulator value");
> >  
> >  /* Some batteries have their rated capacity stored a N * 10 mAh, while
> >   * others use an index into this table. */
> > -#define RATED_CAPACITY_FACTOR 10
> > +#define RATED_CAPACITY_FACTOR 20
> 
> I'm a bit worried about this one.
> 
> Shouldn't this confuse batteries that already store rated
> capacity with factor of ten? If so, please introduce a module
> option.
> 
> Also, you don't update comments and module params description,
> e.g.
> 
>   MODULE_PARM_DESC(rated_capacity, "rated battery capacity, 10*mAh or index");
>   ....
>   /* set rated capacity from module param (given in 10 * mAh) */
> 
> Is that intentionally?

Well, this parameter doesn't change, and hence the comment is left
untouched. If it is passed as module option, it is interpreted as 10*mAh
and converted to the internal value.

You're right though about your concern about batteries that already
stored a value given in mAh (and not as index) - this will break unless
the module is loaded with a proper module parameter. Don't know whether
this is acceptable.

Daniel
