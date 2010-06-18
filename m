Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0FRXYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:24:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0FRXYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:24:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase of hibernation
Date: Sat, 19 Jun 2010 01:23:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ondrej Zary <linux@rainbow-software.org>
References: <201006182221.57333.rjw@sisk.pl> <1276895296.6513.3.camel@t60prh>
In-Reply-To: <1276895296.6513.3.camel@t60prh>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006190123.00694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 18, 2010, Dave Airlie wrote:
> On Fri, 2010-06-18 at 22:21 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > I have recently noticed a 55 sec. delay during the "device freeze"
> > phase of hibernation on my test-bed HP nx6325.  Due to the 100%
> > reproducibility of it I was able to narrow it down to
> > radeon_suspend_kms() and then it turned out that the delay occured
> > somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
> > necessary or even very useful to me to evict VRAM at this particular
> > point, because we're going to create an image and bring the device
> > back to the fully functional state in a little while.  Thus, I think
> > the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
> > which makes the delay go away.
> 
> I'm not 100% sure of the hibernate sequencing and its early in the
> morning, but we want to evict VRAM before image building so we can have
> the contents of VRAM in the image so we can restore them on resume. Does
> this just avoid evicting them a second time after we created the image?

No, it's the first time, before creating the image, but I didn't seen any
difference on resume with and without the patch, so I thought it was a good
idea. :-)

If you don't like it, though, I guess it will be necessary to find the root
cause of the delay.

Rafael
