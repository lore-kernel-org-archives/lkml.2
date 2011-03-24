Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1CXNOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:14:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57979 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab1CXNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:14:28 -0400
Date: Thu, 24 Mar 2011 08:14:15 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
Message-ID: <20110324131414.GA20612@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
 <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:33:33AM +0100, Corentin Chary wrote:
> On Wed, Mar 23, 2011 at 8:39 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >
> > This button is unusual. On press it emits scanocde 0xe4, on release
> > 0xe5, and when held for a few seconds it begins emitting 0xea about
> > twice per second. I chose to handle only the press event in order to
> > make it behave like the other hotkeys.
> >
> > Probably the closest thing to the intended function of this button
> > would be to alternate the display orientation between portrait and
> > landscape, but since there doesn't appear to be a keycode defined for
> > that function I went with KEY_PROG2. I'm open to other suggestions
> > however.
> 
> Hi,
> The manual says that under Windows, this is the "Home Key", so
> KEY_HOME would be more appropriate.

The manual does call it the Home Key (I missed previously that the
Express Gate description referred only to the quick boot mode), but the
description of the key operation reads:

  Shortly press this key to launch the Touch Gate touch screen
  interface. Press and hold this key to preview desktop rotation, and
  then release the key to finish desktop rotation.

Which doesn't really sound like a home key to me, and the icon above the
button also suggests display rotation. But then we don't seem to have a
code for that function, so KEY_PROG2 may be no better than KEY_HOME...

> Also, it would be great to preserve key up and key down informations
> (sparse keymap have an "autorelease" parameter to control that).

Okay, I'll add some special casing for this key to support that. Do you
suggest ignoring the 0xea scan codes?

