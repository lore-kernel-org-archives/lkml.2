Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1JMJ3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:29:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37505 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1JMJ3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAHFNz9JUV6wabQxsvrxPRX6q41sWNMDy8DJcOpNTecNTbL=XaQ@mail.gmail.com>
	<CA+O4pCJ2gDicdC7BbCbo0m3xdCX0cdhY-Azn9aqu6+C58u0kgQ@mail.gmail.com>
	<CAHFNz9+a4PjsAoBYF-bJ9nSOzNtEVq23UJzxSTxo=fdmSGOJPw@mail.gmail.com>
	<CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
Date: Thu, 13 Oct 2011 11:29:44 +0200
Message-ID: <CA+O4pCL8PSyfSV+8eNTspicqfad96Z=NXhE0n-wYeKVgJOJrGg@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:37 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Thu, Oct 13, 2011 at 7:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> On Thu, Oct 13, 2011 at 10:29 AM, Markus Rechberger
>> <mrechberger@gmail.com> wrote:
>>> On Thu, Oct 13, 2011 at 6:03 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>> Hello Markus,
>>>>
>>>> On Thu, Oct 13, 2011 at 3:39 AM, Markus Rechberger
>>>> <mrechberger@gmail.com> wrote:
>>>>> On Wed, Oct 12, 2011 at 11:48 PM, Markus Rechberger
>>>>> <mrechberger@gmail.com> wrote:
>>>>>> On Wed, Oct 12, 2011 at 10:33 PM, Greg KH <gregkh@suse.de> wrote:
>>>>>>> On Wed, Oct 12, 2011 at 06:59:01PM +0200, Markus Rechberger wrote:
>>>>>>>> On Wed, Oct 12, 2011 at 4:17 PM, Greg KH <gregkh@suse.de> wrote:
>>>>>>>> > On Wed, Oct 12, 2011 at 02:36:59PM +0200, Markus Rechberger wrote:
>>>>>>>> >> We have 2 products which can perform better with increased Bulk transfers
>>>>>>>> >
>>>>>>>> > I don't believe you :)
>>>>>>>> >
>>>>>>>> > As stated before, this patch is not acceptable.  Please work to figure
>>>>>>>> > out the real reason for your device problems here, this is not the
>>>>>>>> > correct solution at all.
>>>>>>>> >
>>>>>>>>
>>>>>>>> OK no device support for linux then. Windows and MacOSX are fine.
>>>>>>>
>>>>>>> That is your choice, not ours, as you are the one writing the closed
>>>>>>> source code.  Without usbmon dumps, showing that the problem really is
>>>>>>> in the kernel code, we can't do anything for you here.
>>>>>>>
>>>>>>
>>>>>>
>>>>>> here take your usbmon logs:
>>>>>> http://sundtek.de/support/working.log
>>>>>> http://sundtek.de/support/notworking.log (this is with your proposed
>>>>>> split up of 22k).
>>>>>>
>>>>>> Isochronous already supports up to 190kb buffers which cause no
>>>>>> trouble anywhere.
>>>>>> Bulk is castrated to 15kb buffers and 50kb should be such a big issue
>>>>>> while applications
>>>>>> which do not request it are not affected at all.
>>>>>>
>>>>>> I'm very angry that you do not really focus on what I write and just
>>>>>> try to write stories about
>>>>>> bogus things like my patch might break other applications while I
>>>>>> pointed out that this is not
>>>>>> possible with legacy applications which use this interface. It is not
>>>>>> even possible to read the
>>>>>> maximum buffer value from the kernelspace.
>>>>>>
>>>>>> Your bogus message about 1Gig ram you can put it elsewhere, I checked
>>>>>> multiple windows drivers
>>>>>> in the past the buffer size varies between small and something around
>>>>>> 50k usually.
>>>>>> I would fully like to avoid to patch this kernel to get those things
>>>>>> work because I don't want to
>>>>>> deal with people who just write around the actual issues.
>>>>>>
>>>>>> Alsi the fact that bigger buffers are already being used plus the HW
>>>>>> specifications of our main device also points out to a certain
>>>>>> buffersize near 50k. But of course you are the smart knowitall without
>>>>>> the need of explanation why
>>>>>> those things can be affected by HW and some HW chips have options to
>>>>>> influence that buffer size.
>>>>>
>>>>> And for those who are curious about the logfiles:
>>>>> Not working one as proposed by Alan that the full buffer size should
>>>>> be split into 2 requests:
>>>>>
>>>>> ffff8800b38d9f00 1231540351 S Bi:2:013:1 -115 12288 <
>>>>> ffff8800b38d96c0 1231540404 S Bi:2:013:1 -115 11776 <
>>>>> ffff8800b38d9cc0 1231540440 S Bi:2:013:1 -115 12288 <
>>>>> ffff880002ede600 1231540496 S Bi:2:013:1 -115 11776 <
>>>>> ffff8800b38d9f00 1231545491 C Bi:2:013:1 0 12288 = 7a1a0840 1ca8353c
>>>>> 004b80ec 4de08401 2f0227f8 34005e7e 80181dfd 1a8f700a
>>>>> ffff88007d51fb40 1231545875 S Bi:2:013:1 -115 12288 <
>>>>> ffff8800b38d96c0 1231551861 C Bi:2:013:1 0 11776 = 5244e386 a7800000
>>>>> 010642ea 35bfbba5 373e738b cc035a73 c328a1ff 4da728ce
>>>>> ffff880002ede0c0 1231556173 S Bi:2:013:1 -115 11776 <
>>>>> ffff8800b38d9cc0 1231558618 C Bi:2:013:1 0 12288 = db91aae9 2d2532f3
>>>>> 2e37448a fb36c213 55dda2ad 243122b2 261edb06 875848ac
>>>>>
>>>>>
>>>>> 12288 = 7a1a0840 every Line with 12288 should start with 47 (MPEG-TS Sync byte)
>>>>>
>>>>> The working one which allocate 7000 bytes more (oh really big memory
>>>>> pressure now!)  than this castrated USBFS interface allows.
>>>>>
>>>>> ffff88003ac37240 992178919 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37000 992178953 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37c00 992178980 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37e40 992179003 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37240 992190198 C Bi:2:013:1 0 24064 = 471fff10 00000000
>>>>> 00000000 00000000 00000000 00000000 00000000 00000000
>>>>> ffff88000601f480 992194368 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37000 992203209 C Bi:2:013:1 0 24064 = 4701b114 43867ee6
>>>>> 40790660 e898681c 9b1c7dca 08980d43 73181369 9be1bc67
>>>>> ffff880067e38a80 992204642 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37c00 992216318 C Bi:2:013:1 0 24064 = 4740001c 0000b01d
>>>>> 0305d500 000000e0 104015e1 504016e1 60401be1 b04022e2
>>>>> ffff880067e383c0 992219978 S Bi:2:013:1 -115 24064 <
>>>>> ffff88003ac37e40 992229340 C Bi:2:013:1 0 24064 = 471fff10 00000000
>>>>> 00000000 00000000 00000000 00000000 00000000 00000000
>>>>>
>>>>> everything starts nicely with 0x47
>>>>
>>>> Is the transfer size a multiple of 188 bytes in both cases ? In the
>>>> working case, it looks so, but in the broken case ? Many DTV bridges
>>>> have fixed DMA apertures and not variable really much, even though the
>>>> device specifications do state that it might support different block
>>>> sizes, some modes could be broken. I guess most likely, you would have
>>>> handled this situation.
>>>>
>>>> Other issues that could possibly happen (wrt your jitter) is a high
>>>> latency (in the particular case of failures) where the received data
>>>> have unusable relative timestamps wrt DTS and or PTS.
>>>>
>>>> The only areas where you can have a corrupted stream as you mentioned
>>>> "jitter" is either lost frames or the above two cases. I don't know
>>>> what's the issue in your case, but might help to track down the issue
>>>> altogether.
>>>>
>>>
>>> I am not so sure about that one but I guess that's it.
>>> The 'black outs (0xff after the Sync byte)' are also related to the
>>> demodulator (not perfect signal, it's still DVB-T) but
>>> the alignment is just perfect
>>> I also guess the misaligning problem could be related to the latency
>>> and that the bridges have some
>>> fixed or adjustable bulk transfer settings to work with that. In the
>>> end the additional features
>>> are done with software demodulation so there will be a certain minimal
>>> system requirement anyway.
>>>
>>
>>
>> I guess you meant to imply "software decoding" of the MPEG stream I
>> would say, rather than "demodulation" of the Baseband signal.
>>
>>
>>> What would be against that theory would be that 2*that maximum
>>> transfer size also results in a misaligned
>>> video. Since I tried many other transfer sizes before I've been told
>>> to use that one and I even thought the
>>> device is broke but it just works that way... also with Windows and MacOSX.
>>> As far as I can tell for user experience the device is okay with 24064 bytes.
>>>
>>> TV has been running for several days now with no issues (I was also
>>> testing the ts 'blackouts' where data
>>> after the sync byte 0x47 is 0xff on weak signal, the TS sync byte
>>> itself is still valid)
>>
>> I have had such an issue earlier (0x47 followed 0xff. ie 0x47 0x1f 0xf
>> 0x00 0x00 0x00 and so on) with a stream from the demodulator on a PCIe
>> device, but eventually it turned out to be that, it was handling the
>> device DMA in the reverse order, the device having 8 DMA apertures of
>> which all 8 had to be used for stream transfer.
>>
>> RING(W) : Buf:2 Tail: 2 Count:0 Size:16
>> RING(R): Buf:2 Head: 2 Count:! Size: 16
>> 47 If ff 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>
>> Additionally, to be noted is that the ISO13818-1 specification allows
>> NULL padding of the TS by the channel modulator to achieve a CBR, from
>> VBR ES's. There exists an ETSI specification dealing with NULL padding
>> explicitly, don't remember the exact TR no.
>>
>> After a search, EN 302755 v1.1.1 Section 5.1.5 deals with that, A
>> quick glance at least wrt to T2, I remember the same while I was
>> working with S2 as well.
>>
>> All such issues mixed when together can be very nasty and painful,
>> making things difficult.
>>
>
> yes the PID is 0x1fff which are null packets over there, so those ones are okay.
> Main point is it works and it would even comply with certain HW specs (the other
> device points out about 256*188 bulk transfer buffer sizes.
>
> Now it would be the time for some people to open their eyes and get
> that patch in.
> The maximum transfer buffer size was derived from our other device which can
> do the flexible setting. According to the specification it is no magic value.
>
> And seriously increasing that current limitation for a few more bytes
> while isochronous
> already allows up to 190k is just a joke, we have been using that for
> 3 years now on
> x86, ARM, MIPS without any problem. The biggest problem is usually
> when the memory
> runs out in general by writing a log file to ram via /tmp or /var/log.
> But even then we have system logs where other drivers fail first (eg.
> ethernet) and complain
> about not enough memory.
>

Some demonstration video:
(with 24064 bytes, which uses the additional buffers which are allowed
by the introduced patch):
Flawlessly video:
http://www.sundtek.de/support/00011.MTS

(Alan's proposed buffer size 11776/12288)
Jerky video:
http://www.sundtek.de/support/00012.MTS

both videos are around 30 seconds made with a camera, video is still uploading.
this is my last post to that topic I still have some little hope that
this patch will get in to fix that issue.
As proposed for academic research you can pick up a Stick in Berlin
once the new cut is ready from manufacturing,

Markus
