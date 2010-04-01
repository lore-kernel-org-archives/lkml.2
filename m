Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0DAXVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:21:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758983Ab0DAXUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:20:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Fri, 2 Apr 2010 01:23:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org> <20100401154847.20e9c8b8@jbarnes-piketon>
In-Reply-To: <20100401154847.20e9c8b8@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004020123.55974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 April 2010, Jesse Barnes wrote:
> On Thu, 1 Apr 2010 09:29:23 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> > > 
> > > OK, I've verified that partial revert (below) is sufficient.
> > 
> > Hmm. Through the DRM merge I just did, this area actually conflicted, and 
> > the resolved version is now
> > 
> >         if ((rdev->family >= CHIP_RV380) &&
> >             (!(rdev->flags & RADEON_IS_IGP))) {
> > 
> > which presumably also fixes your issue?
> > 
> > [ Side note: somebody in the DRM tree seems to be way too used to LISP, 
> >   and thinks that adding parenthesis always improves the code ;-]
> > 
> > However, I do suspect that we should probably revert the quirk regardless 
> > as being useless (ie it probably was related to those IGP chips that 
> > apparently don't do MSI anyway).
> > 
> > So the patch that reverts the quirk by Clemens (to replace it with 
> > disabling MSI entirely when the AMD NB doesn't accept them) seems to be a 
> > good idea regardless, since it's apparently not just about gfx. Jesse?
> 
> Yeah, that sounds fine.  I can include it in my next pull req or you
> can just pick it up directly.

Not exactly that one, please, it's missing a quirk for the affected system.

I've just sent a corrected version, here:
https://patchwork.kernel.org/patch/90275/

Rafael
