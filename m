Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab2EKPuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:50:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40591 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2EKPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:49:59 -0400
Date: Fri, 11 May 2012 08:49:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
Message-ID: <20120511154951.GA6542@core.coreip.homeip.net>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
 <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
 <4FACB9D7.5090100@ti.com>
 <20120511072049.GA9088@core.coreip.homeip.net>
 <4FAD1C38.5050907@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD1C38.5050907@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 10:03:36AM -0400, Paul Gortmaker wrote:
> On 12-05-11 03:20 AM, Dmitry Torokhov wrote:
> > On Fri, May 11, 2012 at 10:03:51AM +0300, Peter Ujfalusi wrote:
> >> Hi,
> >>
> >> On 05/11/2012 01:49 AM, Paul Gortmaker wrote:
> >>> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >>>> Fixes build error due to missing of_property_read_u32.
> >>>
> >>> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> >>> this missing header, it needs to have a Kconfig dependency that limits
> >>> it to just being enabled on the platforms where it physically is possible to
> >>> have the hardware.  I'm guessing limiting to ARM would be a good start?
> >>
> >> Yes it is only usable on ARM, most specifically on OMAP4+ platforms.
> >> If I make the twl6040 MFD core to depend on ARM (or even on OMAP) this
> >> won't happen again.
> > 
> > Is there any other errors beside missing include of.h (and extra
> > of_device.h?). The driver seems to be compiling fine on x86_64 so no
> > need to limit to ARM only...
> 
> Hi Dmitry,
> 
> It should be limited to the platforms where the hardware is available,
> so that coverage builds aren't needlessly spending cycles building
> stuff that can't possibly ever be used.  Also if it is limited to
> ARM, then we can't have an ARM bug like this one mask the x86_64
> allyesconfig build from uncovering possible errors that we really
> care about seeing.

Hi Paul,

I strongly disagree. The bug that we are talking about was not an
arch-specific bug; it eventually would have shown up on ARM with a
randconfig as well. So it is a _good_ thing that the build was not
limited just to ARM so that the bug got noticed early and fixed after
being present in -next for about a day.

So please do not add any additional constraints; better compile coverage
is a good thing.

Thanks.

-- 
Dmitry
