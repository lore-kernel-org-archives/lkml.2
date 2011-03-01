Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1CAK4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:56:11 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:36112 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1CAK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:56:09 -0500
Message-ID: <4D6CD10E.3050805@ladisch.de>
Date: Tue, 01 Mar 2011 11:57:18 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible bug, with extreme low latency audio.
References: <op.vrm3n5yy6426ze@millennium>
In-Reply-To: <op.vrm3n5yy6426ze@millennium>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwaysi Bin Kareem wrote:
> I have shaved a kernel for features I suspected to add to os-jitter, to
> get the lowest possible latency from it.
> 
> What happens is, if I set my audioapp, (renoise) to extremely low
> latencies, (96khz, 8 samples buffers x 2), the audio seems to be
> distorting and speeding up, while having periods of normal playback.

I'd guess that buffer is so small that it's smaller than the DMA FIFO
and/or the DMA burst size of the sound device (whatever it is) so that
the DMA controller is not able to accurately report the current position
in the buffer.

Obviously, the lowest possible latency is higher than 167 µs.


Regards,
Clemens
