Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0EVHJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 03:09:50 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39511 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab0EVHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 03:09:46 -0400
Message-ID: <4BF782D6.5060305@euromail.se>
Date: Sat, 22 May 2010 09:08:06 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>	 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>	 <4BF6B673.1080507@euromail.se>	 <20100521165218.GA26439@core.coreip.homeip.net>	 <4BF6BB43.2020405@euromail.se>	 <20100521172222.GB26439@core.coreip.homeip.net>	 <4BF6C303.7030804@euromail.se>	 <20100521174140.GA23155@core.coreip.homeip.net>	 <4BF6C7B6.2020008@euromail.se> <AANLkTikzH7IscIAYGNw00fjXSYJosaaAsbUArt9M7wfJ@mail.gmail.com>
In-Reply-To: <AANLkTikzH7IscIAYGNw00fjXSYJosaaAsbUArt9M7wfJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFiol-0000zp-6e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OFiol-0000zp-6e 391f130e93d6cc4f11dd5ecb450821df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> On Fri, May 21, 2010 at 10:49 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Dmitry Torokhov wrote:
>>> I guess this is where our disconnect lies as when I am looking at the
>>> event names I view all *_MT_* events as related to the multitouch
>>> protocol handling.
>>>
>> Yes. It is true that slot control is MT related, but I am looking at this from
>> the perspective of future expansions like KEY_MT,  KEY_REL, and such, finding a
>> way to signal to user space which events are handled via slots. If we had
>> ABS_MT_SLOT, we would most likely get applications which store ABS_MT_SLOT as an
>> attribute of the slot together with ABS_MT_POSITION_X, ABS_MT_TOUCH_MAJOR, etc,
>> which is just not right.
> 
> Why is it not right?  Do you mean ABS_SLOT can be used as a label for
> both _MT_ and non _MT_ events while ABS_MT_SLOT can not?
> 
>> So the proposal is ABS_SLOT.
> 
> I haven't convinced myself with this proposal yet. Can you explain the
> difference between ABS_SLOT and ABS_MT_SLOT with a concrete example?
> Fool always ignores Mark Twain's advice, you know :).

Ah. :-)

At this point, we seem to be discussing which solution is the least evil. To
recapitulate, the slot event should be neither an ABS event, nor an ABS_MT
event, but a SYN event as proposed earlier. In my view, the real solution is to
add the possibility to report usage and value range of SYN events to EVIO. To
move the slot event from SYN to ABS was an act of compromise, and we now face
this immaterial question.

In another thread regarding these patches, I have held a monologue regarding the
problem of knowing which events should be treated on a per-slot basis, and which
should be treated "the usual way". Currently, events matching *_MT_* are the
ones treated as slot events. One can imagine having better ways to deal with
this, but we do not, currently. And this is where the difference between
"ABS_SLOT" and "ABS_MT_SLOT" comes in.

Henrik

