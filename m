Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0H0Wk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:40:26 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:46488 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0H0WkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:40:24 -0400
Date: Fri, 27 Aug 2010 15:39:26 -0700
From: Jean Tourrilhes <jt@hpl.hp.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
Message-ID: <20100827223926.GB32498@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20100827210240.GC4703@outflux.net> <20100827212254.GB32275@bougret.hpl.hp.com> <AANLkTimeEa_=dqX5yFnYzaSaL90TfOg3=MsydG81naAC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimeEa_=dqX5yFnYzaSaL90TfOg3=MsydG81naAC@mail.gmail.com>
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 03:35:19PM -0700, Luis R. Rodriguez wrote:
> >
> > diff -u -p wext.j2.c wext.c
> > --- wext.j2.c   2010-08-27 14:17:26.000000000 -0700
> > +++ wext.c      2010-08-27 14:19:33.000000000 -0700
> > @@ -800,9 +800,12 @@ static int ioctl_standard_iw_point(struc
> >                        goto out;
> >                }
> >
> > -               if (copy_to_user(iwp->pointer, extra,
> > -                                iwp->length *
> > -                                descr->token_size)) {
> > +               /* Verify how much we should return. Some driver
> > +                * may abuse iwp->length... */
> > +               if((iwp->length * descr->token_size) < extra_size)
> > +                       extra_size = iwp->length * descr->token_size;
> > +
> > +               if (copy_to_user(iwp->pointer, extra, extra_size)) {
> >                        err = -EFAULT;
> >                        goto out;
> >                }
> 
> 
> Jean, can you submit in a new thread and right before the SOB add in
> the commit log Cc: stable@kernel.org [2.6.32+]

	The current patch was made for 2.6.27 and was only
compiled. Someone would need to verify it works for 2.6.32. I could
probably find some time next week.

>   Luis

	Regards,

	Jean
