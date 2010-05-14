Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0ENARM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:17:12 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:64011 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0ENARJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ooK8zqY623+Q0E2aGVr4bRoQ4SrYxGpNDz1D9G0iNrsmnv8sWuxUGBWj1xlh9UR4j7
         /igHKX+M3Jd5E1WRG25DuaOyXvQG0vnDNayxioVVk0JeRwiJLXOgBvr5gRaqlRdU6V36
         d5dZa0tvbZW1lV3GODwWOt08o7y4Og0A9670k=
MIME-Version: 1.0
In-Reply-To: <20100513093655.GG30801@buzzloop.caiaq.de>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
	 <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
	 <20100511171025.GB30801@buzzloop.caiaq.de>
	 <AANLkTimdsIJt69TKf2CgXjEXDJXSNib2jt9JSapmuJyW@mail.gmail.com>
	 <20100511173830.GF30801@buzzloop.caiaq.de>
	 <AANLkTinTOWZbZ_7n6YEcCgjbh1_Jsj2_zRKKwspAMuwE@mail.gmail.com>
	 <20100513093655.GG30801@buzzloop.caiaq.de>
Date: Fri, 14 May 2010 01:17:06 +0100
Message-ID: <AANLkTinJpBJwnSR1lIL8ubWTggKGs84XgzsKLnSYwsJp@mail.gmail.com>
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

On 13 May 2010 10:36, Daniel Mack <daniel@caiaq.de> wrote:
> On Thu, May 13, 2010 at 12:50:48AM +0100, Pedro Ribeiro wrote:
>> On 11 May 2010 18:38, Daniel Mack <daniel@caiaq.de> wrote:
>> > On Tue, May 11, 2010 at 06:32:50PM +0100, Pedro Ribeiro wrote:
>> >> On 11 May 2010 18:10, Daniel Mack <daniel@caiaq.de> wrote:
>> >> > No surprise here. The 4 channels are mux'ed in an interleaved fashion,
>> >> > so if the buffers contain rubbish, you will hear artefacts on all
>> >> > channels.
>> >>
>> >> So what would be the testcase you would like me to try?
>> >
>> > Would be good to see what happens if you could record audio (with
>> > arecord would be sufficient), just to see whether the same problem
>> > exists in the other direction.
>> >
>> > Either record an externally generated sine tone and open the resulting
>> > wave file in an editor. With the amount of artefacts you describe, they
>> > should easily be visible.
>>
>> Ok let me see if I got this straight:
>>
>> I should record some sound with the audio card and see if it impacts
>> the recording? May take me a few days, I need to get a microphone or
>> something like that borrowed.
>
> Yes, exactly.
>
>> > Another option is to play back any kind of recorded audio thru an audio
>> > device that does not show the problem (some internal, onboard device?).
>> >
>>
>> What do you mean by this? I didn't get it. I usually use my onboard
>> intel HDA for listening to music and have no problems.
>
> I was just thinking of a way to judge whether the recording is affected.
> And probably the best way is to listen to it :)
>
> Daniel
>

Just tested it and nothing is happening on the input channels.
Actually as I said above, I can actually see the interference, and its
all across all 4 output channels (the leds light up) but not across
any input channel. A video speaks more, and I should have done it
before.

http://www.mediafire.com/file/gtqed3zjgd2/audio4dj-bug.ogg
(8 megs, 1 min, ogg theora)

Unfortunately I was too stupid to remember to do a close up, but those
4 leds you see lighting up are output channels 1,2,3,4. Input channels
1,2,3,4 are clean, nothing happens there. The other light that does
not flash is the USB status light.

Hope this helps!

Regards,
Pedro
