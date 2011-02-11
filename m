Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1BKMX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:23:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60230 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1BKMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=VB/pb8MdOlWHULHj4EQdcEnXY6o8Ul+JqkOKQY3pKs5SK1RmN93Rs+iZbzpwC7QD+e
         v/FfxYLVkMt85jgrZWgiIgsXProFDkexnYYJ0Lr/TSSA3vXJIfU2iyFbHxZf7qi8LvvW
         I5N9aw0YGczc3ZNEPl6kdNXbn/PiP9K+HXJgs=
From: Wang Lei <f3d27b@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [SOUND] SBx00 sound card using snd_hda_codec_analog auto mutes
References: <s5h39nwdk4u.wl%tiwai@suse.de>
Date: Fri, 11 Feb 2011 20:23:21 +0800
In-Reply-To: <s5h39nwdk4u.wl%tiwai@suse.de> (Takashi Iwai's message of "Thu,
	10 Feb 2011 15:44:33 +0100")
Message-ID: <4d552a5a.03368e0a.5890.2b59@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply!

Takashi Iwai <tiwai@suse.de> writes:

> At Thu, 10 Feb 2011 20:49:51 +0800,
> Wang Lei wrote:
>> 
>> On my laptop, the sound card auto mutes some seconds after i enable it.
>> And play a audio file can't make sound. This is not a powersave feature,
>> because i haven't enable it. I guess it's a driver problem. It occurs
>> since 2.6.36.X. Please help.
>
> Then a possible cause would be the badly working interrupts.
> Or, I remember vaguely some reports mentioning conflicts with radeon
> driver.
>
> Anyway, try to reproduce without the graphic interface first.
>

I have reproduced it without the graphic interface.

> Also, try to pass enable_msi=0 or 1.  AMD controllers tend to unstable
> regarding MSI.
>

And pass enable_msi=0 or 1 to snd_hda_intel, or even add boot parameter
pci=nomsi (i actually don't know whether this is reasonable), the
problem occurs.

I have forgot to mention this, when passing apci=off to the boot kernel,
there is no this problem.

>
> HTH,
>
> Takashi
