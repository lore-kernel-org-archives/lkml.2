Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2IZH3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:29:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2IZH3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:29:22 -0400
Date: Wed, 26 Sep 2012 00:29:16 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [BISECTED] snd-hda-intel audio distortion in Linus' current tree
Message-ID: <20120926072916.GA2654@croesus.uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Started having audio problems when trying out the latest tree
(v3.6-rc7-10-g56d27ad). When playing any kind of audio, there was
significant distortion, mostly crackling noise. I'm using a Lenovo
ThinkPad X230 (Panther Point).

I did a git-bisect to locate the problem, and it seems this commit is to
blame:

	c20c5a841cbe47f5b7812b57bd25397497e5fbc0 is the first bad commit
	commit c20c5a841cbe47f5b7812b57bd25397497e5fbc0
	Author: Seth Heasley <seth.heasley@intel.com>
	Date:   Thu Jun 14 14:23:53 2012 -0700

		ALSA: hda_intel: activate COMBO mode for Intel client chipsets
		
		This patch activates the COMBO position_fix for recent Intel client chipsets.
		COMBO mode is the recommended setting for Intel chipsets and eliminates HD
		audio warnings in dmesg.  This patch has been tested on Lynx Point, Panther
		Point, and Cougar Pont.
		
		Signed-off-by: Seth Heasley <seth.heasley@intel.com>
		Signed-off-by: Takashi Iwai <tiwai@suse.de>

It's pretty clear-cut. If I revert this patch, my sound starts
functioning normally again.

Any thoughts on how to proceed here? Can someone revert this, or is
there some testing that I can do?

Here's a pretty-printed bisection log, if needed:

 # good: [28a33cbc] Linux 3.5
 # bad:  [b13bc8dd] Merge tag 'staging-3.6-rc1' of git://git.kernel.or
 # good: [3c4cfade] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # bad:  [9fc37779] Merge tag 'usb-3.6-rc1' of git://git.kernel.org/pu
 # bad:  [f14121ab] Merge tag 'dt-for-3.6' of git://sources.calxeda.co
 # good: [d14b7a41] Merge branch 'for-linus' of git://git.kernel.org/p
 # good: [15d47763] Merge branch 'for-3.5' into for-3.6
 # bad:  [dbf7b591] Merge tag 'sound-3.6' of git://git.kernel.org/pub/
 # bad:  [1c76684d] ALSA: hda - add Haswell HDMI codec id
 # bad:  [8b8d654b] ALSA: hda - Move one-time init codes from generic_
 # good: [80c8bfbe] ALSA: HDA: Create phantom jacks for fixed inputs a
 # bad:  [ceaa86ba] ALSA: hda - Remove invalid init verbs for Nvidia 2
 # bad:  [4b6ace9e] ALSA: hda - Add the support for VIA HDMI pin detec
 # bad:  [c20c5a84] ALSA: hda_intel: activate COMBO mode for Intel cli


- Steven
