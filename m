Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1JQVlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:41:20 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:33900 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab1JQVlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:41:17 -0400
Date: Mon, 17 Oct 2011 23:40:50 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111017214050.GA1408@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc5-00161-gad1c761 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

Jiri Kosina [Mon, Oct 17, 2011 at 08:16:55PM +0200]:
> > [...]
> > - The fn key does not modify the cursor behaviour:
> >   FN+Cursor up should result in Page up,
> >   FN+Cursor down should result in Page down, etc.
> > 
> >   Actual result: Cursor keys are passed in as usual
> > 
> > - The multitouch trackpad only works if bcm5974 is loaded before usbhid
> >   -> otherwise only left click works
> > 
> > - If bcm5974 is loaded before usbhid, left moving the mouse while
> >   holding down the mouse button (i.e. the trackpad) does not work,
> >   but results in a right click
> > 
> > Anyone a pointer on how to fix these issues?
> 
> Please try with my hid.git tree, preferably for-next branch. Namely 
> commit 4b086910ad1.

Thanks a lot, fn works perfectly now!

If I switch fnmode to 2
(echo 2 > /sys/module/hid_apple/parameters/fnmode),
there are though some mis-mapping for the Multimedia Keys.

I've attached the xev output of fn+{F1-F12}.

F1-F4 are correct, though
  F3 = Expose on MacOS X (**)
  F4 = Dashboard (**)
F5: not mapped at all: Is KeyboardLightDecrease on MacOSX (*)
F6 is XF86AudioPrev incorrect: Should be  KeyboardLightIncrease (*)
F7 is XF86AudioPlay incorrect: Should be XF86AudioPrev
F8 is XF86AudioNext incorrect: Should be XF86AudioPlay
F9 is XF86AudioMute incorrect: Should be XF86AudioNext
F10 is XF86AudioLowerVolume incorrect: Should be XF86AudioMute
F11 is XF86AudioRaiseVolume incorrect: Should be XF86AudioLowerVolume 
F12 is XF86Eject incorrect: Should be  XF86AudioRaiseVolume 

Thus F7-12 are shifted by one to left in reality and as the MacBook Air
does not have an optical drive, there is no eject button.

One thing that does not work on the trackpad that works on MacOS X:

Having the thumb (or any other finger) on the trackpad (not moving)
and moving another finger to move the pointer does not work.

This always results in a scroll event, which is probably never
desired but only when two fingers are moved.

But in general, this looks like a great step towards usability on the
Macbook Air!

When can we expect this to be merged into Linus' tree? Imho this should
be moved there asap, to prevent other users to run into the same
trouble.

Cheers,

Nico

(*) If Xorg/Linux has something like this, if not it should be added
(**) XF86LaunchA/B work fine as well, but could be renamed for easier
     mapping

p.s.: Search for "mac book air manual" to see the actual keyboard
      mappings in the pdf, page 28.

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
