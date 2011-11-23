Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1KWPuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:50:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52121 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1KWPuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:50:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
References: <20111121182910.GA2856@Boggieman>
	<20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
Date: Wed, 23 Nov 2011 16:50:12 +0100
Message-ID: <CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
Subject: Re: GMA500 support
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:28 PM, Alan Cox wrote:
> On Mon, 21 Nov 2011 19:29:10 +0100
> Kristoffer Ericson wrote:
>
>> Greetings,
>>
>> Im syncing my gma500 tree to all the patches I see pass through the kernel mailinglist and
>> its progressing well.
>> However, It would be nice with an todo list or a more practical this-works list. I know
>> its not a priority but would simplify alot for end users.
>
> If you configure it in the following should work on GMA500/600
> - internal laptop displays including backlight
> - external svga

Worth pointing out is that DDC for external displays isn't working until my
fixes for SDVO gets in there. Manually setting a mode works fine. Otherwise
you'll default to 1280x1024 (or was it 1024x768?).

> - mode setting via KMS
> - framebuffer console
> - the framebuffer X server (and once out generally Dave Airlie's generic
>  KMS X server)
> - suspend/resume

- Sync to vblank is supported on gma500

>
> The following I know don't work
> - Huge external displays so large they won't fit in 8MB at init time
>  (causes a crash)
> - Using the vesa X server with it - this confuses stuff and isn't
>  fixable, it's a "wrong user configuration"
>
> Unsupported
> - 2D hardware acceleration except console scrolling (as it seems to be
>  too slow to be useful). I may add some 2D bits later where they do help
>  (eg back to front blitting may be worth it just about)
> - 3D engine (no public documentation)
> - Video playback acceleration. In theory there is enough info in the
>  VAAPI code for GMA500/600 that has been published and in the old
>  'binary X/source kernel' driver to do this but someone will have to
>  work on it if they want it
> - Dell Mini HDMI port. This seems to be some kind of external bridge
>  chip. Being a TV luddite I don't yet own an HDMI capable display to
>  test.

I suspect this is just DVI with a HDMI connector. That is the case for Fit-PC2.
It is hooked up to the SDVO and provides video but no audio.

>
> And I'm sure we have a few bugs left !
>
> Alan
>
