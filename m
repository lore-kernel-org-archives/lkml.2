Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141Ab2CPADi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:03:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52838 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2CPADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:03:33 -0400
Date: Fri, 16 Mar 2012 09:03:29 +0900
From: Simon Horman <horms@verge.net.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
Subject: Re: [Replacement][PATCH 2/6] PM / Domains: Fix hibernation restore
 of devices, v2
Message-ID: <20120316000328.GE18690@verge.net.au>
References: <201203130123.16268.rjw@sisk.pl>
 <201203132232.42915.rjw@sisk.pl>
 <20120315093921.GA15294@verge.net.au>
 <201203152200.09546.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203152200.09546.rjw@sisk.pl>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:00:09PM +0100, Rafael J. Wysocki wrote:
> On Thursday, March 15, 2012, Simon Horman wrote:
> > On Tue, Mar 13, 2012 at 10:32:42PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, March 13, 2012, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > During resume from hibernation pm_genpd_restore_noirq() has to
> > > > deal with software state left by pm_genpd_suspend_noirq() and
> > > > unknown hardware state (the boot kernel may leave all PM domains and
> > > > devices in arbitrary states).  For this reason, make it attempt to
> > > > power cycle each domain when before resuming its first device to
> > > > possibly get rid of any unwanted hardware state that may interfere
> > > > with genpd_start_dev() later on.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > I realized that this wasn't a good idea because of patch [3/6] (we
> > > can't power cycle domains containing "always on" devices), so I
> > > decided to only fix the really broken things in pm_genpd_restore_noirq().
> > > 
> > > Of course, patch [3/6] also needs to be updated on top of the below to
> > > avoid starting "always on" devices in pm_genpd_restore_noirq() (it has
> > > to assume that they will be "always on" in the boot kernel too, but that
> > > seems to be a reasonable expectation).
> > > 
> > > Please note that those changes only affect resume from hibernation, so
> > > they don't invalidate the testing that has already been carried out.
> > 
> > Hi Rafael,
> > 
> > sorry for such a naeive question, but if I was to test
> > hibernate on the Mackerel how would I achieve resume?
> > Is there a button I should press?
> 
> Hibernation is not supported on Mackerel at the moment, so you'd need to add
> some platform hooks first.  Then, you'd need some persistent storage with
> a swap patrition (or swap file at least) to save the image.  You'd need
> to point your kernel to the image storage using the resume= and resume_offset=
> command line switches.  Then, you should be able to create an image and the
> kernel would look for it automatically on the next boot.
> 
> Still, I'm not sure if doing all that at this point is worth the effort.

Point taken.
