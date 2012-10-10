Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2JJXIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:08:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41324 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab2JJXI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:08:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PM / QoS: Prepare device structure for adding more constraint types
Date: Thu, 11 Oct 2012 01:12:04 +0200
Message-ID: <1768451.HPQmsTHsyu@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121010031547.GA21067@MGROSS-X220VM>
References: <201209282351.10663.rjw@sisk.pl> <5823653.QdHL6Lda2x@vostro.rjw.lan> <20121010031547.GA21067@MGROSS-X220VM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 of October 2012 20:15:47 mark gross wrote:
> On Mon, Oct 08, 2012 at 10:04:03AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Currently struct dev_pm_info contains only one PM QoS constraints
> > pointer reserved for latency requirements.  Since one more device
> > constraints type (i.e. flags) will be necessary, introduce a new
> > structure, struct dev_pm_qos, that eventually will contain all of
> > the available device PM QoS constraints and replace the "constraints"
> > pointer in struct dev_pm_info with a pointer to the new structure
> > called "qos".
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Jean Pihet <j-pihet@ti.com>
> > ---
> >  drivers/base/power/qos.c |   42 ++++++++++++++++++++++--------------------
> >  include/linux/pm.h       |    2 +-
> >  include/linux/pm_qos.h   |    4 ++++
> >  3 files changed, 27 insertions(+), 21 deletions(-)
> > 
> > Index: linux/include/linux/pm.h
> > ===================================================================
> > --- linux.orig/include/linux/pm.h
> > +++ linux/include/linux/pm.h
> > @@ -551,7 +551,7 @@ struct dev_pm_info {
> >  	struct dev_pm_qos_request *pq_req;
> >  #endif
> >  	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
> > -	struct pm_qos_constraints *constraints;
> > +	struct dev_pm_qos	*qos;
> >  };
> >  
> >  extern void update_pm_runtime_accounting(struct device *dev);
> > Index: linux/include/linux/pm_qos.h
> > ===================================================================
> > --- linux.orig/include/linux/pm_qos.h
> > +++ linux/include/linux/pm_qos.h
> > @@ -57,6 +57,10 @@ struct pm_qos_constraints {
> >  	struct blocking_notifier_head *notifiers;
> >  };
> >  
> > +struct dev_pm_qos {
> > +	struct pm_qos_constraints latency;
> What about non-latency constraints?  This pretty much makes it explicit
> that dev_pm_qos is all about latency.  from the commit comment I thought
> you where trying to make it more genaric.  Why not call "latency"
> "constraint" or something less specific?

Please see the next patches in the series that add one more constraint type.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
