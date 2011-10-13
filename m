Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab1JMEJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:09:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56133 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1JMEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:09:28 -0400
Date: Wed, 12 Oct 2011 22:09:23 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Andrei Warkentin <awarkentin@vmware.com>, Greg KH <greg@kroah.com>,
        Dilan Lee <dilee@nvidia.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111013040923.GE15829@ponder.secretlab.ca>
References: <20111008155502.GB616@kroah.com>
 <361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
 <CACVXFVMnt-ChUDhawhoyMm-wJ8xSQAWs1c8ykzmyshfX49HEsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMnt-ChUDhawhoyMm-wJ8xSQAWs1c8ykzmyshfX49HEsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:29:18PM +0800, Ming Lei wrote:
> On Tue, Oct 11, 2011 at 1:37 AM, Andrei Warkentin <awarkentin@vmware.com> wrote:
> > Hi,
> >
> > ----- Original Message -----
> >> From: "Greg KH" <greg@kroah.com>
> >> To: "Josh Triplett" <josh@joshtriplett.org>
> >> Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-arm-kernel@lists.infradead.org, "Grant Likely"
> >> <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
> >> "Dilan Lee" <dilee@nvidia.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
> >> Sent: Saturday, October 8, 2011 11:55:02 AM
> >> Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
> >>
> >
> > I'm a bit of a fly on the wall here, but I'm curious how this impacts suspend/resume.
> > device_initialize->device_pm_init are called from device_register, so certainly this
> > patch doesn't also ensure that the PM ordering matches probe ordering, which is bound
> > to break suspend, right? Was this ever tested with the OMAP target? Shouldn't the
> 
> Inside device_add(), device_pm_add is called before bus_probe_device,
> so the patch can't change the device order in pm list, and just change
> the driver probe order.

That's the way it works now, but can it be reworked?  It would be
possible to adjust the list order after successful probe.  However,
I'm not clear on the ordering rules for the dpm_list.  Right now it is
explicitly ordered to have parents before children, but as already
expressed, that doesn't accurately represent ordering constraints for
multiple device dependancies.

So, reordering the list would probably require maintaining the
existing parent-child ordering constraint, but to also shift
devices (and any possible children?) to be after drivers that are
already probed.  That alone will be difficult to implement and get
right, but maybe the constraints can be simplified.  It needs some
further thought.

g.

