Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2EDHV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:21:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51770 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2EDHVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:21:25 -0400
Message-ID: <4FA38371.9020205@openvz.org>
Date: Fri, 04 May 2012 11:21:21 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [ALSA hda 3.4-rc] suspend2ram regression in snd_hda_intel
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainline commit 785f857d1cb0856b612b46a0545b74aa2596e44a
("ALSA: hda - Set codec to D3 forcibly even if not used")
breaks sound for my notebook (thinkpad x220),
looks like codec cannot wake from power-save state after resume.
After reverting looks like all works fine.

how to reproduce:
* unplug the power cord (to enable hda power safe mode)
* play something and stop
* wait until the background noise disappears (codec went into power-save mode)
* suspend
* resume
* play something again and hear the silence
