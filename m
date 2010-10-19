Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0JSLgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:36:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502Ab0JSLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DWPyl6bPhdMBKyAfUk3GgVVTBVBOAQHOqgiKPJNGHX+m43U31xJPOwnLLHHBqhAime
         v/51YSY1nNVw2EsN5OydfnFAYIiBeHIg2nUA5/7Gu+bW7pl2dX5JlS2H8MI7TYNZHPMI
         /kKss3wPfNc1vopV0fXOZVCg0boAl14mr9Ejs=
MIME-Version: 1.0
In-Reply-To: <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
	<AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
	<20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 14:36:32 +0300
Message-ID: <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
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

On Tue, Oct 19, 2010 at 2:16 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 05:59:58AM -0500, Felipe Contreras wrote:
>>
>> The USB_MUSB_HDRC dependency on NOP_USB_XCEIV || TWL4030_USB is
>> already there, I'm just making it explicit. The rest are not
>> dependencies, just sensible defaults, and they are already in
>> drivers/usb/musb/Kconfig, I'm just moving them.
>
> might be true, but what will happen is that other developers will just
> "follow what's in the tree" so they'll keep on adding more and more
> "sesible defaults" to this line.

That is actually the intention.

> Linus had some really good comments about Kconfig usage some time ago
> and I'm sure he wouldn't like us adding "sensible defaults" all over the
> place.

It's the other way around. He wanted to get rid of defconfigs
completely by moving the complexity to Kconfigs:
http://article.gmane.org/gmane.linux.kernel/994720
http://article.gmane.org/gmane.linux.kernel/994706
http://article.gmane.org/gmane.linux.kernel/994718

You seem to be pushing for the exact opposite; keep the complexity on
the defconfigs and the burden on the user creating configs.

>> If you have a better approach to avoid manually selecting TWL4030_USB
>> on defconfigs, and making sure USB_MUSB_HDRC works, please share it.
>
> that's the thing. Currently, I don't think it should be automatic as we
> can only have one transceiver structure. Look into
> drivers/usb/otg/otg.c, it's just a static global pointer on that file,
> which prevents us from having a working solution if you enable more than
> one transceiver.
>
> Ideally there would be a class or something similar to allow us to
> register N transceiver and use the correct one in runtime, that would
> make distro-makers' life easier. It'll probably help Linaro also at some
> point, but as of today, enabling more than one transceiver will never
> work.

Ok. But for now 'default y if ARCH_OMAP3' for TWL4030_USB doesn't
hurt, nor increases the total size of Kconfigs, and solves a real
problem.

-- 
Felipe Contreras
