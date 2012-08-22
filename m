Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2HVJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:48:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43061 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758804Ab2HVJsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:48:24 -0400
Date: Wed, 22 Aug 2012 11:48:20 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>, Axel Lin <axel.lin@gmail.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: lm3533-als: Fix build warnings
Message-ID: <20120822094820.GA18415@localhost>
References: <1343902209.1207.2.camel@phoenix>
 <502AB521.6090201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502AB521.6090201@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 09:29:21PM +0100, Jonathan Cameron wrote:
> On 08/02/2012 11:10 AM, Axel Lin wrote:
> > Fix below build warnings:
> >   CC [M]  drivers/iio/light/lm3533-als.o
> > drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
> > drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.show') [enabled by default]
> > drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
> > drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.store') [enabled by default]
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Thanks queued up.

Thanks for fixing this and sorry for not responding sooner (vacation...).

Johan

> > ---
> >  drivers/iio/light/lm3533-als.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iio/light/lm3533-als.c b/drivers/iio/light/lm3533-als.c
> > index c3e7bac..e45712a9 100644
> > --- a/drivers/iio/light/lm3533-als.c
> > +++ b/drivers/iio/light/lm3533-als.c
> > @@ -404,7 +404,7 @@ out:
> >  	return ret;
> >  }
> >  
> > -static int show_thresh_either_en(struct device *dev,
> > +static ssize_t show_thresh_either_en(struct device *dev,
> >  					struct device_attribute *attr,
> >  					char *buf)
> >  {
> > @@ -424,7 +424,7 @@ static int show_thresh_either_en(struct device *dev,
> >  	return scnprintf(buf, PAGE_SIZE, "%u\n", enable);
> >  }
> >  
> > -static int store_thresh_either_en(struct device *dev,
> > +static ssize_t store_thresh_either_en(struct device *dev,
> >  					struct device_attribute *attr,
> >  					const char *buf, size_t len)
> >  {
> > 
