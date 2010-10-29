Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793Ab0J2AQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:16:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:51055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093Ab0J2AQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:16:44 -0400
Message-ID: <53195.84.105.60.153.1288311394.squirrel@gate.crashing.org>
In-Reply-To: <20101028210753.22240.qmail@kosh.dhis.org>
References: <20101028210753.22240.qmail@kosh.dhis.org>
Date: Fri, 29 Oct 2010 02:16:34 +0200 (CEST)
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Almost all of my devices are under that PCI node. What will I prove by
>> > disabling them?
>>
>> You should put it after "load", and before "go".
>>
>> It should give you a working system; it's a sledgehammer workaround.
>
> I can do it a little more gracefully than that. This works to deactivate
> the
> problem devices manually:
>
>   1 lbflip 80000000 8 + rl!
>   1 lbflip 80001000 8 + rl!
>
> where 80000000 and 80001000 have been obtained from
> /pci@80000000/usb@5/assigned-addresses and
> /pci@80000000/usb@5,1/assigned-addresses; 8 is the offset of the
> HcCommandStatus register; and the 1 bit is HostControllerReset (HCR).
>
> Now I'm just trying to find the more correct way of doing it, without
> hardcoded addresses. That'll be something like this:
>
>   search the device tree for OHCI nodes
>   for each OHCI node
>     get assigned-addresses
>     map-in
>     set HCR
>     wait for acknowledgement
>     map-out

As you noted, your firmware does not show which usb host controllers
are OHCI and which are not.  It has a lot of other problems as well.
Also, it's a lot of code to do things this way.  Which is why I suggested
the "heavy handed" workaround: it is simple and should work on even the
most broken OF implementations.

To figure out which host controllers are OHCI, you'll need to look
at the PCI class code (0c0310 for OHCI), since your OF doesn't want
to tell you.

> Sound good?

Sounds like it should work, yes.


Segher

