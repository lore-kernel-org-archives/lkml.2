Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393Ab0HGBCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:02:08 -0400
Received: from mail.lang.hm ([64.81.33.126]:53875 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0HGBCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:02:04 -0400
Date: Fri, 6 Aug 2010 18:00:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100807001431.GA3252@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
References: <20100805230304.GQ2447@linux.vnet.ibm.com> <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com> <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm> <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm> <20100806123047.GE31326@sirena.org.uk> <20100806172226.GH2432@linux.vnet.ibm.com> <20100806173325.GA25367@rakim.wolfsonmicro.main> <20100806181832.GJ2432@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
 <20100807001431.GA3252@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Mark Brown wrote:

> On Fri, Aug 06, 2010 at 04:35:59PM -0700, david@lang.hm wrote:
>> On Fri, 6 Aug 2010, Paul E. McKenney wrote:
>
>> So as I see it, we need to do one of two things.
>
>> 1. change the suspend definition to allow for some things to not be
>> suspended
>
> This is essentially what's already happening.
>
>> 2. change the sleep/low-power mode definition to have a more standardized
>> way of turning things off, and extend it to allow clocks to be turned off
>> as well (today we have things able to be turned off, drive spin-down for
>> example, but per comments in this thread it's all one-off methods)
>
> Currently things like clock trees are frequently managed orthogonaly to
> the system power state to at least some extent anyway - for example,
> perfectly normal wake events like button presses will often require
> clocks for things like debouncing.

I recognise that #1 is essentially what Android is already doing.

I'm asking the question, "Is this what Linux should be doing?

Personally, I think that suspend should be treated much more like a 
low-power state and much less like hibernation than it currently is (I 
believe that Linus has also voiced this opinion). And I think that the 
situation with Android suspending while audio is playing between busts of 
CPU activity is a perfect example.

for the moment, forget the problem of other apps that may be running, and 
consider a system that's just running a media player.

the media player needs bursts of CPU to decode the media so that the 
output device can access it (via DMA or something like that)

the media player needs bursts of I/O to read the encoded program source 
from storage.

What we want to have happen in an ideal world is

when the storage isn't needed (between reads) the storage should shutdown 
to as low a power state as possible.

when the CPU isn't needed (between decoding bursts) the CPU and as much of 
the system as possible (potentially including some banks of RAM) should 
shutdown to as low a power state as possible.


today there are two ways of this happening, via the idle approach (on 
everything except Android), or via suspend (on Android)

Given that many platforms cannot go to into suspend while still playing 
audio, the idle approach is not going to be able to be eliminated (and in 
fact will be the most common approach to be used/deugged in terms of the 
types of platforms), it seems to me that there may be a significant amount 
of value in seeing if there is a way to change Android to use this 
approach as well instead of having two different systems competing to do 
the same job.

David Lang
