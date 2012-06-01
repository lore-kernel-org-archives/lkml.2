Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab2FAINt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:13:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57950 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab2FAINq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120531104538.GA2666@opensource.wolfsonmicro.com>
References: <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
	<20120523093857.GC4085@opensource.wolfsonmicro.com>
	<CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
	<20120524100742.GH5361@opensource.wolfsonmicro.com>
	<CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
	<1337941231.1580.19.camel@vkoul-udesk3>
	<20120527221956.GB25019@opensource.wolfsonmicro.com>
	<CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
	<20120530121449.GI9947@opensource.wolfsonmicro.com>
	<CANKRQni4uqQJ99ycOScHmn-g1kz2_XH7ePL+n1taG5jAbDSubw@mail.gmail.com>
	<20120531104538.GA2666@opensource.wolfsonmicro.com>
Date: Fri, 1 Jun 2012 17:13:45 +0900
Message-ID: <CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 7:45 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > Please re-read what I wrote.
>
>> Let me clarify.
>> Do you say native DMA driver API like dmaengine_prep_slave_sg(),
>> dmaengine_submit() shouldn't be used from ASoC driver, right ?
>
> Your driver should be written in terms of the ASoC DMA framework.

I understand your order.
But isn't it only me ?
You mean all ASoC driver uses dmaengine should be written in terms of
the ASoC DMA framework.
Right ?

>> > No, all current mainline drivers using the library use cyclic DMA.
>> I can't see any driver uses cyclic DMA. (I saw linux-next's tree from
>> kernel.org.)
>> Where is your saying "current mainline" ?
> Linus' tree, or mine.

Sorry, I couldn't find.
Is your saying Linus's tree this ?
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
However, any ASoC driver doesn't use cyclic DMA's.


> Have you even looked at the soc-dmaengine-pcm
> code?  It uncondtionally requests a cyclic channel.

I already saw soc-dmaengine-pcm.c

>> However I think it seems difficult for supporting all devices.
>> Because hardware dependency control code can't be added.
>> For example, for ML7213, needs interrupt control both before/after DMA transfer.
>> However,  in case of using soc-dmaengine, the control can't be done.
>> Because the processing is in soc-dmaengine.
> Please be more specific.  What are the concrete problems that you see?
> Why is it not possible to address them within the framework?

I show the code.
+static void i2s_dma_tx_complete(void *arg)
+{
...

+
+       ioh_i2s_irq_ctrl(ioh->number, SNDRV_PCM_STREAM_PLAYBACK,
IOH_EN_IRQ);   ##<<Interrupt control
+}

Our device needs interrupt control both before/after DMA transfer like above.
In your soc-dma-engine, DMA transfer complete code is in soc-dma-engine, right ?
So, the vendor specific code like the above can't be written.

thanks.
-- 
ROHM Co., Ltd.
tomoya
