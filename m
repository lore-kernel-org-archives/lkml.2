Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab1E1AJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:09:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654Ab1E1AJ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim3Sr3ZfUda2bwhfw8O7qtQ3tXNmQ@mail.gmail.com>
References: <s5haae8jx7h.wl%tiwai@suse.de> <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
 <BANLkTim3Sr3ZfUda2bwhfw8O7qtQ3tXNmQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 17:09:04 -0700
Message-ID: <BANLkTin2jOUefaG2Jivi0kno9kQWNM1ZSQ@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates #2 for 2.6.40
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 5:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>>
>>  af4ccf4f86c0..9477c58e3308
>>
>> probably it's that last one ("ALSA: hda - Reorganize controller quriks
>> with bit flags").
>
> Confirmed. Also confirmed that reverting that from current tip of git
> fixes the issue.

Just to clarify: it's commit 9477c58e3308f54a108a5d1eb9621830b329b0ca
that is bad.

It causes odd stuttering/echoing effects on my bog-standard Westmere setup:

  00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
  00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 12)
  00:16.0 Communication controller: Intel Corporation 5 Series/3400
Series Chipset HECI Controller (rev 06)
  00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series
Chipset USB2 Enhanced Host Controller (rev 06)
  00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
High Definition Audio (rev 06)
  ...

with dmesg saying:

  HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
  HDA Intel 0000:00:1b.0: irq 52 for MSI/MSI-X
  HDA Intel 0000:00:1b.0: setting latency timer to 64
  hda_codec: ALC889: BIOS auto-probing.
  HDMI status: Pin=6 Presence_Detect=0 ELD_Valid=0
  input: HDA Intel HDMI/DP as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input2
  input: HDA Intel Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input3
  ALSA device list:
    #0: HDA Intel at 0xfb9f4000 irq 52

and I'm not seeing anything odd with the bad kernel, but the long-on
"boing" sound repeats about once a second as an echo and some
corruption for a few seconds, and trying to listen to music or
anything else is just psychedelic (more echo/stutter effects).

                      Linus
