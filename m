Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0HZXsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:48:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab0HZXsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:48:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Fri, 27 Aug 2010 01:46:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008242239.43249.rjw@sisk.pl> <201008270109.36687.rjw@sisk.pl>
In-Reply-To: <201008270109.36687.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008270146.23855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 27, 2010, Rafael J. Wysocki wrote:
> On Tuesday, August 24, 2010, Rafael J. Wysocki wrote:
> > On Tuesday, August 24, 2010, Tejun Heo wrote:
> > > On 08/23/2010 08:58 PM, Rafael J. Wysocki wrote:
> > > > On Monday, August 23, 2010, Tejun Heo wrote:
> > > >> Hello, sorry about the delay.
> > > >>
> > > >> On 08/19/2010 06:23 PM, Stephan Diestelhorst wrote:
> > > >>> It says "max_performance", I have not touched anyhting. So it has been
> > > >>> like that all the time. Would this explain why your patch did not show
> > > >>> the debug printout?
> > > >>
> > > >> Hmm... okay.  Yeah, if you haven't been using IPM at all, there won't
> > > >> be any debug messages but at the same time the posted patch should
> > > >> have had the same effect as Rafael's patch as IPM path isn't traveled
> > > >> at all.  Can you please check the followings?
> > > >>
> > > >> * You're actually running the correct patched kernel and modules.  It
> > > >>   probably is a good idea to add a printk message.  ie. Apply the
> > > >>   patch and add a printk() in ata_host_request_pm() in libata-core.c
> > > >>   and make sure the debug messages appears.
> > > >>
> > > >> * Rafael's patch actually fixes the problem.  If you haven't been
> > > >>   using IPM at all, Rafael's patch and mine should behave exactly the
> > > >>   same (ie. no IPM operation at all during suspend/resume).  It could
> > > >>   be that you're seeing a different issue.
> > > >>
> > > >> Rafael, can you please test my patch and see how your case behaves?
> > > > 
> > > > This one: http://lkml.org/lkml/2010/8/5/328 ?
> > > 
> > > Yeap, that one.  I can prep a test git branch if necessary.
> > 
> > No need to, but it's going to take a few days to verify on my box.
> 
> Well, no luck.  I was able to reproduce the issue on my box with this patch
> applied on top of 2.6.32-rc2.

2.6.36-rc2 that is.

> Which probably means that the link power management is not really involved
> here and seems to turn up this statement:
> 
> rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
> 
> in ata_host_suspend() as the culprit.
> 
> Does it make sense?

Thanks,
Rafael
