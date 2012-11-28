Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2K1VFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:05:39 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51427 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab2K1VFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:05:11 -0500
Date: Wed, 28 Nov 2012 22:05:10 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121128210509.GA2590@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
 <20121127224341.GA2605@local>
 <201211281058.33185.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211281058.33185.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:58:32AM +0200, Vitalii Demianets wrote:
> On Wednesday 28 November 2012 00:43:41 Hans J. Koch wrote:
> > 
> > Thanks, good catch, but why don't you simply do this:
> > 
> 
> Just a matter of personal preference.

Your patch: 1 files changed, 12 insertions(+), 4 deletions(-)
My patch: 1 files changed, 1 insertions(+), 1 deletions(-)

Both achieve exactly the same. That's not a matter of personal
preference, that's the difference between a working solution and
a good solution. In the kernel, we want the latter.

> As a maintainer you can apply either 
> patch you want. I guess you would prefer your approach and I have no 
> objections to that :)

That's not the right kind of comment. Don't make it a habit.

Thanks,
Hans

> 
> > 
> > >From 228445996bb75a44d16b6237eca6a0916d9b2d7e Mon Sep 17 00:00:00 2001
> > From: "Hans J. Koch" <hjk@hansjkoch.de>
> > Date: Tue, 27 Nov 2012 23:38:00 +0100
> > Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized
> > 
> > In two cases, the return value variable "ret" can be undefined.
> > 
> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> > ---
> >  drivers/uio/uio.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > index 5110f36..fc60e35 100644
> > --- a/drivers/uio/uio.c
> > +++ b/drivers/uio/uio.c
> > @@ -263,7 +263,7 @@ static struct class uio_class = {
> >   */
> >  static int uio_dev_add_attributes(struct uio_device *idev)
> >  {
> > -	int ret;
> > +	int ret = -ENOMEM;
> >  	int mi, pi;
> >  	int map_found = 0;
> >  	int portio_found = 0;
> 
> 
> 
> -- 
> With Best Regards,
> Vitalii Demianets
> 
> 
