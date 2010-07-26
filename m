Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0GZOs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:48:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44979 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0GZOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QLqby3MKDxR5vIIpfY3I2jU+QiJdH+9kZ0t79G+mK4gSNu7QpaC8DTNGYQ0BpqpxRp
         C/ac1Btqw784cS0bkYp6ivv32OIw7KsFmbi6IPrvx3B71KUaRdvAjIgy3wkdHOuf1w7e
         azgaFMoteqyzvtzh2yiJ3ACl8/5cZ6CyxO+X0=
Message-ID: <4C4DA034.3090608@gmail.com>
Date: Mon, 26 Jul 2010 16:48:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hda_intel: too quiet sound (regression)
References: <4C4D9EDA.3060505@gmail.com>
In-Reply-To: <4C4D9EDA.3060505@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 04:42 PM, Jiri Slaby wrote:
> Hi,
> 
> after I upgraded from 2.6.34-rc5-mm1 to 2.6.35-rc5-mm1 (there were other
> issues in between them), the sound from my soundcard is very very quiet.
> 
> alsa-info:
> http://www.alsa-project.org/db/?f=dcadb29a2d5d047ecf5545792ac3239dc0c8c7f0
> 
> Any ideas?

I've just find out that whatever value 1-64 is set the Master control to
via amixer, it plays still the same. So the mixer (Master volume) is
somehow screwed up.

These two are the same volumes:
# amixer -D hw sset Master,0 64
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 64
  Mono: Playback 64 [100%] [0.00dB] [on]
# amixer -D hw sset Master,0 1
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 64
  Mono: Playback 1 [2%] [-47.25dB] [on]



This turns sound off, indeed:
amixer -D hw sset Master,0 0
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 64
  Mono: Playback 0 [0%] [-48.00dB] [on]

regards,
-- 
js
