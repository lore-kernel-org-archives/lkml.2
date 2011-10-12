Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1JLVss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:48:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61309 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1JLVsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111012203337.GA14572@suse.de>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
Date: Wed, 12 Oct 2011 23:48:45 +0200
Message-ID: <CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:33 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 12, 2011 at 06:59:01PM +0200, Markus Rechberger wrote:
>> On Wed, Oct 12, 2011 at 4:17 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, Oct 12, 2011 at 02:36:59PM +0200, Markus Rechberger wrote:
>> >> We have 2 products which can perform better with increased Bulk transfers
>> >
>> > I don't believe you :)
>> >
>> > As stated before, this patch is not acceptable.  Please work to figure
>> > out the real reason for your device problems here, this is not the
>> > correct solution at all.
>> >
>>
>> OK no device support for linux then. Windows and MacOSX are fine.
>
> That is your choice, not ours, as you are the one writing the closed
> source code.  Without usbmon dumps, showing that the problem really is
> in the kernel code, we can't do anything for you here.
>


here take your usbmon logs:
http://sundtek.de/support/working.log
http://sundtek.de/support/notworking.log (this is with your proposed
split up of 22k).

Isochronous already supports up to 190kb buffers which cause no
trouble anywhere.
Bulk is castrated to 15kb buffers and 50kb should be such a big issue
while applications
which do not request it are not affected at all.

I'm very angry that you do not really focus on what I write and just
try to write stories about
bogus things like my patch might break other applications while I
pointed out that this is not
possible with legacy applications which use this interface. It is not
even possible to read the
maximum buffer value from the kernelspace.

Your bogus message about 1Gig ram you can put it elsewhere, I checked
multiple windows drivers
in the past the buffer size varies between small and something around
50k usually.
I would fully like to avoid to patch this kernel to get those things
work because I don't want to
deal with people who just write around the actual issues.

Alsi the fact that bigger buffers are already being used plus the HW
specifications of our main device also points out to a certain
buffersize near 50k. But of course you are the smart knowitall without
the need of explanation why
those things can be affected by HW and some HW chips have options to
influence that buffer size.

I'm certainly angry,
Markus

> Best of luck,
>
> greg k-h
>
