Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0EKRcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:32:54 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:41246 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EKRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UU4TOsHqNvjSGJ48Tz9y3K4OT1xZ5BgCYLBttsPz5NbC6nSxv4tILbGraKmTaFEknt
         QBUvP5xCU6Fqy50RlfxNU0tButXdDqmLyE1rl0A6ywV/DKHawoA+aJRirxc7qvMPZLgh
         kMmEC5+sivnPx+FbqmUtquqgGnDN/TUYGCACI=
MIME-Version: 1.0
In-Reply-To: <20100511171025.GB30801@buzzloop.caiaq.de>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
	 <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
	 <20100511171025.GB30801@buzzloop.caiaq.de>
Date: Tue, 11 May 2010 18:32:50 +0100
Message-ID: <AANLkTimdsIJt69TKf2CgXjEXDJXSNib2jt9JSapmuJyW@mail.gmail.com>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, gregkh@suse.de,
       konrad.wilk@oracle.com, tiwai@suse.de,
       USB list <linux-usb@vger.kernel.org>, clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2010 18:10, Daniel Mack <daniel@caiaq.de> wrote:
> On Tue, May 11, 2010 at 05:48:11PM +0100, Pedro Ribeiro wrote:
>> I'm clueless about the whole underlying process but I don't think it
>> is related to playing a file from the disk or another USB device.
>>
>> I don't need to play any file for this interference to be heard - I
>> just need to "open" the device. By this I mean that if I create a JACK
>
> ... which will stream zeros. Sure, that should also trigger the bug
> then.
>
>> server or if I open the device using the ALSA backed in a program like
>> Mixxx I immediately start hearing the cracks and pops in the speaker.
>> But to answer your question, playing a file from the hard drive using
>> aplay I can also hear the interference - but only when the sound is
>> playing. As soon as the sound stops and the audio device is "closed",
>> no interference occurs.
>
> Yes, because the stream is stopped, pending URBs are unlinked etc.
> That's completely expected.
>
>> However, when using the JACK server, which probably opens and polls
>> the audio card constantly (its a low latency audio server) I don't
>> even need to be playing any sound for the interference to be constant.
>
> That shouldn't affect the driver itself but just put the ALSA core under
> pressure.
>
>> I can also see it since I have 4 output leds in the USB audio card and
>> even if I'm only using 2 channels, the 4 channel leds light up with
>> interference as the sound cracks and pops.
>
> No surprise here. The 4 channels are mux'ed in an interleaved fashion,
> so if the buffers contain rubbish, you will hear artefacts on all
> channels.
>
> Daniel
>
>

So what would be the testcase you would like me to try?

Pedro
