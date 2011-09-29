Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab1I2UWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:22:24 -0400
Received: from dan.rpsys.net ([93.97.175.187]:53771 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab1I2UWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:22:23 -0400
Subject: Re: [PATCH] backlight: Rename corgibl_limit_intensity to
 genericbl_limit_intensity
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Andrew Morton <akpm00@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 Sep 2011 21:22:01 +0100
In-Reply-To: <20110929130049.a3b56e19.akpm00@gmail.com>
References: <1316916753.5006.1.camel@phoenix>
	 <20110929130049.a3b56e19.akpm00@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317327729.12332.121.camel@ted>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 13:00 -0700, Andrew Morton wrote:
> On Sun, 25 Sep 2011 10:12:33 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
> 
> > The rename of corgibl_limit_intensity is missed in commit d00ba726
> > "backlight: Rename the corgi backlight driver to generic".
> > Let's fix it now.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > ---
> >  drivers/video/backlight/generic_bl.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
> > index 8c6befd..adb1914 100644
> > --- a/drivers/video/backlight/generic_bl.c
> > +++ b/drivers/video/backlight/generic_bl.c
> > @@ -56,7 +56,7 @@ static int genericbl_get_intensity(struct backlight_device *bd)
> >   * Called when the battery is low to limit the backlight intensity.
> >   * If limit==0 clear any limit, otherwise limit the intensity
> >   */
> > -void corgibl_limit_intensity(int limit)
> > +void genericbl_limit_intensity(int limit)
> >  {
> >  	struct backlight_device *bd = generic_backlight_device;
> >  
> > @@ -68,7 +68,7 @@ void corgibl_limit_intensity(int limit)
> >  	backlight_update_status(generic_backlight_device);
> >  	mutex_unlock(&bd->ops_lock);
> >  }
> > -EXPORT_SYMBOL(corgibl_limit_intensity);
> > +EXPORT_SYMBOL(genericbl_limit_intensity);
> >  
> 
> Why does corgibl_limit_intensity/genericbl_limit_intensity exist? 
> Nothing in the tree references it?

It sounds like someone has removed the sharpsl battery driver which did
use this. If this hook isn't used, low battery with high screen
backlight values will reset the device as the wiring isn't up to the
current draw.

Richard


