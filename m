Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1HITTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:19:44 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:34678 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1HITTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:19:43 -0400
Date: Tue, 9 Aug 2011 15:19:15 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110809191915.GB28746@flamenco.cs.columbia.edu>
References: <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110805174728.GA1741@flamenco.cs.columbia.edu>
 <4E3F97EA.2020600@ge.com>
 <20110808091432.GA19570@flamenco.cs.columbia.edu>
 <4E3FABDA.8080204@ge.com>
 <20110808101140.GA21300@flamenco.cs.columbia.edu>
 <4E3FC33D.2080202@ge.com>
 <20110808172216.GA2311@flamenco.cs.columbia.edu>
 <4E40F719.1020100@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E40F719.1020100@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 10:00:09 +0100, Martyn Welch wrote:
> So, out of the 3 bus types you have used to demonstrate that refcounts should
> always be handled explicitly, 2 of the 3 (at least to me) appear to implicitly
> handling refcounting.
(snip)
> It appears to me that both PCI and RapidIO (both buses that you have tried to
> use to defend your position) don't seem to me to by-and-large expect drivers
> to explicitly manage refcounting.

Well if that's the impression you get, perhaps you need to
actually read the code:

In drivers/rapidio/rio-driver.c:

/**
 * rio_dev_get - Increments the reference count of the RIO device structure
 *
 * @rdev: RIO device being referenced
 *
 * Each live reference to a device should be refcounted.
 *
 * Drivers for RIO devices should normally record such references in
 * their probe() methods, when they bind to a device, and release
 * them by calling rio_dev_put(), in their disconnect() methods.
 */
struct rio_dev *rio_dev_get(struct rio_dev *rdev)
{
        if (rdev)
                get_device(&rdev->dev);

        return rdev;
}

You can find a similar function (with almost the very same description)
for usb and pci.

> That leaves USB, which I'd argue is a very different bus to VME.

>From the device model's viewpoint, VME is not special in any way,
something you don't seem to understand.

> > I'm tired of your non-arguments. I'm just trying to persuade you
> > to do what everyone else is doing, with technical reasons. To me
> > (and to everybody else in this list, I'd imagine) refcounting
> > should be explicit. You're going against what I perceive are
> > well-established pratices in the kernel. I can't understand it.
> 
> Which I have yet to see you convincingly backup. I see a
> large amount of bluff about oppses and how buses apparently
> deal with refcounting.  I also know I have had a number of
> commits to the VME code by a number of others (which is a
> matter of public record, you can look at the commits in git)
> that haven't complained about how the bus code is structured.

You're in denial. Manohar's patch fixes a very obvious bug,
which is fixed in the same way other buses deal with this.

> I also know I have had a number of commits to the VME code
> by a number of others (which is a matter of public record,
> you can look at the commits in git) that haven't complained
> about how the bus code is structured.

The fact that other people didn't notice this bug is irrelevant.

> You have proposed a completely different structure. Manohar has proposed some
> changes and I am trying to work with him to find a solution that satisfies
> both of us.

??? I just want you to ack Manohar's patch.

		Emilio

