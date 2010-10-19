Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0JSJzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:55:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42966 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0JSJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lM33wmykIu5nFPzUL8+/ID5LSl7YOl6Wv7y5Ha18mihfB+Mj2zyiho8Yro4Fdzikfq
         FGtollMTUU6kxmMldCM0FLQtik1XqdAV/cPtlVKHjQsga2dyx33Zs4csF3uHQswMqhZn
         UVQCNpc2XsHZ9+fJ9+YMSJfdi4zrrXPhbFz64=
MIME-Version: 1.0
In-Reply-To: <20101019090149.GC31170@legolas.emea.dhcp.ti.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
	<1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
	<20101019081855.GI12470@legolas.emea.dhcp.ti.com>
	<AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
	<20101019090149.GC31170@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 12:55:04 +0300
Message-ID: <AANLkTimCqZsJ6eY2zk0hJNhkYJDPbYnviiZ4gadnf-bB@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 03:34:55AM -0500, Felipe Contreras wrote:
>>>
>>> It was fine as it was before. NAK
>>
>> It's not fine. You can build with CONFIG_USB_G_NOKIA=y, and it doesn't
>> work. Definitely some dependency is missing.
>
> if phonet is not set it should not build. If phonet is set to module and
> g_nokia to built-in, then it's your mistake.

I'm not talking about phonet, I replied to your comment regarding
USB_GADGET_MUSB_HDRC. For me USB_GADGET_MUSB_HDRC=n USB_G_NOKIA=y
doesn't work, but the Kconfig allows it.

>> How do you handle USB_MUSB_HDRC=y and NOP_USB_XCEIV=n and TWL4030_USB=n?
>>
>> depends on (NOP_USB_XCEIV || TWL4030_USB) ?
>
> you're selecting, not depending on this patch. What I mean is that you
> will enable a useless driver on some boards if you "select TWL4030_USB
> if ARCH_OMAP3"

Ok, I'll make it: depends on (NOP_USB_XCEIV || TWL4030_USB)

BTW, if you want to try this:
./scripts/kconfig/conf --defconfig=usb_defconfig arch/arm/Kconfig

usb_defconfig:
CONFIG_ARCH_OMAP=y
CONFIG_EXPERIMENTAL=y
CONFIG_NET=y
CONFIG_PHONET=y

CONFIG_USB=y
CONFIG_USB_GADGET=y
CONFIG_USB_MUSB_OTG=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_G_NOKIA=y

# TODO USB_MUSB_OTG should select this
CONFIG_USB_GADGET_MUSB_HDRC=y

I expect TWL4030_USB and USB_OTG to be automatically selected.

-- 
Felipe Contreras
