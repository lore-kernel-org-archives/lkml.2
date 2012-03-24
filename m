Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2CXR0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 13:26:11 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:63669 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2CXR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 13:26:09 -0400
Date: Sat, 24 Mar 2012 18:26:05 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: radeon + DVI->mDP converter + mDP display blank screen issue
 since 3.0
Message-ID: <20120324172605.GO28523@wantstofly.org>
References: <20120322124919.GG28523@wantstofly.org>
 <CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
 <20120323154446.GK28523@wantstofly.org>
 <CADnq5_NAOOsp6-NrnNc3cSTGM=yNXk8yddBPSxFawuONeAu-_Q@mail.gmail.com>
 <CADnq5_Mf4aMYcX07UfNVMDerna0rKeEVwT0mhNLerpUC58K2Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_Mf4aMYcX07UfNVMDerna0rKeEVwT0mhNLerpUC58K2Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 03:42:44PM -0400, Alex Deucher wrote:

> >>> > Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
> >>> > to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DVI
> >>> > to Mini DisplayPort converter has started to stop giving screen
> >>> > output on switching from text mode to graphical framebuffer during
> >>> > system startup.
> >>> >
> >>> > I finally had some time to look at this, and it seems to have stopped
> >>> > working after this commit:
> >>> >
> >>> >        commit df271bec805b42527d864777ed035fcbb42e76c0
> >>> >        Author: Alex Deucher <alexdeucher@gmail.com>
> >>> >        Date:   Fri May 20 04:34:15 2011 -0400
> >>> >
> >>> >            drm/radeon/kms: properly handle bpc >8 in atom command tables
> >>> >
> >>> >            Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> >>> >            Signed-off-by: Dave Airlie <airlied@redhat.com>
> >>> >
> >>> > ...and with the patch below (i.e. reverting part of the commit above)
> >>> > applied to 3.3 I get screen output again.
> >>> >
> >>> > Even though the monitor seems to have an 8 bit panel, it reports 10
> >>> > bits per channel in its EDID:
> >>> >
> >>> >        [...]
> >>> >        Manufacturer: APP Model 9226 Serial Number 41959462
> >>> >        Made week 38 of 2010
> >>> >        EDID version: 1.4
> >>> >        Digital display
> >>> >        10 bits per primary color channel
> >>> >        DisplayPort interface
> >>> >        Maximum image size: 60 cm x 34 cm
> >>> >        [...]
> >>> >
> >>> > The (active, dual link) DVI->mDP converter spec sheet says it supports
> >>> > 24 bit color, and I'm guessing that it can't deal with 30.  Is the
> >>> > converter at fault here for passing through the EDID unchanged?
> >>> >
> >>> > Also, what would be the right way to handle this, a kernel command
> >>> > line or module option to limit color depth or something like that?
> >>> > ("Buy a video card with DP output." is a valid answer, I suppose.)
> >>> >
> >>> > I have no clue at all about graphics, and I have no idea whatsoever
> >>> > what I'm doing here, but I just wanted to post this somewhere for
> >>> > Google to find in case someone else runs into this!
> >>>
> >>> I've inquired with out display team on how to best handle this.  In
> >>> the meantime, it's probably best to just default to 8 bpc.  Does the
> >>> attached patch fix your issue?
> >>
> >> I've been using the patch below in a custom Fedora 17 kernel RPM, and
> >> that seems to fix the issue.  Your patch seems to be a superset of
> >> this patch, so logically, your patch should do the trick as well. :)
> >
> > Can you try the attached patch on top of my previous one?
> 
> Scratch that.  Try this one instead.

The 3.3 + 0001-drm-radeon-kms-atom-force-bpc-to-8-for-now.patch +
0001-drm-radeon-kms-improve-bpc-handling-v2.patch combo seems to work
fine -- I get display output as expected.

Tested-by: Lennert Buytenhek <buytenh@wantstofly.org>


thanks,
Lennert
