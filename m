Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1CYQ3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:29:02 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53406 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1CYQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:29:00 -0400
Date: Fri, 25 Mar 2011 11:28:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325162850.GD14328@thinkpad-t410>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <20110325161405.GC5099@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325161405.GC5099@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:14:05AM -0700, Dmitry Torokhov wrote:
> > If you keep a keyboard key pressed, you want multiple events, not one right ?
> > I think it's important not to loose informations. If someone keep this
> > key pressed more than 1.5 second, I think it's good idea to send
> > multiple KEY_PROG2.
> 
> You can have input autorepeat facilities do that for you. If you want to
> do this yourself then the proper value for repeated events is _2_, not
> 1, or they will be dropped as duplicates.
> 
> > 
> > About KEY_HOME press / release, and filtering KEY_HOME after
> > KEY_PROG2, I'm not sure. So if you really want it, and nobody
> > complains, I'll be happy to accept your patch.
> > 
> > > And back to the question of KEY_HOME -- that's not really what you want,
> > > is it? As in "move cursor to start of line"?
> > 
> > Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
> > What about:
> > - KEY_CYCLEWINDOWS
> > - KEY_COMPUTER
> > - KEY_HOMEPAGE
> > - KEY_DASHBOARD
> > 
> > I think KEY_HOMEPAGE is the best choice.
> 
> No, KEY_HOMEPAGE should cause your browser to go to your home page. What
> you want is either:
> 
> #define KEY_CONFIG         171     /* AL Consumer Control Configuration */
> #define KEY_DASHBOARD      204     /* AL Dashboard */
> 
> ("AL" stands for "Application Launcher", "AC" for 'Application Control",
> matched loosely to HUT tables).

Dmitry,

I didn't see you responses before my last response, so you can ignore
it. Let me make sure I understand correctly. For reference, the button
in question sends an 0xe4 scancode on press, repeated 0xea scancodes on
hold, and 0xe5 on release.

So, would the following make sense (KEY_TBD is may abbreviation for "key
to be determinded"):

 - On press (0xe4), send KEY_TBD, value = 1
 - On hold (0xea), send KEY_TBD, value = 2
 - On release (0xe5), send KEY_TBD, value = 0

Also, is KEY_CYCLEWINDOWS intended to imply screen rotation, or
something else?

Thanks,
Seth

