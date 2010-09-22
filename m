Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0IVPba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:31:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52010 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0IVPb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VrQfsl23MCihs766Xuw5IBGSrMml0wI0CtSfUggEfFlhmg8QCs4iTpyfJC8svMmoVi
         wi3MLOKSgVTeiKFbLQxmHANEeqNxXN/slHycOVxualg/sMTpRaPNjv8+b1ufeJrqHVXj
         LOWDVMlR18rpAX8bZ2WH2Wrmh3hhuTdR+eUmc=
MIME-Version: 1.0
In-Reply-To: <s5hmxr97sfb.wl%tiwai@suse.de>
References: <20100921173254.GA3037@ht>
	<s5hwrqenmz4.wl%tiwai@suse.de>
	<AANLkTikgOaBizi2z+AuAgD+anvmc+kG3z9KTqfzXs1zm@mail.gmail.com>
	<s5hmxr97sfb.wl%tiwai@suse.de>
Date: Wed, 22 Sep 2010 18:31:26 +0300
X-Google-Sender-Auth: d263gtYEUnqfbBitiqaWedE7Cs4
Message-ID: <AANLkTi=Tctwyz=wLWSpf09Ex18wNgHqDv7PRSxXQ8LTw@mail.gmail.com>
Subject: Re: PROBLEM: snd_intel_hda audio regression in 2.6.36-rc5
From: Aki Parviainen <aki.parviainen@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org, perex@perex.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So, you are testing only over SPDIF output, right?

Yes, I'm only using SPDIF output!

> Looks like the SPDIF status bits has been reset by some reason.
> Try to restore via iecset program included in alsa-utils package,
> e.g.
>    iecset original on
>    iecset category 0x02

I tried this and didn't notice any difference.

>
> If this doesn't help, try to unload sound driver once, remove (or
> backup) /etc/asound.state (which might be in a different path
> depending on the distro), then load sound modules again.
> This will restore the default SPDIF status.  Unmute / adjust mixer
> setups appropriately after doing this.

I also tried this but didn't notice a difference but however I noticed
a workaround to this problem that might be related to deleting the
asound.state (debian places it btw to /var/lib/alsa/asound.state): now
the regular audio works via SPDIF once again if I first play a file
with digital preencoded audio. Ie:

-Boot with 2.6.36-rc5
-Start kaffeine
-Play mp3 file -> no sound at all via spdif
-Play mkv file with 5.1 sound -> sound ok
-Play mp3 file again -> sound ok!
-Exit kaffeine & restart kaffeine or vlc
-Play mp3 file again -> sound ok!

Unfortunately the fix isn't permanent because after reboot I cannot
get regular sound via spdif until I have once played a file with 5.1
audio track.

Yours,

Aki
