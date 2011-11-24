Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1KXQTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:19:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64025 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1KXQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:19:22 -0500
Date: Thu, 24 Nov 2011 17:20:14 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20111124162014.GA2750@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20111121182910.GA2856@Boggieman>
 <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
 <CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 04:50:12PM +0100, Patrik Jakobsson wrote:
> On Wed, Nov 23, 2011 at 12:28 PM, Alan Cox wrote:
> > On Mon, 21 Nov 2011 19:29:10 +0100
> > Kristoffer Ericson wrote:
> >
> >> Greetings,
> >>
> >> Im syncing my gma500 tree to all the patches I see pass through the kernel mailinglist and
> >> its progressing well.
> >> However, It would be nice with an todo list or a more practical this-works list. I know
> >> its not a priority but would simplify alot for end users.

Big thanks for list!

> >
> > If you configure it in the following should work on GMA500/600
> > - internal laptop displays including backlight

It works for me, however if external display is connected it defaults to 1024x768 (as patrik
pointed out). The internal screen gets mirrored and therefore looses about 600x768 pixels (which look like
memory garbage). 
Without external monitor however I get "full" sized screen (1600x768). My laptop is a sony vgn-p21z/r so its
a wide-screen laptop, therefore the weird resolution.

> > - external svga
> 
> Worth pointing out is that DDC for external displays isn't working until my
> fixes for SDVO gets in there. Manually setting a mode works fine. Otherwise
> you'll default to 1280x1024 (or was it 1024x768?).
> 
> > - mode setting via KMS
> > - framebuffer console
> > - the framebuffer X server (and once out generally Dave Airlie's generic
> >  KMS X server)
> > - suspend/resume
> 
> - Sync to vblank is supported on gma500
> 
> >
> > The following I know don't work
> > - Huge external displays so large they won't fit in 8MB at init time
> >  (causes a crash)

Im not able to set any resolution at all for the external screen, its always 1024x768.
I cannot be 100% sure that its not my external screen not accepting the 1600x768 resolution
and they therefor find the largest compatible resolution.

> > - Using the vesa X server with it - this confuses stuff and isn't
> >  fixable, it's a "wrong user configuration"
> >
> > Unsupported
> > - 2D hardware acceleration except console scrolling (as it seems to be
> >  too slow to be useful). I may add some 2D bits later where they do help
> >  (eg back to front blitting may be worth it just about)
> > - 3D engine (no public documentation)

Can any parts of the i915 be used?

> > - Video playback acceleration. In theory there is enough info in the
> >  VAAPI code for GMA500/600 that has been published and in the old
> >  'binary X/source kernel' driver to do this but someone will have to
> >  work on it if they want it
> > - Dell Mini HDMI port. This seems to be some kind of external bridge
> >  chip. Being a TV luddite I don't yet own an HDMI capable display to
> >  test.
> 
> I suspect this is just DVI with a HDMI connector. That is the case for Fit-PC2.
> It is hooked up to the SDVO and provides video but no audio.
> 
> >
> > And I'm sure we have a few bugs left !
> >
> > Alan
> >
