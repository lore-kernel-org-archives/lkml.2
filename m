Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1FXSfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 14:35:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37782 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1FXSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 14:35:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 24 Jun 2011 20:34:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a
 per-driver version - Was: Re: [PATCH 03/37] Remove unneeded version.h
 includes from include/
Message-ID: <20110624203404.7a3f6f6a@stein>
In-Reply-To: <4E04A122.2080002@infradead.org>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<4E04912A.4090305@infradead.org>
	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>
	<201106241554.10751.hverkuil@xs4all.nl>
	<4E04A122.2080002@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24 Mauro Carvalho Chehab wrote:
> Em 24-06-2011 10:54, Hans Verkuil escreveu:
> > On Friday, June 24, 2011 15:45:59 Devin Heitmueller wrote:
> >> The versions are increased at the discretion of the driver maintainer,
> >> usually when there is some userland visible change in driver behavior.
> >>  I assure you the application developers don't *want* to rely on such
> >> a mechanism, but there have definitely been cases in the past where
> >> there was no easy way to detect the behavior of the driver from
> >> userland.
> >>
> >> It lets application developers work around things like violations of
> >> the V4L2 standard which get fixed in newer revisions of the driver.
> >> It provides them the ability to put a hack in their code that says "if
> >> (version < X) then this driver feature is broken and I shouldn't use
> >> it."
> > 
> > Indeed. Ideally we shouldn't need it. But reality is different.
> >
> > What we have right now works and I see no compelling reason to change the
> > behavior.
> 
> A per-driver version only works if the user is running a vanilla kernel without 
> any stable patches applied. 
> 
> I doubt that this covers the large amount of the users: they'll either use an 
> stable patched kernel or a distribution-specific one. On both cases, the driver
> version is not associated with a bug fix, as the driver maintainers just take
> care of increasing the driver version once per each new kernel version (when
> they care enough).
> 
> Also, a git blame for the V4L2 drivers shows that only a few drivers have their
> version increased as changes are applied there. So, relying on cap->version 
> has a minimal chance of working only with a few drivers, with vanilla *.0 kernels.

If the "driver version" is in fact an ABI version, then the driver author
should really increase it only when ABI behavior is changed (and only if
the behavior change can only be communicated by version number --- e.g.
addition of an ioctl is not among such reasons).  And the author should
commit behavior changing implementation and version number change in a
single changeset.

And anybody who backmerges such an ABI behavior change into another kernel
branch (stable, longterm, distro...) must backmerge the associated version
number change too.

Of course sometimes people realize this only after the fact.  Or driver
authors don't have a clear understanding of ABI versioning to begin with.
I am saying so because I had to learn it too; I certainly wasn't born
with an instinct knowledge how to do it properly.

(Disclaimer:  I have no stake in drivers/media/ ABIs.  But I am involved
in maintaining a userspace ABI elsewhere in drivers/firewire/, and one of
the userspace libraries that use this ABI.)
-- 
Stefan Richter
-=====-==-== -==- ==---
http://arcgraph.de/sr/
