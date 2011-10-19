Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1JSVLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:11:16 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:57921 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1JSVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:11:15 -0400
Date: Wed, 19 Oct 2011 23:07:42 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111019210742.GA2432@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

Jiri Kosina [Wed, Oct 19, 2011 at 05:04:29PM +0200]:
> On Wed, 19 Oct 2011, Nico Schottelius wrote:
> 
> > > [...] 
> > > I've attached the xev output of fn+{F1-F12}.
> > > 
> > > F1-F4 are correct, though
> > >   F3 = Expose on MacOS X (**)
> > >   F4 = Dashboard (**)
> > > F5: not mapped at all: Is KeyboardLightDecrease on MacOSX (*)
> > > F6 is XF86AudioPrev incorrect: Should be  KeyboardLightIncrease (*)
> > > F7 is XF86AudioPlay incorrect: Should be XF86AudioPrev
> > > F8 is XF86AudioNext incorrect: Should be XF86AudioPlay
> > > F9 is XF86AudioMute incorrect: Should be XF86AudioNext
> > > F10 is XF86AudioLowerVolume incorrect: Should be XF86AudioMute
> > > F11 is XF86AudioRaiseVolume incorrect: Should be XF86AudioLowerVolume 
> > > F12 is XF86Eject incorrect: Should be  XF86AudioRaiseVolume 
> > > 
> > > Thus F7-12 are shifted by one to left in reality and as the MacBook Air
> > 
> > if I want to correct these bugs, which tree should I use as the base?
> > And when I corrected those, to whom to submit?
> 
> Hi,
> 
> please use hid tree, for-next branch. The tree is located on kernel.org.

Alright used that one, put my changes into the mba42-fixes branch [0].

As I cannot use your tree standalone due to the display problems, I've also
put it into the keyboardmappingfix of the tree that merges yours and the
one from Keith [1].

I've tested my patches, all keys are mapped correctly now, xev output
is attached. Please merge my patch from [0].

> > I guess the general approach would be to branch out, if it's a mba4,2,
> > then apply the following mapping, correct?
> 
> Yes, there are mapping tables in hid-apple.c already, so just introduce a 
> new one.
> 
> I am a bit surprised that they are needed though, the original report 
> stated that the the table is identical to the one that is already there 
> (apple_fn_keys[]).

Well, the fn-key works and it generates "different events" than without
the tree, but the mapping is not completly correct.

Looking at the code, I'm wondering if any MBA user has it correctly
working: The macbookair_fn_keys[] misses the F5 mapping (which is what
I see here) and I imagine there is no mba out there, that does not have
a special key on FN+F5.

And checking with the manuals I see on the net, it seems the keys have
not changed on the air, i.e. it should be wrong on all MacBook airs.

Cheers,

Nico

[0] http://git.schottelius.org/?p=foreign/linux-jiri-hid;a=summary
    git://git.schottelius.org/foreign/linux-jiri-hid

[1] http://git.schottelius.org/?p=foreign/linux-keith-jiri-mba;a=summary
    git://git.schottelius.org/foreign/linux-keith-jiri-mba

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
