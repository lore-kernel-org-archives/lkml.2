Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab2K2QWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:22:22 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:60711 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2K2QWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:22:21 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: Tux9 <tuxding@gmail.com>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Date: Thu, 29 Nov 2012 18:22:16 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271348.14603.vitas@nppfactor.kiev.ua> <20121128210509.GA2590@local> <CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
In-Reply-To: <CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211291822.16565.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2012 18:05:27 Tux9 wrote:
> Hans, I think there are something wrong in your patch, while Vitalii's
> is right. The variable "ret" is reused in line 292 and line 295, so
> the value of "ret" would be overridden (if it goto err_map in line 284
> when mi>=1).
> 

Actually, both patches do exactly the same thing. Hans's patch establishes 
default value for the ret for all those "other" cases when ret is not 
explicitly overridden. My patch explicitly enumerates all those "other" cases 
in more wordily manner.

> 
> On Wed, Nov 28, 2012 at 10:05 PM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> > On Wed, Nov 28, 2012 at 10:58:32AM +0200, Vitalii Demianets wrote:
> >> On Wednesday 28 November 2012 00:43:41 Hans J. Koch wrote:
> >> >
> >> > Thanks, good catch, but why don't you simply do this:
> >> >
> >>
> >> Just a matter of personal preference.
> >
> > Your patch: 1 files changed, 12 insertions(+), 4 deletions(-)
> > My patch: 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > Both achieve exactly the same. That's not a matter of personal
> > preference, that's the difference between a working solution and
> > a good solution. In the kernel, we want the latter.
> >
> >> As a maintainer you can apply either
> >> patch you want. I guess you would prefer your approach and I have no
> >> objections to that :)
> >
> > That's not the right kind of comment. Don't make it a habit.
> >
> > Thanks,
> > Hans
> >
> >>
> >> >
> >> > >From 228445996bb75a44d16b6237eca6a0916d9b2d7e Mon Sep 17 00:00:00 2001
> >> > From: "Hans J. Koch" <hjk@hansjkoch.de>
> >> > Date: Tue, 27 Nov 2012 23:38:00 +0100
> >> > Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized
> >> >
> >> > In two cases, the return value variable "ret" can be undefined.
> >> >
> >> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> >> > ---
> >> >  drivers/uio/uio.c |    2 +-
> >> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >> >
> >> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> >> > index 5110f36..fc60e35 100644
> >> > --- a/drivers/uio/uio.c
> >> > +++ b/drivers/uio/uio.c
> >> > @@ -263,7 +263,7 @@ static struct class uio_class = {
> >> >   */
> >> >  static int uio_dev_add_attributes(struct uio_device *idev)
> >> >  {
> >> > -   int ret;
> >> > +   int ret = -ENOMEM;
> >> >     int mi, pi;
> >> >     int map_found = 0;
> >> >     int portio_found = 0;
