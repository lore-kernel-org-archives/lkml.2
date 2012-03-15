Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab2COU4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161434Ab2COU4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:56:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [Replacement][PATCH 2/6] PM / Domains: Fix hibernation restore of devices, v2
Date: Thu, 15 Mar 2012 22:00:09 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl> <201203132232.42915.rjw@sisk.pl> <20120315093921.GA15294@verge.net.au>
In-Reply-To: <20120315093921.GA15294@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203152200.09546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Simon Horman wrote:
> On Tue, Mar 13, 2012 at 10:32:42PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, March 13, 2012, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > During resume from hibernation pm_genpd_restore_noirq() has to
> > > deal with software state left by pm_genpd_suspend_noirq() and
> > > unknown hardware state (the boot kernel may leave all PM domains and
> > > devices in arbitrary states).  For this reason, make it attempt to
> > > power cycle each domain when before resuming its first device to
> > > possibly get rid of any unwanted hardware state that may interfere
> > > with genpd_start_dev() later on.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > I realized that this wasn't a good idea because of patch [3/6] (we
> > can't power cycle domains containing "always on" devices), so I
> > decided to only fix the really broken things in pm_genpd_restore_noirq().
> > 
> > Of course, patch [3/6] also needs to be updated on top of the below to
> > avoid starting "always on" devices in pm_genpd_restore_noirq() (it has
> > to assume that they will be "always on" in the boot kernel too, but that
> > seems to be a reasonable expectation).
> > 
> > Please note that those changes only affect resume from hibernation, so
> > they don't invalidate the testing that has already been carried out.
> 
> Hi Rafael,
> 
> sorry for such a naeive question, but if I was to test
> hibernate on the Mackerel how would I achieve resume?
> Is there a button I should press?

Hibernation is not supported on Mackerel at the moment, so you'd need to add
some platform hooks first.  Then, you'd need some persistent storage with
a swap patrition (or swap file at least) to save the image.  You'd need
to point your kernel to the image storage using the resume= and resume_offset=
command line switches.  Then, you should be able to create an image and the
kernel would look for it automatically on the next boot.

Still, I'm not sure if doing all that at this point is worth the effort.

Thanks,
Rafael
