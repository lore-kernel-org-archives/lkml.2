Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2ITFWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:22:37 -0400
Received: from 1wt.eu ([62.212.114.60]:34440 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2ITFWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:22:35 -0400
Date: Thu, 20 Sep 2012 07:22:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: Joe Perches <joe@perches.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: panel: Fixed a macro coding style issue
Message-ID: <20120920052217.GG413@1wt.eu>
References: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com> <1348083898.2055.8.camel@joe2Laptop> <20120919203942.GB413@1wt.eu> <CANBXnMmuPs7gvT5h4959Pq1aGrCA2jaSdqZnymQGNzJUVXqixg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBXnMmuPs7gvT5h4959Pq1aGrCA2jaSdqZnymQGNzJUVXqixg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 09:19:42AM +0530, Adil Mujeeb wrote:
> On Thu, Sep 20, 2012 at 2:09 AM, Willy Tarreau <w@1wt.eu> wrote:
> > On Wed, Sep 19, 2012 at 12:44:58PM -0700, Joe Perches wrote:
> >> On Thu, 2012-09-20 at 01:07 +0530, Adil Mujeeb wrote:
> >> > Removed do {} while (0) loop for a single statement macros
> >> >
> >> > Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
> >> > ---
> >> >  linux-3.6-rc6/drivers/staging/panel/panel.c |    4 ++--
> >> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/linux-3.6-rc6/drivers/staging/panel/panel.c b/linux-3.6-rc6/drivers/staging/panel/panel.c
> >> > index 39f9982..d9fec5b 100644
> >> > --- a/linux-3.6-rc6/drivers/staging/panel/panel.c
> >> > +++ b/linux-3.6-rc6/drivers/staging/panel/panel.c
> >> > @@ -137,8 +137,8 @@
> >> >  #define r_ctr(x)        (parport_read_control((x)->port))
> >> >  #define r_dtr(x)        (parport_read_data((x)->port))
> >> >  #define r_str(x)        (parport_read_status((x)->port))
> >> > -#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
> >> > -#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
> >> > +#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
> >> > +#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))
> >>
> >> Unnecessary parentheses too.
> >> It might be better to use static inlines instead.
> 
> I just did this change only as per checkpatch script warning. Also the
> parentheses is added similar to other macros.
> So should i removed all the macros and convert it to static inlines ?
> 
> > Agreed. We already got bugs in the cyrix register manipulation for
> > years because of the use of macros which caused registers to be set
> > in the wrong order, let's not redo that mistake again.
> 
> hmmm macros seems too dangerous but does it mean we should not use
> macros altogether?

As long as we can easily replace them with static inline, we should
avoid them. They're pretty useful for many things (eg: type-agnostic
data manipulation) but what you see above does not provide much value
in my opinion. And I wrote this something like 10 years ago but since
then I learned from my mistakes :-)

> So should i create a single patch which replaces all macros of this
> file into inline function?

It might be possible, but what are you trying to do ? If it's just a
minor cleanup patch, there is always the risk of breaking something
for zero value added. This driver needs a major lifting, it needs to
be cut into smaller functions for example. Maybe this is something
you should try to do instead of just changing a few defines ?

Also, do you have such a device to test your changes ?

> This is my first effort in submitting a patch :)

You're welcome in this effort, but you should be very careful.
Playing with driver code is fun and addictive, but that breaks much
faster than you can imagine and it becomes frustrating to see your
cleanup patch reverted two days after its inclusion.

Regards,
Willy

