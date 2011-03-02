Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1CBH1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:27:43 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48535 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816Ab1CBH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:27:41 -0500
X-Sasl-enc: PmHd7LpngxBFII18Mwncuwdj4vTWggt3RN2D3HPwkLd3 1299050860
Message-ID: <4D6DF1B2.2010500@ladisch.de>
Date: Wed, 02 Mar 2011 08:28:50 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible bug, with extreme low latency audio.
References: <op.vrm3n5yy6426ze@millennium> <4D6CD10E.3050805@ladisch.de> <op.vrob5de16426ze@millennium>
In-Reply-To: <op.vrob5de16426ze@millennium>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwaysi Bin Kareem wrote:
> The other is a firewire device (Konnekt24d using FFADO, running on the old
> firewire stack).
> The firewire device actually plays nicely without much buffer underruns
> down to 0.363 ms latency (8x2 @ 44.1k).

FireWire packets are sent every 125 µs; for audio, every packet contains
either zero or eight samples, and the proportion of data and no-data
packets is adjusted so that the overall rate is 44100 samples per
second.  So 8x2 is the theoretical minimum.

> However it seems to choke at 8x2 @ 96k.

At sample rates above 48 kHz, there are 16 samples per packet (and above
96 kHz, 32).  It is not possible to use 8x2 at 96 kHz, and FFADO should
not have allowed you to try it; please file a bug there:
<http://subversion.ffado.org/report> (requires a login).


Regards,
Clemens
