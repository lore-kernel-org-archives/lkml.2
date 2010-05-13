Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0EMQ4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:56:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545Ab0EMQ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:56:13 -0400
Date: Thu, 13 May 2010 09:54:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <20100513160117.GB22238@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Dmitry Torokhov wrote:
> 
> Apple does proper thing in BIOS and omits keyboard and mouse PNP
> devices, but because of other players we do not really trust PNP BIOS
> and resort to banding on ports directly - there are cases when box has
> mouse and/or keyboard but they are not present in BIOS. Damed if you do,
> damned if you don't...

Umm. No.

PnP information _commonly_ doesn't inclure PS/2 ports, even when they 
exist. Lack of PnP information about the keyboard port means absolutely 
nothing, and anybody who tells you otherwise is totally and utterly wrong. 

So don't confuse this with PnP issues. That's a total red herring, and 
Apple is _not_at_all_ "doing the proper thing in the BIOS". 

Quite the reverse. Apple is very clearly doing something horribly _wrong_ 
in their BIOS. Don't give them kudos for being incompetent morons.

Just google for

	"Probing ports directly" "i8042 KBD port"

and you'll get a lot of hits. That's not because those machines have wrong 
PnP tables - it's because fundamentally PNP is a joke, and on PC's what is 
much more important is "standard IO ports". 

For example, in that thread, Bastien is quoted:

	> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2 
	> controller exists, we randomly bang on the ports in the expectation 
	> they'll be there anyway. This seems rather misguided.

and all that tells me is that Bastien doesn't know what he is doing. It is 
_not_ "randomly bang" - it's called standard PC hardware.  And it's not 
"misguided" - it's very much correct and required, exactly because PnP 
itself is the misguided aborted fetus of a braindamaged mind.

We do not trust BIOS tables, because BIOS writers are invariably totally 
incompetent crack-addicted monkeys. If they weren't, they wouldn't be BIOS 
writers. QED. And in fact the Apple problem is an _example_ of this BIOS 
writer incompetence, not some shining example of them doing something 
right.

			Linus
