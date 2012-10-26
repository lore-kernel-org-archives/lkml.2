Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab2JZRVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:21:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20533 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758221Ab2JZRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:21:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/K6wJAGpatOJ5k6GCUEaAD
Date: Fri, 26 Oct 2012 10:21:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: balbi@ti.com, Kishon Vijay Abraham I <kishon@ti.com>,
        linux@arm.linux.org.uk, b-cousson@ti.com, olof@lixom.net,
        rdunlap@xenotime.net, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: OMAP: ocp2scp: create omap device for
 ocp2scp
Message-ID: <20121026172140.GJ11908@atomide.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-4-git-send-email-kishon@ti.com>
 <20121026065012.GC22206@arwen.pp.htv.fi>
 <201210260747.11848.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210260747.11848.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [121026 00:48]:
> On Friday 26 October 2012, Felipe Balbi wrote:
> > > +static void omap_init_ocp2scp(void)
> > > +{
> > > +     struct omap_hwmod       *oh;
> > > +     struct platform_device  *pdev;
> > > +     int                     bus_id = -1, dev_cnt = 0, i;
> > > +     struct omap_ocp2scp_dev *ocp2scp_dev;
> > > +     const char              *oh_name, *name;
> > > +     struct omap_ocp2scp_platform_data *pdata;
> > > +
> > > +     oh_name = "ocp2scp_usb_phy";
> > > +     name    = "omap-ocp2scp";
> > 
> > how about adding checks here to return early case we're not running on
> > OMAP4 or OMAP5 ??
> > 
> 
> I suppose even OMAP4-only, since OMAP5 always has DT enabled.

Hmm yes, currently omap_hwmod_lookup(oh_name) produces
bogus errors for other omaps as the hwmod data is only
there for omap4.

Regards,

Tony
