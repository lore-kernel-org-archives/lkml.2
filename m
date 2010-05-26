Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0EZN67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:58:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45409 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752Ab0EZN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:58:55 -0400
X-Sasl-enc: 9n8yuEtK9fNYHAhPeeOMBueqC5c2kJ1tdsqy388Cz9Hy 1274882306
Message-ID: <4BFD2901.20800@ladisch.de>
Date: Wed, 26 May 2010 15:58:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>	<s5hmxvmzwwd.wl%tiwai@suse.de> <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Wednesday 2010-05-26 14:10, Takashi Iwai wrote:
>>> /proc/asound/cards:
>>>  0 [SB  ]: HDA-Intel - HDA ATI SB
>>>            HDA ATI SB at 0xf0500000 irq 16
>>>  1 [HDMI]: HDA-Intel - HDA ATI HDMI
>>>            HDA ATI HDMI at 0xf0110000 irq 19
>>> 
>>> The soundcard responsible for the internal speaker is the 01:05.1/"HDMI" 
>>> one.
>>
>>Hmm?  HDMI output as the "internal" speaker is abnormal.
>>
>>> Under Windows XP, I see the following mixer elements for it:
>>> 
>>>  * Master Volume
>>>  * Wave
>>>  * SW Synth
>>>  * CD Player
>>> 
>>> Subsequently, there is sound (once I bump the volumes on these).
>>
>>There are definitely for the onboard sound, not for HDMI.
> 
> The "SB" card has many more mixers (counting  10) and Windows XP also
> shows about that many for SB. But neither in Linux nor Windows does
> the SB card have any effect; I do have to turn the bars of the "HDMI"
> one.
> 
> Abnormal, well. It's (semi-)embedded, what did you expect.

It is extremely unlike that your embedded device has separate chips to
decode the HDMI sound signal and then convert it to analog, when the
same is already available with the normal HDA device.

Your alsa-info output shows that there is an ALC262 codec connected
to the "SB" device; this chip wouldn't have been put there if it didn't
have a function.

Try unmuting and raising both the Master and Beep controls.

The Windows mixer elements are software-emulated and shown for all
devices.  (I don't know why the only working device is labeled "HDMI",
maybe someone just mixed up the HDA devices.)


Regards,
Clemens
