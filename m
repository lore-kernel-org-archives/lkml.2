Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab0DAUZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916Ab0DAUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:25:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Thu, 1 Apr 2010 22:28:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       Dave Airlie <airlied@gmail.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <4BB43EE6.5040003@ladisch.de> <t2ha728f9f91004010801tb1370b86t190fd31e146aa87e@mail.gmail.com>
In-Reply-To: <t2ha728f9f91004010801tb1370b86t190fd31e146aa87e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012228.06938.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Alex Deucher wrote:
> On Thu, Apr 1, 2010 at 2:36 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > Alex Deucher wrote:
> >> On Wed, Mar 31, 2010 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> On Tuesday 30 March 2010, Rafael J. Wysocki wrote:
> >>>> >       PCI quirk: RS780/RS880: work around missing MSI initialization
> >>>>
> >>>> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
> >>>> which happens to have a RS780.
> >
> > So it's better to disable MSI unconditionally.
> >
> > Rafael, can you check if MSI works for the HDMI audio device?
> > (I'd guess it doesn't.)
> >
> >> I also have the attached patch queued in via Dave's tree to disable
> >> MSI on all IGP chips for the time being.
> >
> > This disables MSI only for the graphics device.  I'd prefer to have
> > the quirk on its bridge so that MSI gets disabled for the HDMI audio
> > device too, to avoid having to duplicate this quirk in the snd-hda-intel
> > driver.
> >
> > ==========
> >
> > PCI quirk: RS780/RS880: disable MSI completely
> >
> > The missing initialization of the nb_cntl.strap_msi_enable does not seem
> > to be the only problem that prevents MSI, so that quirk is not
> > sufficient to enable MSI on all machines.  To be safe, unconditionally
> > disable MSI for the internal graphics and HDMI audio on these chipsets.
> >
> > Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> Works fine here.
> 
> Tested-by: Alex Deucher <alexdeucher@gmail.com>

Unfortunately it doesn't work for me without the

if ((rdev->family >= CHIP_RV380) &&
            (!(rdev->flags & RADEON_IS_IGP)))

radeon quirk.

Thanks,
Rafael
