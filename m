Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1LOD0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:26:52 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39123 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932221Ab1LOD0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:26:49 -0500
X-Sasl-enc: DKMdTsNjoa8xqhTAp4ZbXv2mQUmeHdutW3jf5ZpZWdnA 1323919608
Date: Wed, 14 Dec 2011 19:09:19 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
Message-ID: <20111215030919.GA7713@kroah.com>
References: <1323309517.979.8.camel@mop>
 <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop>
 <20111209223454.GA24987@kroah.com>
 <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com>
 <20111214012141.GA18215@kroah.com>
 <CAPXgP10ZVjy00H3g1YbGJz+e0=mP9hXfdeDT8pOLrDE-e5E5_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP10ZVjy00H3g1YbGJz+e0=mP9hXfdeDT8pOLrDE-e5E5_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 03:11:34AM +0100, Kay Sievers wrote:
> On Wed, Dec 14, 2011 at 02:21, Greg KH <greg@kroah.com> wrote:
> > On Wed, Dec 14, 2011 at 01:50:57AM +0100, Kay Sievers wrote:
> >> On Fri, Dec 9, 2011 at 23:34, Greg KH <greg@kroah.com> wrote:
> >> > On Fri, Dec 09, 2011 at 04:25:21PM +0100, Kay Sievers wrote:
> >> >> Greg, would be nice, if you can take a quick look a the driver core (not
> >> >> the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
> >> >> they look sane to you. I'll then split the driver core stuff out, so we
> >> >> can merge that before we port the individual drivers over.
> >> >
> >> > Yes, it looks sane to me, thanks again for doing this work.
> >>
> >> Split-up patches are here:
> >>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=tree
> >>
> >> That's the size of it:
> >>   60 files changed, 1170 insertions(+), 1421 deletions(-)
> >
> > Very nice.
> >
> >> The current state and the list of the remaining non-x86 files is here:
> >>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=README;hb=HEAD
> >>
> >> We need a plan now. :)
> >
> > If I take those patches, none of those other ones will break their
> > build, right?
> 
> The first patch should not break anything, the non-core things shouldn't too.

I've taken the "non-core" ones now as well.

> > Or will the cpu ones?
> 
> The cpu patch as it is will break power, s390, sh and tile.
>   $ git grep -w -l cpu_sysdev_class
>   arch/powerpc/kernel/sysfs.c
>   arch/powerpc/platforms/pseries/pseries_energy.c
>   arch/s390/kernel/smp.c
>   arch/sh/kernel/cpu/sh4/sq.c
>   arch/tile/kernel/sysfs.c
> 
> If all should be bisectable, we would need to merge these changes into
> the cpu patch.
> 
> The other two core patches, node and memory, could need arch fixes
> too, but a quick grep did not reveal anything.

I'll look at these tomorrow.

thanks,

greg k-h
