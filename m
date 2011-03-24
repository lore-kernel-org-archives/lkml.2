Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1CXNiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:38:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42684 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab1CXNiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:38:01 -0400
Date: Thu, 24 Mar 2011 08:37:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
Message-ID: <20110324133752.GB20612@thinkpad-t410>
Mail-Followup-To: Chris Bagwell <chris@cnpbagwell.com>,
	Corentin Chary <corentin.chary@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
 <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
 <20110324131414.GA20612@thinkpad-t410>
 <AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Yes, on press-and-hold you get a sequence like

  e4 ea ea ... ea e5

So there'd have to be some simple state machine there to be sure the
release event was sent for KEY_PROG2.

> I'm not sure what BTN_HOME is commonly used for.  This button does
> sound like a HOME button in iPad sense but not in web browser sense.

I haven't used an iPad, but I was assuming on that the home button took
you, well, to the home screen, which is what it does on Android devices.
In my mind that would equate to something like "show desktop" on a
desktop OS, but I guess that's for the desktop designers to decide. In
Windows this one seems to take you to some set up screen, unless you
hold it, in which case it rotates the screen orientation. And I'm
assuming on the press-and-hold you don't see the setup screen before the
rotation, but I never got a chance to experiment with the button under
Windows so I can't say for sure.

