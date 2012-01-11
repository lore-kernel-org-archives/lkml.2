Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2AKQo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:44:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56229 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2AKQoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:44:23 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <4F0DB16B.3010302@atmel.com>
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
	<Pine.LNX.4.64.1201110933480.1191@axis700.grange>
	<4F0D65F6.8080209@infradead.org>
	<201201111450.02798.arnd@arndb.de>
	<4F0DB16B.3010302@atmel.com>
Date: Wed, 11 Jan 2012 08:44:22 -0800
Message-ID: <CAOesGMhWPLu7cAxjJJaig-eKMFdtJ=zKKbCYp-GL9eHGQsEH4Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, "Wu, Josh" <Josh.wu@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 11, 2012 at 7:57 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> On 01/11/2012 03:50 PM, Arnd Bergmann :
>> On Wednesday 11 January 2012, Mauro Carvalho Chehab wrote:
>>> What I and Guennadi agreed (http://linuxtv.org/irc/v4l/index.php?date=2012-01-05)
>>> were to do just the reverse:
>>>
>>> He would be sending you one single patch with my ack, that would allow the
>>> arm tree to be merged [1], I would wait for a few days for the arm tree to
>>> be pulled, and then I would rebase my -next tree to remove that patch
>>> from it.
>>>
>>> [1] http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commitdiff/88c6599d97b489ac543fa352159a81f60bddded7
>>
>> It's just not what happened. I got this series from Nicolas:
>>
>> 7a1834b ARM: at91: Update struct atmel_nand_data to support PMECC
>> 9356fba ARM: at91/dma: DMA controller registering with DT support
>> 31527e7 ARM: at91/dma: remove platform data from DMA controller
>> 226e3aa ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board
>> e889a64 ARM: at91: add clock selection parameter for at91_add_device_isi()
>> 7a13e73 media i.MX27 camera: Fix field_count handling.
>> 166b37f media i.MX27 camera: add support for YUV420 format.
>> 88c6599 V4L: atmel-isi: add code to enable/disable ISI_MCK clock
>> ... (the rest of v4l at the time)
>>
>> and I merged it into the next/drivers2 branch, explaining that I would
>> merge these as soon as the dependencies in v4l are merged. :(
>>
>>> My -next tree were never meant to be stable. It is just a patch repository
>>> where I merge from the real development repository, in order to test them
>>> against the hole changes. From time to time, when bad things happen
>>> (patch conflicts, compilation breakages, requests to remove bad patches),
>>> I just rebase it.
>>
>> Ok, thanks for the confirmation.
>>
>>> I prefer if you could just pick this patch from Guennadi's tree:
>>>  http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commitdiff/88c6599d97b489ac543fa352159a81f60bddded7
>>>
>>> and add my ack on it, removing the v4l-dvb merge from yours.
>>>
>>> Linus seems to prefer to have the arch trees merged before the drivers
>>> tree, with makes sense.
>>
>> I think it's better for you to just send everything you have right away,
>> including the atmel-isi patch.
>>
>> I'll drop the remaining atmel patches from my next/drivers2 branch and let
>> Nicolas send me a new rebased pull request for 3.4. The patches in question
>> look simple enough, but if the developers can't get a simple dependency right
>> after discussing it for weeks, I'd rather not take it this time.
>
> I am so astonished and sad about all this! I have the feeling of having
> done exactly what Guennadi and Olof had asked me to do: What I get at
> the end: people having a bad feeling about my work, not expected merge
> conflicts which annoy everybody (only for a ridiculous amount of code),
> my patches delayed and a comment saying that I cannot handle simple
> dependency...
> Nice result!

Personally, I don't blame you in this case, you're the victim.

> - Guennadi did not want to take SoC/board code in his tree
> => I had to take those lines of code through at91/arm-soc breaking the
>   patch series and allowing the introduction of an out-of-sync merge

It was actually me who said we prefer to take the board code through
arm-soc, and given how conflict-ridden this merge window has been, I
think that has been a good decision. Otherwise even more conflicts
would have needed to be resolved at Linus' pulls, and while he's OK
with doing some of them, we should still try to keep them at a
reasonable level.

> - I built a pull request with only the SoC/board code on top of a
>  Linus' -rc tag (yes, that was breaking compilation on certain
>  configurations in the meantime)
> => I was told that I should bring the v4l dependency with my branch

This is where things broke down. The one thing I told Guennadi was
that the branch that we merge in *must not be rebased*. In hindsight,
I should have asked him to stage a minimal topic branch with _just_
the patches you needed, and pulled that in as the dependency instead
of the whole v4l tree.

> - I resent a "pull request" on top of v4l branch after a discussion
>  between Guennadi, Olof and me. The conclusion of this discussion was
>  quite obvious:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/145196
> => It was supposed to be the last time I moved those patches around...

Yep. The main problem is that the branch was not stable. Not your fault.

> I have understood and approved all the reasons for the requested
> changes, of course. But for which gain?
>
> Ok... well, it looks like a massive incomprehension which took us time
> and ends up by wastefulness.

If you prepare a branch with just your changes, I'll pull it in as a
late/* branch and we can try to get it merged in for 3.3. That
requires that Mauro gets his pull done with enough margin to get our
late merge request sorted out and sent in though. I.e. his tree would
need to go in soon, not next week right before the window closes.


-Olof
