Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0EKRrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:47:49 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47785 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0EKRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LC0QAY2Tso0U571tg+5xldR6AT0n+jwMgHdVCC7rwxD9KOyuQUgx4Yr8hSdPMvqkcl
         CsbWX79SRcDV/v1Fcc0rPAOKlM+Jr//yy0J61aBssvHHlWF0+NA77FGlUrguK+JvtttL
         W4SUdvKEnwu/dUcH4UOc8kzONu/eaLCcz/EiE=
Date: Tue, 11 May 2010 21:47:42 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/3] power/ds2760_battery: use factor of 20 for
 rated_capacity
Message-ID: <20100511174742.GA26871@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-3-git-send-email-daniel@caiaq.de>
 <20100511171924.GA19428@oksana.dev.rtsoft.ru>
 <20100511172528.GD30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100511172528.GD30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:25:29PM +0200, Daniel Mack wrote:
[...]
> > >  /* Some batteries have their rated capacity stored a N * 10 mAh, while
> > >   * others use an index into this table. */
> > > -#define RATED_CAPACITY_FACTOR 10
> > > +#define RATED_CAPACITY_FACTOR 20
> > 
> > I'm a bit worried about this one.
> > 
> > Shouldn't this confuse batteries that already store rated
> > capacity with factor of ten? If so, please introduce a module
> > option.
> > 
> > Also, you don't update comments and module params description,
> > e.g.
> > 
> >   MODULE_PARM_DESC(rated_capacity, "rated battery capacity, 10*mAh or index");
> >   ....
> >   /* set rated capacity from module param (given in 10 * mAh) */
> > 
> > Is that intentionally?
> 
> Well, this parameter doesn't change, and hence the comment is left
> untouched. If it is passed as module option, it is interpreted as 10*mAh
> and converted to the internal value.
> 
> You're right though about your concern about batteries that already
> stored a value given in mAh (and not as index) - this will break unless
> the module is loaded with a proper module parameter. Don't know whether
> this is acceptable.

Unfortunately, it is not. You have to do a run-time option, i.e.
module parameter (you can set up default value for this module
parameter via Kconfig symbol).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
