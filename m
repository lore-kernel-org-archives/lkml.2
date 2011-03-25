Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1CYQF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:05:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1CYQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kzpcLoB0uvJ55eptiMHHng/WMwD/2419rtDsja3yP+vCB2L9H/glVT4kTuukUN4O3T
         QJt+uqqu7Bo3QbYkEc0+cJS4HYOUDcS6RFZWxL1oppHsFHaf4SducKODUag+OnXMzcKr
         IbLwAhro5U3zClUywlFzHqoF47zM/gZaMK8KE=
Date: Fri, 25 Mar 2011 09:05:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
Message-ID: <20110325160521.GA5099@core.coreip.homeip.net>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
 <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
 <20110324131414.GA20612@thinkpad-t410>
 <AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:27:41AM -0500, Chris Bagwell wrote:
> On Thu, Mar 24, 2011 at 8:14 AM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Thu, Mar 24, 2011 at 08:33:33AM +0100, Corentin Chary wrote:
> >> On Wed, Mar 23, 2011 at 8:39 PM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >> > ---
> >> >
> >> > This button is unusual. On press it emits scanocde 0xe4, on release
> >> > 0xe5, and when held for a few seconds it begins emitting 0xea about
> >> > twice per second. I chose to handle only the press event in order to
> >> > make it behave like the other hotkeys.
> >> >
> >> > Probably the closest thing to the intended function of this button
> >> > would be to alternate the display orientation between portrait and
> >> > landscape, but since there doesn't appear to be a keycode defined for
> >> > that function I went with KEY_PROG2. I'm open to other suggestions
> >> > however.
> >>
> >> Hi,
> >> The manual says that under Windows, this is the "Home Key", so
> >> KEY_HOME would be more appropriate.
> >
> > The manual does call it the Home Key (I missed previously that the
> > Express Gate description referred only to the quick boot mode), but the
> > description of the key operation reads:
> >
> >  Shortly press this key to launch the Touch Gate touch screen
> >  interface. Press and hold this key to preview desktop rotation, and
> >  then release the key to finish desktop rotation.
> >
> > Which doesn't really sound like a home key to me, and the icon above the
> > button also suggests display rotation. But then we don't seem to have a
> > code for that function, so KEY_PROG2 may be no better than KEY_HOME...
> >
> >> Also, it would be great to preserve key up and key down informations
> >> (sparse keymap have an "autorelease" parameter to control that).
> >
> > Okay, I'll add some special casing for this key to support that. Do you
> > suggest ignoring the 0xea scan codes?
> >
> 
> I have one of these in the mail so I'm interested in outcome.
> 
> I suggest implementing as manual describes and can be handled similar
> to brightness control logic.
> 
> I would suggest sending BTN_HOME upon button release 0xe5 (not press
> 0xe4 and do the autorelease because of it) and BTN_PROG2 on
> press-and-hold 0xea.
> 
> If you press-and-hold, does it still send the 0xe5 upon release?  That
> could complicate things so that both button events do not get sent.

Not in the kernel. It is a single button and should generate single
event. Have userspace decipher that pressing it once causes application
launcher to appear, holding it longer causes screen rotation, and if you
still keep it pressed for 10 minutes fireworks will start.

> 
> I'm not sure what BTN_HOME is commonly used for.  This button does
> sound like a HOME button in iPad sense but not in web browser sense.
> 

It is 'Home' key on your full AT keyboard, normally making cursor to
move to the very first column on the line.

Thanks.

-- 
Dmitry
