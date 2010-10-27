Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0J0W7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:59:00 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:41961 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752599Ab0J0W66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:58:58 -0400
Message-ID: <20101027225855.25345.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
To: segher@kernel.crashing.org (Segher Boessenkool)
Date: Wed, 27 Oct 2010 17:58:55 -0500 (GMT+5)
Cc: olaf@aepfle.de (Olaf Hering), linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <50654.84.105.60.153.1288217125.squirrel@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:
> 
> >> > |1. How do I locate all usb nodes in the device tree?
> >> > |
> >> > |2. How do I know if a particular usb node is OHCI?
> 
> You look for compatible "usb-ohci".

There is no "compatible" there. I can probably use class-code since the
parent is a PCI bus.

> 
> But this doesn't help you.  You do not know yet if the
> problem happens for all usb-ohci; for example, it could be
> that you have the console output device on usb; or as another
> example, it could be that this firmware leaves all pci devices
> in some active state.
> 
> So as I see it you have only two options:
> 
> 1) Figure out what exactly is going on;

I thought we were past that. The startup sequence leaves the device in a bad
state (writing 1000 times per second to memory that the kernel believes is
not in use), so it needs to be given a reset command before the kernel tries
to use that memory.

> > The big question that I'm still stumbling over is how to access the device
> > registers. The "reg" property looks like this:
> 
> You should look at "assigned-addresses", not "reg".  Well,
> you first need to look at "reg" to figure out what entry
> in "assigned-addresses" to use.

The properties look like this:

/pci@80000000/usb@5/assigned-addresses
 02002810 00000000 80000000 00000000 00001000
/pci@80000000/usb@5/reg
 00002800 00000000 00000000 00000000 00000000
 02002810 00000000 00000000 00000000 00001000

I'm not sure how I'm supposed to know which entry from "reg" is the right
one. I've been guessing that it's the second one, since that one matches the
only entry in "assigned-addresses". It's supposed to go the other direction?

-- 
Alan Curry
