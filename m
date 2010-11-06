Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0KFPBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:01:31 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:60478 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0KFPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:01:30 -0400
Message-ID: <4CD56DB7.109@cs.columbia.edu>
Date: Sat, 06 Nov 2010 11:01:11 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Tejun Heo <tj@kernel.org>, Gene Cooperman <gene@ccs.neu.edu>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com>
In-Reply-To: <20101106053204.GB12449@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/2010 01:32 AM, Matt Helsley wrote:
> On Fri, Nov 05, 2010 at 10:28:09AM +0100, Tejun Heo wrote:
>> Hello,
>>
>> On 11/04/2010 05:44 PM, Gene Cooperman wrote:
>>>>> In our personal view, a key difference between in-kernel and userland
>>>>> approaches is the issue of security.
>>>>
>>>> That's an interesting point but I don't think it's a dealbreaker.
>>>> ... but it's not like CR is gonna be deployed on
>>>> majority of desktops and servers (if so, let's talk about it then).
>>>
>>> This is a good point to clarify some issues.  C/R has several good
>>> targets.  For example, BLCR has targeted HPC batch facilities, and
>>> does it well.
>>>
>>> DMTCP started life on the desktop, and it's still a primary focus of
>>> DMTCP.  We worked to support screen on this release precisely so
>>> that advanced desktop users have the option of putting their whole
>>> screen session under checkpoint control.  It complements the core
>>> goal of screen: If you walk away from a terminal, you can get back
>>> the session elsewhere.  If your session crashes, you can get back
>>> the session elsewhere (depending on where you save the checkpoint
>>> files, of course :-) ).
>>
>> Call me skeptical but I still don't see, yet, it being a mainstream
>> thing (for average sysadmin John and proverbial aunt Tilly).  It
>> definitely is useful for many different use cases tho.  Hey, but let's
>> see.
> 
> Rightly so. It hasn't been widely proven as something that distros
> would be willing to integrate into a normal desktop session. We've got
> some demos of it working with VNC, twm, and vim. Oren has his own VNC,
> twm, etc demos too. We haven't looked very closely at more advanced
> desktop sessions like (in no particular order) KDE or Gnome. Nor have
> we yet looked at working with any portions of X that were meant to provide
> this but were never popular enough to do so (XSMP iirc).

Actually, I do have a demo of Zap (linux-cr predecessor) with a _full_
gnome desktop running under VNC with:
* a movie player,
* firefox,
* thunderbird,
* openoffice,
* kernel make,
* gdb debugging something,
* WINE with microsoft office (oops)
all of these checkpointed with < 25ms of downtime and resumed an
arbitrary time later, successfully.

I even have witnesses that saw it ;)

> 
> Does DMTCP handle KDE/Gnome sessions? X too?
> 
> On the kernel side of things for the desktop, right now we think our
> biggest obstacle is inotify. I've been working on kernel patches for
> kernel-cr to do that and it seems fairly do-able. Does DMTCP handle
> restarting inotify watches without dropping events that were present
> during checkpoint?
> 

At the very least userspace would need to interpose on all
inotify related syscalls to track (log) what the user did to
be able to redo it at restart. (And I'm sure there will be
crazy to impossible races and corner cases there).

Does it make sense to replicate in userspace everything already done
in the kernel ?

> The other problem for kernel c/r of X is likely to be DRM. Since the
> different graphics chipsets vary so widely there's nothing we can do
> to migrate DRM state of an NVIDIA chipset to DRM state of an ATI chipset
> as far as I know. Perhaps if that would help hybrid graphics systems
> then it's something that could be common between DRM and
> checkpoint/restart but it's very much pie-in-the-sky at the moment.

DRM is hardware, and is complex for both userspace and kernel. Let's
assume it isn't support until it's properly virtualized.

(In the long-long run, I'd envision hardware manufacturers providing
c/r support within their drivers - e.g. a checkpoint() and restart()
kernel methods. But that's only if they care about it, and in any
event, pretty far down the road...)

> kernel c/r of input devices might be alot easier. We just simulate
> hot [un]plug of the devices and rely on X responding. We can even
> checkpoint the events X would have missed and deliver them prior to hot
> unplug.
> 

[snip]

Oren.
