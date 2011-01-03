Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1ACUjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:39:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47580
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab1ACUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:39:09 -0500
Date: Mon, 03 Jan 2011 12:39:39 -0800 (PST)
Message-Id: <20110103.123939.02282416.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294086801.17576.14.camel@lithium>
References: <1294083541.17576.11.camel@lithium>
	<20110103.114301.102556157.davem@davemloft.net>
	<1294086801.17576.14.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Mon, 03 Jan 2011 20:33:21 +0000

> On Mon, 2011-01-03 at 11:43 -0800, David Miller wrote:
>> From: Alex Buell <alex.buell@munted.org.uk>
>> Date: Mon, 03 Jan 2011 19:39:01 +0000
>> 
>> > Secondly, is Linux fully capable of handling different graphic cards
>> > simultaneously? For example, plug in a pair of monitors and have
>> > consoles on both with disparate graphic cards i.e. XVR-500 and S3ViRGE
>> > etc? 
>> 
>> Technically I don't think it can do it currently.  Maybe just for
>> kernel message logging, but not for actual login consoles.
>> 
>> One TTY device is marked as the "console" and that's where all
>> tty[0-9]+ devices get instantiated upon.
> 
> Hmm, maybe it would be nice to introduce that capability. How doable
> would it be? I understand the BKL is going away, perhaps it would now be
> easier to introduce such a facility?

It has nothing to do with the big kernel lock.

> I've just started digging into the innards of the s3fb driver, my first
> attempt provoked this, simply by commenting out the check to see if it's
> not the primary device and exits with -ENODEV: 
> 
> Jan  3 20:16:29 sodium kernel: ERROR(1): Cheetah error trap taken
> afsr[0030100000000000] afar[00000000000003d0] TL1(0)
> Jan  3 20:16:29 sodium kernel: ERROR(1): TPC[105918d8] TNPC[105918dc]
> O7[10591884] TSTATE[4411001606]
> Jan  3 20:16:29 sodium kernel: ERROR(1): TPC<s3_pci_probe+0x194/0x63c
> [s3fb]>
> Jan  3 20:16:29 sodium kernel: ERROR(1): M_SYND(0),  E_SYND(0), Multiple
> Errors, Privileged

I know, this is what happens if you call vga_*() with a NULL first parameter
on sparc64.  It's accessing garbage addresses.
