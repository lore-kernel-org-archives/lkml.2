Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2AHJtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 04:49:33 -0500
Received: from smtprelay0072.b.hostedemail.com ([64.98.42.72]:34634 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab2AHJtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 04:49:31 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 3192
Date: Sun, 8 Jan 2012 09:49:27 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, alsa-devel@alsa-project.org
Message-ID: <162622243.549273.1326016167416.JavaMail.mail@webmail13>
References: <1253360187.305758.1325762980205.JavaMail.mail@webmail07>
 <s5hd3aumufa.wl%tiwai@suse.de>
Subject: Re: Re: ALSA regression in recent kernels: Intel HDA/ALC892 sound
 glitches
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.108.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jan 8, 2012, Takashi Iwai <tiwai@suse.de> wrote: 
> 
> At Thu, 5 Jan 2012 11:29:40 +0000 (GMT),
> Artem S. Tashkinov wrote:
> > 
> > Hello,
> > 
> > Since kernel 3.0.11 I have quite terrible sound artifacts - random pops, clicks and
> > short pauses (~500ms). Linux kernel 3.0.0 is *bug free*. So, some some of patches in
> > kernel *3.0.11* broke the driver, the bug is, of course, present in kernels 3.1 and 3.2.
> 
> Could you give alsa-info.sh output to check more details?
> Also, any chance to identify which 3.0.x release breaks the things?

alsa-info output was attached to my original mail posted into LKML, please check out
you e-mail client.

There are so few changes in Intel/Realtek HDA ALSA code between 3.0 and 3.0.11
I thought you could identify the culprit just by looking at the list.

    ALSA: fm801: Fix double free in case of error in tuner detection
    ALSA: fm801: Gracefully handle failure of tuner auto-detect
    ALSA: HDA: Add new revision for ALC662
    ALSA: hda - Add position_fix quirk for Dell Inspiron 1010
    ALSA: hda - Add support for 92HD65 / 92HD66 family of codecs
    ALSA: HDA: Add support for IDT 92HD93
    ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
    ALSA: HDA: conexant support for Lenovo T520/W520
    ALSA: hda - Disable power-widget control for IDT 92HD83/93 as default
    ALSA: hda - Don't add elements of other codecs to vmaster slave
    ALSA: hda - Fix ADC input-amp handling for Cx20549 codec
    ALSA: HDA: No power nids on 92HD93
    ALSA: hda/realtek - Avoid bogus HP-pin assignment
    ALSA: hda/realtek - Fix auto-mute with HP+LO configuration
    ALSA: hda/realtek - Skip invalid digital out pins
    ALSA: hda - Remove bad code for IDT 92HD83 family patch
    ALSA: pcm - fix race condition in wait_for_avail()
    ALSA: ua101: fix crash when unplugging
    ALSA: usb-audio: Check for possible chip NULL pointer before clearing probing flag
    ALSA: usb-audio - Check the dB-range validity in the later read, too
    ALSA: usb-audio - clear chip->probing on error exit
    ALSA: usb-audio - Fix the missing volume quirks at delayed init

If you have no ideas about which patch could have broken things, I will try to figure it out
by bisecting.
