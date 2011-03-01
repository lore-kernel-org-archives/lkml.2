Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1CAPeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:34:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:52994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1CAPeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:34:12 -0500
Date: Tue, 1 Mar 2011 10:34:38 -0500
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Viresh Kumar <viresh.kumar@st.com>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, vipin.kumar@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] device.h: add device_set_platdata routine
Message-ID: <20110301153438.GB15633@suse.de>
References: <5c561db378360ad1763da41f8350c7be816daa06.1298953633.git.viresh.kumar@st.com>
 <20110301075953.GR22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110301075953.GR22310@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:59:53AM +0100, Uwe Kleine-König wrote:
> [added gregkh and lkml to Cc:]
> 
> Hi Viresh,
> 
> On Tue, Mar 01, 2011 at 10:03:20AM +0530, Viresh Kumar wrote:
> > device.h supports device_get_platdata but doesn't support device_set_platdata.
> > This routine is required by platforms in which device structure is declared
> > in a machine specific file and platform data comes from board specific file.
> > 
> > This will be used by SPEAr patches sent in separate patch series.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > ---
> >  include/linux/device.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 1bf5cf0..6ce0f20 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -576,6 +576,11 @@ static inline void *dev_get_platdata(const struct device *dev)
> >  	return dev->platform_data;
> >  }
> >  
> > +static inline void dev_set_platdata(struct device *dev, void *platdata)
> > +{
> > +	dev->platform_data = platdata;
> > +}
> > +
> Note that dev->platform_data was designed to hold dynamically allocated
> memory, at least it's kfreed in platform_device_release.  And note there
> is platform_device_add_data that kmemdups its argument into
> pdev->dev.platform_data.
> 
> Compared to your dev_set_platdata platform_device_add_data only works
> for platform_devices, don't know if it's worth to change that.
> 
> And regarding platform_device_add_data I wonder if it wouldn't be more
> consistent to set platform_data = NULL if (!data)?  Greg?

Maybe, care to send a patch?

thanks,

greg k-h
