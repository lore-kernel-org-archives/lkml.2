Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0JSOcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:32:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0JSOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TkTDTpGjv3enyIot9xwE4Bm4Yjr7b/fUF+AaBJmhTRiYQcwc6MrJBf50HCpIHL94SC
         MxVWwqXmMcjYP0SDLSDojMPzP0Ag4zpBoNXIIrnDP3vFMsVWE2jEO39dVzOXclwfxB/s
         Im/QlWmlZ4edPlD/rfV/tMW3IvyX5q4G99upI=
MIME-Version: 1.0
In-Reply-To: <20101019115236.GL31170@legolas.emea.dhcp.ti.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
	<AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
	<20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
	<AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
	<20101019115236.GL31170@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 17:32:07 +0300
Message-ID: <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 2:52 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 06:36:32AM -0500, Felipe Contreras wrote:
>>
>> That is actually the intention.
>
> so it's a bit messed up one :-p

Why? It makes configurations simpler.

>> It's the other way around. He wanted to get rid of defconfigs
>> completely by moving the complexity to Kconfigs:
>
> Yes, but he was suggesting to add things like Kconfig.rx51 and that
> would be selecting correct drivers to get rx51 working, he was
> definitely not suggesting to add sensible defaults all over the tree.

There are two parts, one part is to fix the Kconfigs, and another was
to come up with a way to replace the horrible defconfigs. Part two is
mostly fixed thanks to 'make savedefconfig', since the defconfigs are
not so horrible any more, but part one is a continued effort.

For part two Linus had the idea to use Kconfigs instead of defconfigs,
but they would mostly look very similar to the current ones generated
by 'make savedefconfig'.

I don't know what makes you think Linus didn't want part one to be
done. He wanted the Kconfig.rx51 to be human readable, and you are
proposing that TWL4030_USB should be manually added there... I don't
think TWL4030_USB says anything to human beings.

See the last link:
---
It's often tedious for other cases too ("I just want to enable a
particular driver, what do I need to do so?")
---

>> http://article.gmane.org/gmane.linux.kernel/994720
>> http://article.gmane.org/gmane.linux.kernel/994706
>> http://article.gmane.org/gmane.linux.kernel/994718
>>
>> You seem to be pushing for the exact opposite; keep the complexity on
>> the defconfigs and the burden on the user creating configs.
>
> no, you got me wrong. We do need to get rid of defconfigs, but we have
> to do so while keeping the resulting binary working and as of today, if
> you enable more than one transceiver driver, it won't work.

Yes, but how do you get rid of the defconfig while also having a
working USB_G_NOKIA? Somehow a transceiver should be automatically
selected.

>> Ok. But for now 'default y if ARCH_OMAP3' for TWL4030_USB doesn't
>> hurt, nor increases the total size of Kconfigs, and solves a real
>> problem.
>
> I don't see it that way. I see that there will be boards with one too
> many transceivers enabled and the resulting binary won't work, but I'll
> leave that for Greg to decide.

That is no change from the current situation; you can still have two
transceivers. My patch is not changing that.

The issue you are pointing out is a separate one, and I can write a
patch for that... basically:

config NOP_USB_XCEIV
  depends !TWL4030_USB
config TWL4030_USB
  depends !NOP_USB_XCEIV

-- 
Felipe Contreras
