Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2EFIcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 04:32:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54703 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246Ab2EFIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 04:32:19 -0400
Message-ID: <4FA6370E.9000702@openvz.org>
Date: Sun, 06 May 2012 12:32:14 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>
Subject: Re: [ALSA hda 3.4-rc] suspend2ram regression in snd_hda_intel
References: <4FA38371.9020205@openvz.org>
In-Reply-To: <4FA38371.9020205@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> Mainline commit 785f857d1cb0856b612b46a0545b74aa2596e44a
> ("ALSA: hda - Set codec to D3 forcibly even if not used")
> breaks sound for my notebook (thinkpad x220),
> looks like codec cannot wake from power-save state after resume.
> After reverting looks like all works fine.
>
> how to reproduce:
> * unplug the power cord (to enable hda power safe mode)
> * play something and stop
> * wait until the background noise disappears (codec went into power-save mode)
> * suspend
> * resume
> * play something again and hear the silence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Bump

BTW, I don't see any locks around hda power-save code, for example  hda_power_work() reads
codec->power_on and codec->power_count without any locks. This seems racy.
