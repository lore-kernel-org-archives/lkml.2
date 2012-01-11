Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab2AKP6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:58:06 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:17245 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab2AKP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:58:04 -0500
Message-ID: <4F0DB16B.3010302@atmel.com>
Date: Wed, 11 Jan 2012 16:57:31 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olof Johansson <olof@lixom.net>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, "Wu, Josh" <Josh.wu@atmel.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc
 tree
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au> <Pine.LNX.4.64.1201110933480.1191@axis700.grange> <4F0D65F6.8080209@infradead.org> <201201111450.02798.arnd@arndb.de>
In-Reply-To: <201201111450.02798.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 03:50 PM, Arnd Bergmann :
> On Wednesday 11 January 2012, Mauro Carvalho Chehab wrote:
>> What I and Guennadi agreed (http://linuxtv.org/irc/v4l/index.php?date=2012-01-05)
>> were to do just the reverse:
>>
>> He would be sending you one single patch with my ack, that would allow the 
>> arm tree to be merged [1], I would wait for a few days for the arm tree to
>> be pulled, and then I would rebase my -next tree to remove that patch
>> from it.
>>
>> [1] http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commitdiff/88c6599d97b489ac543fa352159a81f60bddded7
> 
> It's just not what happened. I got this series from Nicolas:
> 
> 7a1834b ARM: at91: Update struct atmel_nand_data to support PMECC
> 9356fba ARM: at91/dma: DMA controller registering with DT support
> 31527e7 ARM: at91/dma: remove platform data from DMA controller
> 226e3aa ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board
> e889a64 ARM: at91: add clock selection parameter for at91_add_device_isi()
> 7a13e73 media i.MX27 camera: Fix field_count handling.
> 166b37f media i.MX27 camera: add support for YUV420 format.
> 88c6599 V4L: atmel-isi: add code to enable/disable ISI_MCK clock
> ... (the rest of v4l at the time)
> 
> and I merged it into the next/drivers2 branch, explaining that I would
> merge these as soon as the dependencies in v4l are merged. :(
> 
>> My -next tree were never meant to be stable. It is just a patch repository
>> where I merge from the real development repository, in order to test them
>> against the hole changes. From time to time, when bad things happen
>> (patch conflicts, compilation breakages, requests to remove bad patches),
>> I just rebase it.
> 
> Ok, thanks for the confirmation.
> 
>> I prefer if you could just pick this patch from Guennadi's tree:
>>  http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commitdiff/88c6599d97b489ac543fa352159a81f60bddded7
>>
>> and add my ack on it, removing the v4l-dvb merge from yours.
>>
>> Linus seems to prefer to have the arch trees merged before the drivers
>> tree, with makes sense.
> 
> I think it's better for you to just send everything you have right away,
> including the atmel-isi patch.
> 
> I'll drop the remaining atmel patches from my next/drivers2 branch and let
> Nicolas send me a new rebased pull request for 3.4. The patches in question
> look simple enough, but if the developers can't get a simple dependency right
> after discussing it for weeks, I'd rather not take it this time.

I am so astonished and sad about all this! I have the feeling of having
done exactly what Guennadi and Olof had asked me to do: What I get at
the end: people having a bad feeling about my work, not expected merge
conflicts which annoy everybody (only for a ridiculous amount of code),
my patches delayed and a comment saying that I cannot handle simple
dependency...
Nice result!

- Guennadi did not want to take SoC/board code in his tree
=> I had to take those lines of code through at91/arm-soc breaking the
   patch series and allowing the introduction of an out-of-sync merge

- I built a pull request with only the SoC/board code on top of a
  Linus' -rc tag (yes, that was breaking compilation on certain
  configurations in the meantime)
=> I was told that I should bring the v4l dependency with my branch

- I resent a "pull request" on top of v4l branch after a discussion
  between Guennadi, Olof and me. The conclusion of this discussion was
  quite obvious:
http://article.gmane.org/gmane.linux.ports.arm.kernel/145196
=> It was supposed to be the last time I moved those patches around...

I have understood and approved all the reasons for the requested
changes, of course. But for which gain?

Ok... well, it looks like a massive incomprehension which took us time
and ends up by wastefulness.

Best regards,
-- 
Nicolas Ferre
