Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab0GTPC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:02:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55066 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758194Ab0GTPC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:02:28 -0400
Date: Tue, 20 Jul 2010 11:02:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf5cd0ap7p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007201059150.1631-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> I wanted to keep fsg_string_serial_fill() as a macro so that it can
> use ARRAY_SIZE() on the first argument to check the size.  If there
> was a single function it would have to explicitly take the length of
> the destination array as an argument -- that's what the *_n() function
> is for.
> 
> The rationale is that not having to use ARRAY_SIZE() is, well,
> simpler. ;)

My advice is don't bother.  Let callers give explicitly the size of 
their buffer.  How many other routines in the kernel do an implicit 
ARRAY_SIZE on behalf of their callers?  What if the buffer is passed as 
a pointer instead of as an array?

> Basically, what you are proposing is to remove the
> fsg_string_serial_fill() macro and leave only the *_n() changed to
> an inline function and force all callers use sizeof/ARRAY_SIZE().

Or determine the size in some other way.  Yes.  (And then remove the 
"_n" from the name since it will be unnecessary.)

> Am I getting that right?  Personally, I'd leave things like they are
> changing the *_n() to a function.  What do you think?

See above.

Alan Stern

