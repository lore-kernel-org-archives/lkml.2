Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab1BRQWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:22:40 -0500
Received: from kroah.org ([198.145.64.141]:49773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab1BRQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:22:36 -0500
Date: Fri, 18 Feb 2011 08:15:16 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Driver core: convert platform_{get,set}_drvdata to
 static inline functions
Message-ID: <20110218161516.GA16713@kroah.com>
References: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
 <20110217084705.GA7435@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110217084705.GA7435@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 09:47:05AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Feb 16, 2011 at 11:23:27PM +0100, Marc Kleine-Budde wrote:
> > This patch converts the macros for platform_{get,set}_drvdata to
> > static inline functions to add typechecking.
> > 
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> > Changes since v1:
> > - remove ugly macro magic, use static inline functions instead
> > 
> >  include/linux/platform_device.h |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> > index 2e700ec..d96db98 100644
> > --- a/include/linux/platform_device.h
> > +++ b/include/linux/platform_device.h
> > @@ -130,8 +130,15 @@ extern void platform_driver_unregister(struct platform_driver *);
> >  extern int platform_driver_probe(struct platform_driver *driver,
> >  		int (*probe)(struct platform_device *));
> >  
> > -#define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
> > -#define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
> > +static inline void *platform_get_drvdata(const struct platform_device *pdev)
> > +{
> > +	return dev_get_drvdata(&pdev->dev);
> > +}
> > +
> > +static inline void platform_set_drvdata(struct platform_device *pdev, void *data)
> > +{
> > +	dev_set_drvdata(&pdev->dev, data);
> > +}
> Another improvement would be to make dev_set_drvdata and
> platform_set_drvdata return an int (as dev_set_drvdata can fail) (and
> then maybe mark it __must_check).

But dev_set_drvdata() does not return anything, so you would also have
to change that function first.

thanks,

greg k-h
