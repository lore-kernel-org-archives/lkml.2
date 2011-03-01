Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1CAJF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:05:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47908 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1CAJF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:05:26 -0500
Date: Tue, 1 Mar 2011 10:05:18 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] device.h: add device_set_platdata routine
Message-ID: <20110301090518.GV22310@pengutronix.de>
References: <5c561db378360ad1763da41f8350c7be816daa06.1298953633.git.viresh.kumar@st.com>
 <20110301075953.GR22310@pengutronix.de>
 <4D6CADE5.6000206@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D6CADE5.6000206@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> > On Tue, Mar 01, 2011 at 10:03:20AM +0530, Viresh Kumar wrote:
> >> device.h supports device_get_platdata but doesn't support device_set_platdata.
> >> This routine is required by platforms in which device structure is declared
> >> in a machine specific file and platform data comes from board specific file.
> >>
> >> This will be used by SPEAr patches sent in separate patch series.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> >> ---
> >>  include/linux/device.h |    5 +++++
> >>  1 files changed, 5 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/device.h b/include/linux/device.h
> >> index 1bf5cf0..6ce0f20 100644
> >> --- a/include/linux/device.h
> >> +++ b/include/linux/device.h
> >> @@ -576,6 +576,11 @@ static inline void *dev_get_platdata(const struct device *dev)
> >>  	return dev->platform_data;
> >>  }
> >>  
> >> +static inline void dev_set_platdata(struct device *dev, void *platdata)
> >> +{
> >> +	dev->platform_data = platdata;
> >> +}
> >> +
> > Note that dev->platform_data was designed to hold dynamically allocated
> > memory, at least it's kfreed in platform_device_release.  And note there
> > is platform_device_add_data that kmemdups its argument into
> > pdev->dev.platform_data.
> > 
> 
> Ok. So we should use platform_device_add_data instead and mark our platform
> data's struct as __init. So that it doesn't consume any memory after
> this routine is done??
Yeah, either __initdata or still better const + __initconst if possible.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
