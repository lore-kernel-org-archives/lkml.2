Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab0JZOqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:46:53 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:49158 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0JZOqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:46:50 -0400
Message-ID: <4CC6E9D8.8010201@triadsys.com>
Date: Tue, 26 Oct 2010 10:46:48 -0400
From: Tom Vier <tom@triadsys.com>
Organization: Triad Systems Engineering, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Samuel Thibault <sthibault@debian.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, 594089@bugs.debian.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
References: <20100823154353.2805.13525.reportbug@tom.tse> <20100903235540.GA9149@const> <4C866913.3030201@triadsys.com> <4C8E6861.1070502@triadsys.com> <20101024144150.GV24091@const.famille.thibault.fr> <20101025045003.GA1438@core.coreip.homeip.net> <4CC58816.3090301@triadsys.com> <20101025180320.GA4725@const.famille.thibault.fr>
In-Reply-To: <20101025180320.GA4725@const.famille.thibault.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 02:03 PM, Samuel Thibault wrote:
 > Tom Vier, le Mon 25 Oct 2010 09:37:26 -0400, a écrit :
 >> On 10/25/2010 12:50 AM, Dmitry Torokhov wrote:
 >>> On Sun, Oct 24, 2010 at 04:41:51PM +0200, Samuel Thibault wrote:
 >>>> The short story is: Tom's keyboard sends all that when he presses caps
 >>>> lock:
 >>>>
 >>>> press: 0x3a 0xe0 0x66
 >>>> repeat: 0x3a
 >>>> release: 0xba 0xe0 0xe6
 >>>>
 >>>> 0xe0 0x66 happens to be the "favorites" key on his keyboard with
 >>>> internet navigation keys.  I thus believe there's a bug in his 
keyboard
 >>>> that needs to be filtered at the kernel level.
 >>>>
 >>>> The long story can be read on
 >>>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594089
 >>>
 >>> Hmm, the question is whether the real "favorites" key send the same
 >>> usage and the fake one after caps lock. Any chance Tom could locate
 >>> evtest utility and see what MSC_SCAN events being emitted?
 >>
 >> Sure. Here's caps-lock:
 >>
 >> Event: time 1288013671.633008, -------------- Report Sync ------------
 >> Event: time 1288013674.171812, type 4 (Misc), code 4 (ScanCode), 
value 70039
 >> Event: time 1288013674.171853, type 1 (Key), code 58 (CapsLock), value 1
 >> Event: time 1288013674.171862, -------------- Report Sync ------------
 >> Event: time 1288013674.172210, type 17 (LED), code 1 (CapsLock), value 1
 >> Event: time 1288013674.299553, type 4 (Misc), code 4 (ScanCode), 
value 70039
 >> Event: time 1288013674.299580, type 1 (Key), code 58 (CapsLock), value 0
 >> Event: time 1288013674.299593, -------------- Report Sync ------------
 >>
 >>
 >> Right-shift (the other problem key):
 >>
 >> Event: time 1288013798.388025, -------------- Report Sync ------------
 >> Event: time 1288013800.742088, type 4 (Misc), code 4 (ScanCode), 
value 700e5
 >> Event: time 1288013800.742130, type 1 (Key), code 54 (RightShift), 
value 1
 >> Event: time 1288013800.742142, -------------- Report Sync ------------
 >> Event: time 1288013800.861777, type 4 (Misc), code 4 (ScanCode), 
value 700e5
 >> Event: time 1288013800.861812, type 1 (Key), code 54 (RightShift), 
value 0
 >> Event: time 1288013800.861824, -------------- Report Sync ------------
 >
 > Could you also post results when pressing the "favorite" and the "prev"
 > internet keys of your keyboard?
 >
 > Samuel


It's returning the same codes. Maybe what's going on here is that they 
never worked back in Stable and someone tried to fix those keys, not 
realizing they're the same codes as capslock and right-shift. I'll have 
to test it on my Stable machine tonight to see if those keys work or 
not, tho.

Favorites:
Event: time 1288041423.048839, -------------- Report Sync ------------
Event: time 1288041425.068704, type 4 (Misc), code 4 (ScanCode), value 70039
Event: time 1288041425.068742, type 1 (Key), code 58 (CapsLock), value 1
Event: time 1288041425.068754, -------------- Report Sync ------------
Event: time 1288041425.069105, type 17 (LED), code 1 (CapsLock), value 1
Event: time 1288041425.260313, type 4 (Misc), code 4 (ScanCode), value 70039
Event: time 1288041425.260343, type 1 (Key), code 58 (CapsLock), value 0
Event: time 1288041425.260347, -------------- Report Sync ------------

Previous:
Event: time 1288041443.531447, -------------- Report Sync ------------
Event: time 1288041445.318877, type 4 (Misc), code 4 (ScanCode), value 700e5
Event: time 1288041445.318915, type 1 (Key), code 54 (RightShift), value 1
Event: time 1288041445.318932, -------------- Report Sync ------------
Event: time 1288041445.438567, type 4 (Misc), code 4 (ScanCode), value 700e5
Event: time 1288041445.438606, type 1 (Key), code 54 (RightShift), value 0
Event: time 1288041445.438629, -------------- Report Sync ------------


--
Tom Vier <tom@triadsys.com>
Senior Net/Sys Admin
Triad Systems Engineering, Inc.

