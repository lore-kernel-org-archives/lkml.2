Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2AMTya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:54:30 -0500
Received: from ip94-39-241-190.ct.co.cr ([190.241.39.94]:50207 "EHLO
	bruno.wildbear.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab2AMTy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:54:28 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 14:54:28 EST
Date: Fri, 13 Jan 2012 13:44:03 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
Subject: Sound broken in 3.2.0 and 3.2.1
Message-ID: <alpine.LNX.2.00.1201131241090.1239@bruno>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:

I have built standard kernels 3.2.0 and 3.2.1 and their respective modules. 
Both exhibit no sound with the following sound modules installed:

   snd_pcm_oss
   snd_mixer_oss
   snd_hda_codec_realtek
   snd_hda_intel
   snd_hda_codec
   snd_pcm
   snd_timer
   snd
   soundcore
   snd_page_alloc

Kernels 3.1.8 works as expected with the same set of modules (for 3.1.8)
installed.

What appears to be happening is that the available controls are not being
properly elucidated in 3.2.x.  For example both aumix and gamix show that
the PCM control is missing; it appears normally in 3.1.x using the same set
of driver modules.  This is causing the immediate problem as this control is
set to zero on bootup and cannot be accessed thereafter.  Sound appears to
play normally through the alsa driver in mplayer for example, and the
internal mplayer volume control appears to work normally, but there is no
sound.

The controls elucidated differ as follows (taken from gamix) for the same
hardware (intel hda with realtek alc662 codec):

3.1.x:

    1 - PCM
    2 - Headphone
    3 - Rear Mic
    4 - Front Mic
    5 - Line
    6 - Auto-mute Mode
    7 - Capture
    8 - Capture 1
    9 - Input Source
   10 - Input Source 1
   11 - IEC958
   12 - Master


3.2.x:

    1 - Master
    2 - Channel Mode
    3 - Front
    4 - Surround
    5 - Center
    6 - LFE
    7 - Headphone
    8 - Rear Mic
    9 - Line
   10 - Auto-mute Mode
   11 - Capture
   12 - Capture 1
   13 - Input Source
   14 - Input Source 1
   15 - IEC958


Yours,

Joseph Parmelee
Wild Bear Systems
