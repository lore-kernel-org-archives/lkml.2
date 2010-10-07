Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0JGWQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:16:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42628 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0JGWQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:16:12 -0400
From: "Menon, Nishanth" <nm@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
Date: Thu, 7 Oct 2010 17:15:15 -0500
Subject: RE: [PATCH] power: introduce library for device-specific OPPs
Thread-Topic: [PATCH] power: introduce library for device-specific OPPs
Thread-Index: ActmbOYuHIud0RMETf+C30+KiTkYigAABdWw
Message-ID: <7A436F7769CA33409C6B44B358BFFF0C014F748B1A@dlee02.ent.ti.com>
References: <1286357180-21565-1-git-send-email-nm@ti.com>
	<201010072354.57011.rjw@sisk.pl>
	<7A436F7769CA33409C6B44B358BFFF0C014F748B07@dlee02.ent.ti.com>
 <87fwwh7isu.fsf@deeprootsystems.com>
In-Reply-To: <87fwwh7isu.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
> Sent: Thursday, October 07, 2010 5:14 PM
> To: Menon, Nishanth
> Cc: Rafael J. Wysocki; linux-pm; lkml; l-o; l-a; Paul
> Subject: Re: [PATCH] power: introduce library for device-specific OPPs
> 
[...]
> >> > +static int opp_set_availability(struct device *dev, unsigned long
> freq,
> >> > +		bool availability_req)
> >> > +{
> >> > +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
> >> > +	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
> >> > +	int r = 0;
> >> > +
> >> > +	/* keep the node allocated */
> >> > +	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
> >> > +	if (!new_opp) {
> >> > +		pr_warning("Unable to allocate opp\n");
> >>
> >> Please add an identification string to the messages, something like
> >> "OPP: Unable to allocat object\n" (and similarly in the other messages).
> >> That would help to find the source of a message in case there's any
> >> problem.
> >
> > pr_fmt has been reformatted for this. The actual message which will
> appear
> > is as follows:
> > opp_set_availability: Unable to allocate opp
> >
> > is'nt that good enough considering that all functions are opp_ prefixed?
> > I can modify pr_fmt to add "OPP:" but I kinda think it is redundant. But
> I
> > have no strong opinions on that and look forward to your recommendations.
> 
> Even more informative would be to use dev_warn() and include the func.
> That way we'll even know which device has the problem.
Ack. Thanks. Yeah, this is better.. will do the change.

Regards,
Nishanth Menon
