Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936534Ab0GSShl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:37:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49580 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936511Ab0GSShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:37:15 -0400
Date: Mon, 19 Jul 2010 14:37:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf3o6v067p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007191428290.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> On Mon, 19 Jul 2010 19:06:32 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> 1/3: http://lkml.org/lkml/2010/7/8/317
> 
> > Ah, yes.  My personal taste would be to write fsg_string_serial_fill_n
> > as an inline routine instead of as a macro, and not try to make it
> > separate from fsg_string_serial_fill.
> 
> >> 2/3: http://lkml.org/lkml/2010/7/8/318
> 
> > I have only one objection to this patch: The new parameter's name
> > should be "serial", not "serial_parm".  (Compare it to all the other
> > parameter names.)
> 
> Will change the two tomorrow.

Come to think of it, there was one other issue.  The serial number
parameter is important enough that it should be available even on
builds without CONFIG_USB_FILE_STORAGE_TEST (because for general use,
we must make it possible to set the serial number to a unique value for
every instance of the gadget).  Moving the code around should be fairly
easy.

Alan Stern

