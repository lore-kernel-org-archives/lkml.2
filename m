Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0JKPbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:31:50 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52228 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab0JKPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:31:48 -0400
Message-ID: <4CB32DCA.4090809@euromail.se>
Date: Mon, 11 Oct 2010 17:31:22 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chris Bagwell <chris@cnpbagwell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>	<s5hfwwg4p4t.wl%tiwai@suse.de>	<1286558135.22715.162.camel@mini>	<201010081104.01527.dmitry.torokhov@gmail.com>	<s5h62xc4h2l.wl%tiwai@suse.de>	<20101010210434.GC18455@core.coreip.homeip.net>	<s5hy6a52ndd.wl%tiwai@suse.de>	<4CB2C154.5060303@euromail.se>	<AANLkTi=VTq+3-t4taR_22E1Wkos+yeHdMDkHd-Zc9Cbs@mail.gmail.com>	<s5hy6a4g76r.wl%tiwai@suse.de>	<4CB31E29.9020602@euromail.se> <s5hlj64g4xt.wl%tiwai@suse.de>
In-Reply-To: <s5hlj64g4xt.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P5KLl-0008By-7F.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1P5KLl-0008By-7F 772e886925c66b73e509b8508855e67a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 04:49 PM, Takashi Iwai wrote:
[...]
>>> As an example of mess of Clickpad: if you keep your finger on a button

>>> area and another finger on the normal area, you shouldn't trigger the
>>> multi-touch mode, no matter whether it's clicked or not.  People tend
>>> to keep the finger on the button before actually dragging.
>>>
>>> But, if you put both fingers in the button area and sliding together,
>>> it should be handled as two-finger scrolling.  Also, if you move one
>>> finger on a button area, it should be tracked as a normal pointer
>>> movement.
>>
>>
>> Are you aware of http://bitmath.org/code/multitouch/? The driver was developed
>> to address very similar issues on the macbook trackpads.
> 
> Well, I thought Macs don't use the certain areas as virtual buttons
> but determines the button by the number of fingers.  Or was it
> changed?  If yes, could you point out which source file does it?


The trackpads with integrated button are like clickpads with one button. It
would certainly be interesting to use the clickpad pattern on those as well. For
both types of pads, the bottom area is special. Two-finger scroll works as
normal, while a clicking finger may move around without affecting anything, nor
the number of fingers on the pad.

> I'm looking through the git tree
> http://bitmath.org/git/multitouch.git, but couldn't find out yet...


src/memory.c might be what you are looking for. There are also two unpublished
branches around - one which uses the mtdev library, and one which uses
utouch-grail directly (but with limited functionality).

>>> Another mess is that, as the default setup, the pointer movement is
>>> too sensitive, and when user pushes down the touchpad for clicking,
>>> the pointer moves a few or more pixels.  This eventually misses the
>>> target.  So, some trick to drag the pointer is necessary for click
>>> action.  One of my patches does it by introducing some "move
>>> threshold" value.
>>
>>
>> Also addressed in that project. What I am hoping to see, eventually, is code
>> similar to the core of the multitouch project in something like ginn. This would
>> exercise the whole utouch stack in an extensible way, and finally make
>> multitouch trackpads work the way they are supposed to.
> 
> If the messy behavior of clickpad suits with the multi-touch library,
> I have nothing against it, sure.  It was just my concern that the
> clickpad-style handling might pollute the code.


I am not sure it has to be messy at all, and it has to reside *somewhere*. I
think something like ginn, or parallel to ginn, is the best long-run place for
it. Submitting clickpad functionality to multitouch for starters would
definitely work in my book.

Cheers,
Henrik
