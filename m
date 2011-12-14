Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1LNN6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:58:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:23021 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab1LNN6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:58:18 -0500
Message-ID: <4EE8AB76.6040202@imgtec.com>
Date: Wed, 14 Dec 2011 13:58:14 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Neil <neil.jones@imgtec.com>
Subject: Re: bugs in "ASoC: core - Optimise and refactor pcm_new() to pass
 only rtd"?
References: <4EE89A06.80101@imgtec.com> <20111214133448.GD25088@sirena.org.uk>
In-Reply-To: <20111214133448.GD25088@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2011 13:58:14.0542 (UTC) FILETIME=[6C6E12E0:01CCBA68]
X-SEF-Processed: 7_3_0_01158__2011_12_14_13_58_15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 01:34 PM, Mark Brown wrote:
> On Wed, Dec 14, 2011 at 12:43:50PM +0000, James Hogan wrote:
> 
>> I've bisected a problem with an out of tree set of asoc drivers down to commit
>> 552d1ef6b5a98d7b95959d5b139071e3c90cebf1 ("ASoC: core - Optimise and refactor
>> pcm_new() to pass only rtd"). By the looks of it this change was intended not 
>> to change the workings of the code, however the dai parameter of pcm_new used
>> to be passed codec_dai in soc_new_pcm() (initialised from rtd->codec_dai), but
>> each driver now sets it's dai to rtd->cpu_dai instead. This seems to make the
>> driver check the wrong dai's driver->capture.channels_min in the pcm_new
>> callback, which makes it dereference
>> pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream in the driver's
>> preallocate_dma_buffer() function which can be NULL. Is this a bug (in every
>> pcm asoc driver) that just happens not to have been noticed, or have I
>> misunderstood it?
> 
> Your drivers should never have beenn relying on this behaviour of the
> core - see changes in the pxa and fsl drivers which remove similar
> assumptions.  The CPU driver should be checking for the substream if
> it's looking to see if a particular substream is present, not peering
> inside the DAI for a random parameter.

Thanks Mark, we were basing our drivers on one of the other ones (I
think the atmel one, which still seems to do it as of v3.2-rc4).

Cheers
James

