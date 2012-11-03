Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2KCQfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:35:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54785 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757245Ab2KCQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:35:44 -0400
Date: Sat, 3 Nov 2012 12:35:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 3.7-rc3
In-Reply-To: <CA+55aFx+w2hFifGTr_u76D9d_sDKxKJBDd2L4p0GVk-RXCczMA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1211031225100.17692-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Linus Torvalds wrote:

> On Fri, Nov 2, 2012 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Well, not everything is rosy in the suspend land, though.  This is a
> > failure to freeze khubd during the second in a row attempt to suspend to
> > RAM (your current tree):
> 
> Ugh. So khubd is blocked in usb_start_wait_urb(), and apparently the
> timeout for that block is longer than the freezing timeout.
> 
> There's a comment about why khubd needs to be freezable, but I wonder
> if that whole thing isn't doing something wrong. Causing the suspend
> to fail is definitely always the wrong thing.

khubs has been a potential problem for suspend since the beginning.

The USB spec mandates timeouts of 5 seconds.  In addition, khubd does
lots of retries when errors occur (probably way too many) and checks
for freezability only when its to-do list is empty.

Under normal circumstances this isn't a problem.  Issues arise when a 
non-cooperative device is plugged in shortly before a suspend starts.

I suppose we could scatter a whole bunch of checks at spots throughout 
the device-initialization code.  This seems awkward but I can't think 
of anything better.  Does anyone have other suggestions?

Alan Stern

