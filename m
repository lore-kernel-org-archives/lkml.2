Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1HCBCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 21:02:23 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:62183 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab1HCBCR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 21:02:17 -0400
Date: Wed, 3 Aug 2011 02:02:11 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: keyboard problems with 3.0 (xorg, evdev)
Message-ID: <20110803010211.GA27283@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=q6MVcJK7K2YA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=8zi1aGIzh7KyPDRDk34A:9 a=YQestG7S-fJspQ1SzQcA:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I guess my situation is unusual - I use a kvm switch to share a
monitor between my desktop boxes.  For a long time, there have been
intermittent mouse problems in X (typically, the mouse goes apeshit
and highlights everything), usually cured by cycling through the kvm
positions [ I usually only use one machine at a time ] and dropping
back to a tty before going back to X.  The key word is
*intermittent* - sometimes I can go weeks without problems.  Mostly,
I only use one box at a time.

 With 3.0, the problems are much worse - I'm getting keyboard
problems in vim (in urxvt) : the cursor keys stop working, as does
ESC [ although, bizzarely, Ctrl-C then takes over the ESC function
so I can sort-of continue editing ].

 The first time I saw this was my first boot of 3.0 on my ppc64.  I
initially assumed something in the keyboard area was horribly broken
there, but after coming back to it when I had time and paper-and-pen,
everything in both showkey and xev looked identical to previous
kernels, so I assumed it was a hardware glitch.

 Tonight, it started doing the same thing on an x86_64 box which had
been ok with 3.0.  This time, the first problem was that the mouse
clicks stopped working, and the loss of keys in vim happened later (I
clicked on a preview in the gimp/ufraw and thought things were slow
because my nfs drive with the photos I was editing spins down when
idle overnight, so I went to a different desktop to do something else
 in vim, and then I again saw the loss of cursor and ESC keys).

 After a lot of cycling thorough the kvm positions, and back to a tty,
it eventually all sorted itself and I was able to finish what I was
doing, but this time the following was in the system log:

Aug  3 00:10:48 ac30 kernel: psmouse.c: Wheel Mouse at
isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.
Aug  3 00:12:47 ac30 kernel: psmouse.c: Wheel Mouse at
isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.
Aug  3 00:12:47 ac30 kernel: psmouse.c: resync failed, issuing
reconnect request
Aug  3 00:12:49 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x71 on isa0060/serio0).
Aug  3 00:12:49 ac30 kernel: atkbd serio0: Use 'setkeycodes 71
<keycode>' to make it known.
Aug  3 00:12:49 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x71 on isa0060/serio0).
Aug  3 00:12:49 ac30 kernel: atkbd serio0: Use 'setkeycodes 71
<keycode>' to make it known.
Aug  3 00:12:55 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:12:55 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:12:55 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:12:55 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:01 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:01 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:01 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:01 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:04 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:04 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:04 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:04 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:05 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:05 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:05 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:05 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:11 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:11 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:11 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:11 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:12 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:12 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:12 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:12 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x64 on isa0060/serio0).
Aug  3 00:13:14 ac30 kernel: atkbd serio0: Use 'setkeycodes 64
<keycode>' to make it known.
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Use 'setkeycodes 55
<keycode>' to make it known.
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Use 'setkeycodes 55
<keycode>' to make it known.
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Use 'setkeycodes 55
<keycode>' to make it known.
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Use 'setkeycodes 55
<keycode>' to make it known.
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x55 on isa0060/serio0).
Aug  3 00:13:26 ac30 kernel: atkbd serio0: Use 'setkeycodes 55
<keycode>' to make it known.
Aug  3 00:13:27 ac30 kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0x71 on isa0060/serio0).
Aug  3 00:13:27 ac30 kernel: atkbd serio0: Use 'setkeycodes 71
<keycode>' to make it known.
Aug  3 00:13:27 ac30 kernel: atkbd serio0: Unknown key released
(translated set 2, code 0x71 on isa0060/serio0).

 this seems to repeat for keycodes 64, 55, 71 and then I got

Aug  3 00:18:24 ac30 kernel: psmouse.c: Wheel Mouse at
isa0060/serio1/input0 lost synchronization, throwing 2 bytes away.
Aug  3 00:18:25 ac30 kernel: psmouse.c: resync failed, issuing
reconnect request

 which seems to be associated with the end of the problem.

Keycodes 64, 55, 71 are 'Alt', 'v', and 'F8' (I'm using evdev).

 This is a pain in the proverial, but it's far too intermittent to
bisect.  I'm hoping it turns out to be very infrequent, because it's
a real annoyance, and I'm short of time (going on holiday soon).

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
