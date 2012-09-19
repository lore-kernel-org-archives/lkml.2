Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2ISUj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:39:58 -0400
Received: from 1wt.eu ([62.212.114.60]:34395 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2ISUj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:39:57 -0400
Date: Wed, 19 Sep 2012 22:39:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Joe Perches <joe@perches.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, willy@meta-x.org,
        gregkh@linuxfoundation.org, evel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: panel: Fixed a macro coding style issue
Message-ID: <20120919203942.GB413@1wt.eu>
References: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com> <1348083898.2055.8.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348083898.2055.8.camel@joe2Laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 12:44:58PM -0700, Joe Perches wrote:
> On Thu, 2012-09-20 at 01:07 +0530, Adil Mujeeb wrote:
> > Removed do {} while (0) loop for a single statement macros
> > 
> > Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
> > ---
> >  linux-3.6-rc6/drivers/staging/panel/panel.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/linux-3.6-rc6/drivers/staging/panel/panel.c b/linux-3.6-rc6/drivers/staging/panel/panel.c
> > index 39f9982..d9fec5b 100644
> > --- a/linux-3.6-rc6/drivers/staging/panel/panel.c
> > +++ b/linux-3.6-rc6/drivers/staging/panel/panel.c
> > @@ -137,8 +137,8 @@
> >  #define r_ctr(x)        (parport_read_control((x)->port))
> >  #define r_dtr(x)        (parport_read_data((x)->port))
> >  #define r_str(x)        (parport_read_status((x)->port))
> > -#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
> > -#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
> > +#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
> > +#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))
> 
> Unnecessary parentheses too.
> It might be better to use static inlines instead.

Agreed. We already got bugs in the cyrix register manipulation for
years because of the use of macros which caused registers to be set
in the wrong order, let's not redo that mistake again.

Willy

