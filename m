Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1EWNDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:03:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48330 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1EWNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hh13foS1N4lNDnVMs7feOHZd+fbfmlJzfyBxHZRNZ//tm03ruqFRqXMGDNBmi2q327
         Fw8cBTJUykmu+i9mhKlSvSjDqGDrvhVomF/SEkE4QUZ1DDGOz+YzUUNdC+d1u67DH7ww
         /Eos+W3YMQgEnwAKmxefHfWW5F69m87fbhoLc=
MIME-Version: 1.0
In-Reply-To: <20110511225557.2c8f6649@lxorguk.ukuu.org.uk>
References: <20110511204609.GA6059@patrik-macbook>
	<20110511225557.2c8f6649@lxorguk.ukuu.org.uk>
Date: Mon, 23 May 2011 15:03:00 +0200
Message-ID: <BANLkTi=tB+22Xen9StHkCdoEa8A2hqA2aA@mail.gmail.com>
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight (try 2)
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 11 May 2011 22:46:09 +0200
> Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
>
>> On the Fit-PC2 the VBT reports an invalid fixed panel mode for LVDS, this gets
>> in the way for SDVO. This patch makes VBT parsing skip the invalid mode. When
>> there is no LVDS output the backlight support crashes so the patch also checks
>> for this before enabling it.
>>
>> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>
> Looks good to me. I'll add that to the pile.
>
> Alan
>

Thanks Alan

Will it go into 2.6.40-rc1?

Now that output it somewhat working on the Fit-PC2 I've been looking
deeper into the SDVO code trying to understand why I'm not getting
proper modes for my display. At the moment it just defaults to
standard modes like 1024x768, 800x600 etc...

The issue is that I'm not getting any EDID from the display. Could be
the GMBus getting in the way or that the SDVO IO mapping isn't set up
properly before sending the SDVO_CMD_SET_CONTROL_BUS_SWITCH command.
I've been fiddling quite a lot with it but nothing seems to work, so
instead I took the current SDVO code (and large parts of the output
handling) from the i915 driver and crammed it into gma500. That did
the trick (though it's not currently talking to crtc abstraction
properly).

So my question is, do you think we should incorporate the new and more
feature complete output handling from the i915 into gma500? We might
even start sharing that code between gma500 and i915. If that is
something you like to avoid we can of course keep working on our
current output code.

Thanks
Patrik Jakobsson
