Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab1JNPi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:38:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33664 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1JNPi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAAMvbhFHaX++cX_+CSDHT0Qxf1MeuHnh9oS_rmTHha_fEcMcdQ@mail.gmail.com>
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
	<CA+O4pC+8SbRqRz2uEnG_JkWcPmV_rCsy1zksHYsCk9HKduZRaA@mail.gmail.com>
	<CAAMvbhFHaX++cX_+CSDHT0Qxf1MeuHnh9oS_rmTHha_fEcMcdQ@mail.gmail.com>
Date: Fri, 14 Oct 2011 17:38:26 +0200
Message-ID: <CA+O4pC+MpAORmYVzMsuDkwi9PXbxzssCnVeggNMt9ygSdtNzxQ@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:51 AM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> On 14 October 2011 07:23, Markus Rechberger <mrechberger@gmail.com> wrote:
>> On Fri, Oct 14, 2011 at 7:47 AM,  <Valdis.Kletnieks@vt.edu> wrote:
>>> On Fri, 14 Oct 2011 05:42:44 +0200, Markus Rechberger said:
>>>
>>>> The inflexible device which uses 24064 bytes works with all other
>>>> Operating systems by using that value
>>>> and gives exactly the same results with other transfer sizes than that.
>>>
>>> -ENOPARSE.  If it's inflexible,
>>
>> the particular device in question is inflexible yes.
>>
> Here is what I think the actual situation is.
> Your transfers over the USB are done in 512 Bytes chunks.
> If the device wishes to send 512 bytes, it sends one chunk.
> If the device wishes to send 513 bytes, it sends only one chunk,
> missing one byte.
> if the device wishes to send 1023 bytes, it sends only one chunk,
> missing 511 bytes.
> if the device wishes to send 1024 bytes, it sends two chunks, missing 0 bytes.
> So, the device is sending 1 too few chunks unless the bytes size
> exactly matches the chunk size * n.
> Another constraint is the device sends multiples of 188 bytes.
> So, unless we can find a lowest common multiple of 188 and 512, there
> is no transfer size that will work with this device. The LCM is 24064
> and this is the only value that will work with this device.
>
> Conclusion:
> The hardware on the Linux PC and the kernel on the Linux PC are
> working correctly.
> Your external USB device has an off-by-one error in its
> hardware/embedded software and the hardware/embedded software
> manufacturer is not prepared to fix it.
>
> Workaround in software: Increase MAX from 16384 to 24064 or above.
>
> My own feeling, throw away this faulty bit of hardware and use a different part.
> The hardware is not compatible with USB standards.
>

I agree with that one, and think this conclusion comes closest to the
real issue.
I can imagine that the chip fifo has some issues with that one.
However the device has been tested for a long time without turning to
corrupted data so
the only issue remaining is the buffer alignment.

Thanks for having a look at all that, I wish all requests would have
that kind of review, instead
of "I don't believe you, not acceptable, not right solution at all"

BR,
Markus
