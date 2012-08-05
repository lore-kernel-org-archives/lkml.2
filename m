Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2HENGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 09:06:24 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:47028 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2HENGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 09:06:23 -0400
Message-ID: <501E6FB8.6080406@free.fr>
Date: Sun, 05 Aug 2012 15:06:00 +0200
From: Vincent Blut <vincent.debian@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: dgreid@chromium.org, perex@perex.cz, linux-kernel@vger.kernel.org
Subject: !!Re: sound: BUG: can't load gdm greeter on battery with Linux 3.5
References: <501E68C3.3080108@free.fr> <s5hzk69ijig.wl%tiwai@suse.de>
In-Reply-To: <s5hzk69ijig.wl%tiwai@suse.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/08/2012 14:57, Takashi Iwai a écrit :
> At Sun, 05 Aug 2012 14:36:19 +0200,
> Vincent Blut wrote:
>> Hi,
>>
>> Despite that the subject might suggest that this is a bug in the graphic
>> stack, it appears that
>> commit [b4a91cf0] makes the GDM greeter not loadable, however GDM has
>> been correctly loaded:
>>
>> # service gdm3 status
>> [ ok ] gdm3 is running.
>>
>> This issue only affects Linux 3.5 when I boot on battery, I spent some
>> time to bisect and  this commit seems to be the bad one:
>>
>> commit b4a91cf05c33d4ab5b2b3738a257a3fe49b462bd
>> Author: Dylan Reid <dgreid@chromium.org>
>> Date:   Fri Jun 15 19:36:23 2012 -0700
>>
>>     ALSA: hda - Handle open while transitioning to D3.
>>    
>>     This addresses an issue encountered when a pcm is opened while
>>     transitioning to low power state (codec->power_on == 1 &&
>>     codec->power_transition == -1).  Add snd_pcm_power_up_d3wait to
>>     hda_codec.  This function is used to power up from azx_open as opposed
>>     to snd_hda_power_up used from codec_exec_verb. When powering up from
>>     azx_open, wait for pending power downs to complete, avoiding the power
>>     up continuing in parallel with the power down on the work queue.
>>    
>>     The specific issue seen was with the CS4210 codec, it powers off the ADC
>>     and DAC nid in its suspend handler.  If it is re-opened before the
>>     ~100ms power down process completes, the ADC and DAC nid are initialized
>>     while powered down and audio is lost until another suspend/resume cycle.
>>    
>>     Signed-off-by: Dylan Reid <dgreid@chromium.org>
>>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>
>> Is this a known issue?
> Yes.  There is a known side-effect by this change, and the fix was
> already queued for 3.5.1 stable kernel.
>
>
> thanks,
>
> Takashi
Ok, thanks a lot Takashi for the quick answer!

Cheers,
Vincent
