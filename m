Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1JNGXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:23:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40785 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1JNGXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <79856.1318571233@turing-police.cc.vt.edu>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAAMvbhFNTQeuJBgsDB9Y5ODc_b2O0X=oP_3uwRpWUREFS9qufA@mail.gmail.com>
	<CA+O4pCK2=rjqufLetTd=419bDfkN6RRX89Sh5noDnjoBAgoR2A@mail.gmail.com>
	<CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
	<79856.1318571233@turing-police.cc.vt.edu>
Date: Fri, 14 Oct 2011 08:23:10 +0200
Message-ID: <CA+O4pC+8SbRqRz2uEnG_JkWcPmV_rCsy1zksHYsCk9HKduZRaA@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 7:47 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 14 Oct 2011 05:42:44 +0200, Markus Rechberger said:
>
>> The inflexible device which uses 24064 bytes works with all other
>> Operating systems by using that value
>> and gives exactly the same results with other transfer sizes than that.
>
> -ENOPARSE.  If it's inflexible,

the particular device in question is inflexible yes.

> how did you get results for other transfer
> sizes?

other transfer sizes are related to another more flexible device, but that
device has some hardware register to modify the needed transfer buffer size.

> And if other transfer sizes give exactly the same results, why can't you
> just use those instead?
>

other transfer sizes for the device with the fixed transfer buffer
size give exactly the same result with OSX, meaning that it also
does not work on MacOSX with another size than 24064 bytes.

Final conclusion is still:
1. those people who used to deal with USB with linux in the past never
heard about such an option it seems, fact is that the stream corrupts
the logfiles show up damaged data before it arrives to the application
so on that side bugs in the application would be unrelated. As a
crosscheck I also posted a logfile with valid data.
2. the more flexible device even has hardware registers to modify the
bulk transfer size (maybe it's a timing related issue on the physical
usb bus).
3. if the more flexible device is set to buffers > 16k the data also corrupts
4. the fixed buffer size device does not accept any other values, even
twice that requested buffersize corrupts the data.
5. the patch does not hurt, since devices which request buffer sizes
below 16k will still be handled the same way as they were handled
during the last 10 years, it just allows applications to request
bigger buffers if needed.
6. BOTH of our devices (the flexible one device A, can work with
bigger buffers AND a bigger HW register configuration, device B which
is not so flexible also works flawlessly as seen in the video).

I'm repeating myself over and over here.

Markus
