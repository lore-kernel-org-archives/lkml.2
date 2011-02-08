Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1BHKoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:44:14 -0500
Received: from mail1.perex.cz ([77.48.224.245]:38805 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1BHKoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:44:13 -0500
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Feb 2011 05:44:13 EST
Date: Tue, 8 Feb 2011 11:21:11 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: Knut Petersen <Knut_Petersen@t-online.de>
cc: tiwai@suse.de, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: ALSA: Reasonable buffer size / where should it be implemented?
In-Reply-To: <4D511552.7030409@t-online.de>
Message-ID: <alpine.LNX.2.00.1102081109170.6272@eeebox2.perex-int.cz>
References: <4D511552.7030409@t-online.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Knut Petersen wrote:

> I use a RME Digi 96 PAD audio card, and I do have
> buffer overrun/underrun problems if I use the standard
> rme96c linux driver.
>
> I need a simple recording machine. It should not fail if
> e.g. cron starts updatedb or if I start a make -j 15 icecream
> compile job and decide to surf the internet while I record
> the digital satellite radio 48kHz stream.

I would determine the culprit where the user space blocks. If you write 
data to HDD, the culprit is probably there, in my opinion. The current 
PC machines can handle 82ms latencies quite well.

A right behaving application should do the quick audio sample reads to a 
big buffer and queue these data to HDD in a separate thread to not block 
the audio input.

> There is a lot of information about xrun problems, but
> somehow that information either does not help to prevent
> xruns on my system, is outdated, or asks for system
> changes I do not accept.
>
> No, JACK does not help. No, I do not need low latency.
> No, I don't want to switch to rt kernels. No, I don't want
> to use an audio PC without X, without cron, network, etc.
>
> The hardware provides independent 64k ringbuffers for
> capture and playback, that's not more than 85msec for a
> 96 kHz / 2 channel / 32 bit setup or ADAT. That's simply
> not enough for reliable operation.
>
> My private solution is a rme96.c that kmallocs  4 MB
> software buffers for capture and playback, data transfer
> between software and hardware buffer in the interrupt
> service routine. That does efficiently prevent xruns even
> on a really loaded system.
>
> But I don't know if that is the right way to go.

It's probably the right way to go. I would only copy data in a tasklet not 
directly in the interrupt routine. New hardware (like HDA) have 
scatter-gather DMA buffers with almost unlimited size, so users can just 
tune the system up.

 					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

