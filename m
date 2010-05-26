Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab0EZMEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:04:30 -0400
Received: from borg.medozas.de ([188.40.89.202]:59671 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0EZME3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:04:29 -0400
Date: Wed, 26 May 2010 14:04:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: alsa-devel@alsa-project.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, perex@perex.cz,
       tiwai@suse.de
Subject: No mixers on ATI RS780 Azalia
Message-ID: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have here a Samsung 320MXn2 monitor/mainboard (typical x86_64 
environment) where I cannot get sound output to the internal speakers 
working.

To start, there seem to be two sound cards:

lspci/lspci -n:
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
00:14.2 0403: 1002:4383
01:05.1 0403: 1002:960f

/proc/asound/cards:
 0 [SB  ]: HDA-Intel - HDA ATI SB
           HDA ATI SB at 0xf0500000 irq 16
 1 [HDMI]: HDA-Intel - HDA ATI HDMI
           HDA ATI HDMI at 0xf0110000 irq 19

The soundcard responsible for the internal speaker is the 01:05.1/"HDMI" 
one.

Under Windows XP, I see the following mixer elements for it:

 * Master Volume
 * Wave
 * SW Synth
 * CD Player

Subsequently, there is sound (once I bump the volumes on these).

However, in Linux up to including 2.6.34, I only see a single mixer 
element:

 * IEC958/S/PDIF

mplayer etc. all successfully write to the device, but since there are 
not any further mixer controls, I can't unmute the essential channels.

alsa-utils is version 1.0.21, from openSUSE 11.2 x86_64.


Any help is appreciated.

Thanks,
Jan
