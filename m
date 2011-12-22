Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1LVSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:11:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1LVSL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:11:28 -0500
Date: Thu, 22 Dec 2011 10:10:52 -0800
From: Greg KH <gregkh@suse.de>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        Magnus Damm <damm@opensource.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Driver core support for early platform devices
Message-ID: <20111222181052.GA30259@suse.de>
References: <0282FD61-7E73-45CE-8EC8-32BF411C7619@boeing.com>
 <20111222174521.GA29144@suse.de>
 <99F3E881-FB9E-4D49-9A91-793FDD04795D@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99F3E881-FB9E-4D49-9A91-793FDD04795D@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:55:56AM -0600, Moffett, Kyle D wrote:
> On Dec 22, 2011, at 12:45, Greg KH wrote:
> > On Thu, Dec 22, 2011 at 11:15:06AM -0600, Moffett, Kyle D wrote:
> >> Hi,
> >> 
> >> I'm tinkering with some improvements to the way that OpenPIC/MPIC are
> >> detected and loaded on PowerPC platforms, and it seems like I am trying
> >> to use the driver model before it is fully initialized.
> >> 
> >> In particular, it seems like it should be possible to simply declare an
> >> OpenPIC in the device-tree and have it automatically bound to a platform
> >> driver declaring the right OpenFirmware match strings.
> >> 
> >> Unfortunately, it needs to be bound by init_IRQ() time, while the driver
> >> model does not get initialized until much later (after the scheduler is
> >> up and running).
> >> 
> >> As far as I can tell, there seem to be 2 possible approaches to making
> >> that possible:
> >> 
> >> (1) Split the driver-model initialization into "early" and "late" phases
> >>    so that drivers can be registered and devices probed very early on
> >>    and then replay the necessary scheduler-dependent things after the
> >>    system is mostly started up (IE: devtmpfs, etc).
> > 
> > We already have that today with the "early_platform*" functions, right?
> > Will those work for you, or do you need this for a bus you are creating
> > and not using the platform bus?
> 
> Well, I can't figure out how "early_platform" is actually supposed to
> integrate with the platform bus itself.  It seems designed mostly for
> drivers like "earlyprintk" et. al. for which loading is controlled by
> a kernel parameter.
> 
> Specifically, I don't see any "early_platform" logic to match devices in
> the OF device-tree based on the driver "of_match" parameters, just based
> on text strings in early_param().
> 
> Furthermore, if I register an "early_platform" device, it seems to get
> unregistered when the normal driver model is brought up, instead of
> being sucked in and promoted to a normal platform_device.  That code is
> pretty poorly documented and only used in a couple places right now,
> though, so it's possible I am misreading it.

I think Magnus wrote this code, as he was having the same issues you
were, so he should be able to answer these questions better than I, as I
do not know this code at all, sorry.

greg k-h
