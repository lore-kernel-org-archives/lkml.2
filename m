Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2JZAD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:03:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52425 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab2JZAD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:03:27 -0400
Date: Thu, 25 Oct 2012 19:03:21 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [for-next PATCH] PM / devfreq: Add sysfs node to expose
 available frequencies
Message-ID: <20121026000321.GA4190@kahuna>
References: <1351207963-30075-1-git-send-email-nm@ti.com>
 <1639482.oGax1ZB8vZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1639482.oGax1ZB8vZ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01:56-20121026, Rafael J. Wysocki wrote:
> On Thursday, October 25, 2012 06:32:43 PM Nishanth Menon wrote:
[..]
> > +static ssize_t show_available_freqs(struct device *d,
> > +				    struct device_attribute *attr,
> > +				    char *buf)
> > +{
> > +	struct devfreq *df = to_devfreq(d);
> > +	struct device *dev = df->dev.parent;
> > +	struct opp *opp;
> > +	ssize_t count = 0;
> > +	unsigned long freq = 0;
> > +
> > +	rcu_read_lock();
> > +	do {
> > +		opp = opp_find_freq_ceil(dev, &freq);
> > +		if (IS_ERR(opp))
> > +			break;
> > +
> > +		count += sprintf(&buf[count], "%lu ", freq);
> > +		freq++;
> > +	} while (1);
> > +	rcu_read_unlock();
> > +	count += sprintf(&buf[count], "\n");
> 
> Care to avoid printing the tailing space?
count -= count ? 1 : 0;
count += sprintf(&buf[count], "\n");
should take care of empty list and the trailing space. Sounds reasonable?

-- 
Regards,
Nishanth Menon
