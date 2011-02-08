Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1BHKFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:05:23 -0500
Received: from mailout07.t-online.de ([194.25.134.83]:52810 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1BHKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:05:22 -0500
Message-ID: <4D511552.7030409@t-online.de>
Date: Tue, 08 Feb 2011 11:05:06 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: perex@perex.cz
CC: tiwai@suse.de, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: ALSA: Reasonable buffer size / where should it be implemented?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: TiVsjOZUwh8iY2H1JfHJ4yNSFig0-ok-8vkNwKpoPTDCwvQhKCmdXqLGo-yVjzrwGh
X-TOI-MSGID: 241d286f-9296-44f3-9950-f9f57423c7f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use a RME Digi 96 PAD audio card, and I do have
buffer overrun/underrun problems if I use the standard
rme96c linux driver.

I need a simple recording machine. It should not fail if
e.g. cron starts updatedb or if I start a make -j 15 icecream
compile job and decide to surf the internet while I record
the digital satellite radio 48kHz stream.

There is a lot of information about xrun problems, but
somehow that information either does not help to prevent
xruns on my system, is outdated, or asks for system
changes I do not accept.

No, JACK does not help. No, I do not need low latency.
No, I don't want to switch to rt kernels. No, I don't want
to use an audio PC without X, without cron, network, etc.

The hardware provides independent 64k ringbuffers for
capture and playback, that's not more than 85msec for a
96 kHz / 2 channel / 32 bit setup or ADAT. That's simply
not enough for reliable operation.

My private solution is a rme96.c that kmallocs  4 MB
software buffers for capture and playback, data transfer
between software and hardware buffer in the interrupt
service routine. That does efficiently prevent xruns even
on a really loaded system.

But I don't know if that is the right way to go.

Wouldn't  it be better if there would be an (optional) software
buffer one layer above the hardware driver? That would
increase reliability for all audio hardware with insufficient
hardware buffers.

Is there any other audio hardware with similar small
buffers?

Has somebody already written an "extended alsa buffer"
patch? Did I miss something?

To put it into one question: How much buffer should be
provided by an alsa hardware driver module?

cu,
 Knut
