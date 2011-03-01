Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1CAQ7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:59:32 -0500
Received: from smtp.getmail.no ([84.208.15.66]:50319 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab1CAQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:59:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: Possible bug, with extreme low latency audio.
References: <op.vrm3n5yy6426ze@millennium> <4D6CD10E.3050805@ladisch.de>
Date: Tue, 01 Mar 2011 17:59:27 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vrob5de16426ze@millennium>
In-reply-to: <4D6CD10E.3050805@ladisch.de>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Mar 2011 11:57:18 +0100, Clemens Ladisch <clemens@ladisch.de>  
wrote:

> Uwaysi Bin Kareem wrote:
>> I have shaved a kernel for features I suspected to add to os-jitter, to
>> get the lowest possible latency from it.
>>
>> What happens is, if I set my audioapp, (renoise) to extremely low
>> latencies, (96khz, 8 samples buffers x 2), the audio seems to be
>> distorting and speeding up, while having periods of normal playback.
>
> I'd guess that buffer is so small that it's smaller than the DMA FIFO
> and/or the DMA burst size of the sound device (whatever it is) so that
> the DMA controller is not able to accurately report the current position
> in the buffer.
>
> Obviously, the lowest possible latency is higher than 167 µs.

Actually I have to different audiocards here. The one with the problem is  
an nvidia onboard soundchip.
It seems to behave like this, with my current .config, with latencies  
below 1 ms. With an unshaved earlier .config, on 2.6.33, latencies would  
not go below 1 ms on this card, but the audio would become noisy and  
distorted. On 2.6.36 this has changed to 0.5ms. And shaving the kernel,  
allows one to go even lower.

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev  
a2)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f9ff8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

The other is a firewire device (Konnekt24d using FFADO, running on the old  
firewire stack).
The firewire device actually plays nicely without much buffer underruns  
down to 0.363 ms latency (8x2 @ 44.1k).
However it seems to choke at 8x2 @ 96k. Glitching, because of buffer  
underruns aren't the main problem here either, but the sound will  
disappear for large amounts of time.
