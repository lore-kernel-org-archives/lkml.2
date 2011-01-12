Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1ALTqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:46:55 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48002 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755205Ab1ALTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:46:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XWdWDXGwx1qAz138F25qcMlXAmvWKbPojVwwUsu3UhNfgaIzsrtY6hClflqVlEw5/4q2AnrOivqAHOdmVrCQIatKrZmcThyH7Eu5jKww4x50lcUh3CcAr5n28nC7ZO79;
Date: Wed, 12 Jan 2011 11:46:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm intel only fixes
Message-ID: <20110112114649.5365d518@jbarnes-desktop>
In-Reply-To: <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
	<AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 11:22:58 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 11, 2011 at 10:03 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > I'm stuck at home with just my i5 laptop due to the office being shut due
> > to the ongoing floods. But I've booted and ran this for a few hours and it
> > seems to be better than the current tree. It contains a couple of patches
> > to fix DMAR interaction issues I see on this laptop on top of Chris's
> > pull.
> 
> Hmm. I'm not seeing the screensaver issue any more, but there's
> something wrong with video. At least the TED ones (I'm not seeing it
> on a youtube video i tried). See for example
> 
>   http://www.ted.com/talks/lang/eng/david_gallo_shows_underwater_astonishments.html
> 
> and when there is fast movement in the video (like when the octopus is
> spooked), I get these odd lines of noise.
> 
> In fact, while I noticed the lines in the video itself, it's actually
> most repeatably noticeable in the buttons underneath while the video
> is playing: make your mouse go back-and-forth between the "rate" and
> "share" buttons, and they get corrupted (and it also corrupts the
> progress bar).
> 
> It looks a bit like the noise you get with insufficient memory
> bandwidth, but I doubt that's the case here. Perhaps just some
> motion-comp problem?
> 
> Any ideas?

Since I doubt we're actually offloading to our video decode kernels for
Flash video on your machine, it could very well be a memory bw issue.
Can you try this small patch to see if one of the low power watermarks
is giving you trouble (note: cut & pasted)?

It could also be the normal power watermarks though too; you could just
make plane-wm and cursor_wm higher to test that.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
index 9ef5578..4e8af4d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3600,6 +3600,8 @@ static void ironlake_update_wm(struct drm_device *dev,
        if (enabled != 1)
                return;
 
+       return;
+
        clock = planea_clock ? planea_clock : planeb_clock;
 
        /* WM1 */

