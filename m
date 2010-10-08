Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0JHSEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:04:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34815 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0JHSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=HsDaEfnEywjY50yUe6iPNl+/0qO48iiLUxBOtlfavwSEFh5oNUzhX0kmVCGc77iEsY
         U0kzD1Mrc3cvKfdvgBAmAYQAc4hygpucBaJD2Rm/Z69PtBWdd2pjsLtlABO0B6YvCSq3
         Y1PDbPwv9KriJ1qZrd4Z2mSX8VawZAT+7ZoWU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
Date: Fri, 8 Oct 2010 11:04:01 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6+; KDE/4.4.5; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
        xorg-devel@lists.x.org, Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com> <s5hfwwg4p4t.wl%tiwai@suse.de> <1286558135.22715.162.camel@mini>
In-Reply-To: <1286558135.22715.162.camel@mini>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010081104.01527.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 08, 2010 10:15:35 am Chase Douglas wrote:
> On Fri, 2010-10-08 at 18:37 +0200, Takashi Iwai wrote:
> > At Fri,  8 Oct 2010 10:57:57 -0400,
> > 
> > Chase Douglas wrote:
> > > 
> > >
> > > Tobyn Bertram reverse engineered the multitouch protocol for Synaptics
> > > devices. I've been able to take his work and produce a series of
> > > commits to enable MT and multifinger (MF) support.
> > >
> > > 
> > >
> > > Unfortunately, there's a tricky issue with some Synaptics touchpads
> > > that have integrated buttons. For example, the left and right buttons
> > > on the touchpad of my Dell Mini 1012 consist of the lower ~20% of the
> > > touchpad surface. The touchpad physically clicks under these areas.
> > >
> > > 
> > >
> > > The X synaptics input module now has a parameter to disable touches
> > > occuring over the button area, but this solution still doesn't work
> > > perfectly. If you click a button and drag with another finger near the
> > > clicking finger, the touchpad gets confused.
> > >
> > > 
> > >
> > > Now that we have full MT support, we can try to handle this scenario
> > > better. What I've found to work best is to make touches vanish if they
> > > occur over the button area of the trackpad while any button is held.
> > > This works in conjunction with the X synaptics driver to disable
> > > single touch control over the button area. With full MT support, the
> > > touchpad doesn't seem to get confused when a click and drag occurs
> > > with two fingers close to each other, and it enables MT gestures and
> > > MF support across the entire trackpad when no buttons are held.
> > >
> > > 
> > >
> > > The first question is whether this seems appropriate to others, or if
> > > some other method would work better. Secondarily, should the solution
> > > occur in the kernel, like I have in the third patch of this series, or
> > > should it occur in the X input module? Although we don't have this
> > > information today, we may be able to query the touchpad in the future
> > > to know the area of the integrated buttons. If that were possible,
> > > would the recommended location for the hack change?
> >
> > 
> >
> > Great!  Finally someone found it out!
> > I found this and made a series of patches in 4 months ago.  Since
> > then, Novell legal prohibited me to send the patches to the upstream
> > due to "possible patent infringing".  Now you cracked out.  Yay.
> >
> > 
> >
> > FWIW, my corresponding patch is below.  It really looks similar in the
> > end ;)  I added a kconfig just to be safer.
> >
> > 
> >
> > Regarding the "clickpad" support: in my case, I implemented almost
> > everything about it in xorg driver.  I'm going to submit xorg
> > patches.
> 
> So I'm confused. I was working off of source code posted to:
> 
> https://bugs.launchpad.net/utouch/+bug/633225
> 
> I was under the impression that someone else had reverse engineered the
> protocol and written patches. But the code is exactly the same as what
> you've posted here. If you're the originator of the work, and my patch
> is accepted, I think we'll need your SOB on it.

Comment #6 is quite clear on this matter:

> Takashi Iwai from OpenSuse has done quite a bit of work for the Synaptics
> Clickpad including some experimental multitouch support, his repo is here:
> http://download.opensuse.org/repositories/home:/tiwai:/clickpad:/openSUSE_
> 11.3/openSUSE_11.3/src/
> 
> I have played around with the synaptics.c code in the kernel to add
> multitouch events (ABS_MT_POSITION_X, ABS_MT_POSITION_Y, ABS_MT_PRESSURE)
> using Takashi's work as a model.

So I do believe we need to have Takashi's SOB at the very least and maybe
credit him as the author of the patches.

-- 
Dmitry
