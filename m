Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1CLSxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 13:53:23 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4299 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1CLSxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 13:53:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: radio-maestro broken (conflicts with snd-es1968)
Date: Sat, 12 Mar 2011 19:52:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-tschai; KDE/4.6.1; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        jirislaby@gmail.com
References: <201103121919.05657.linux@rainbow-software.org>
In-Reply-To: <201103121919.05657.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103121952.39850.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 12, 2011 19:19:00 Ondrej Zary wrote:
> Hello,
> the radio-maestro driver is badly broken. It's intended to drive the radio on 
> MediaForte ESS Maestro-based sound cards with integrated radio (like 
> SF64-PCE2-04). But it conflicts with snd_es1968, ALSA driver for the sound 
> chip itself.
> 
> If one driver is loaded, the other one does not work - because a driver is 
> already registered for the PCI device (there is only one). This was probably 
> broken by conversion of PCI probing in 2006: 
> ttp://lkml.org/lkml/2005/12/31/93
> 
> How to fix it properly? Include radio functionality in snd-es1968 and delete 
> radio-maestro?

Interesting. I don't know anyone among the video4linux developers who has
this hardware, so the radio-maestro driver hasn't been tested in at least
6 or 7 years.

The proper fix would be to do it like the fm801.c alsa driver does: have
the radio functionality as an i2c driver. In fact, it would not surprise
me at all if you could use the tea575x-tuner.c driver (in sound/i2c/other)
for the es1968 and delete the radio-maestro altogether.

Both are for the tea575x tuner, although radio-maestro seems to have better
support for the g_tuner operation. It doesn't seem difficult to add that to
tea575x-tuner.c.

The fm801 code for driving the tea575x is pretty horrible and it should be
possible to improve that. I suspect that those read/write/mute functions
really belong in tea575x-tuner.c and that only the low-level gpio actions
need to be in the fm801/es1968 drivers.

Hope this helps.

Regards,

	Hans

BTW: if anyone has spare hardware for testing the radio-maestro/tea575x-tuner,
then I'm interested.

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
