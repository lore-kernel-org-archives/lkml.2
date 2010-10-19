Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab0JSKwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:52:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57852 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab0JSKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XdPak8Z42RuZ6PZmBrbZNw/fjKKTzwQZW9ktRC8oksSH8qihXaQrARozUxuTjA6pfT
         DDkX+2M9wfL6l7WJZN2DU/9u8/QNfA2IRudMtrM5PF9qk5v6t4p32N0W5+9UOqc3JEW1
         zI3rGFGLYApY2a4ltjKoKin1HW/HmBSIfrXTI=
MIME-Version: 1.0
In-Reply-To: <20101019101229.GG31170@legolas.emea.dhcp.ti.com>
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
	<1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
	<20101019081855.GI12470@legolas.emea.dhcp.ti.com>
	<AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
	<20101019090149.GC31170@legolas.emea.dhcp.ti.com>
	<AANLkTimCqZsJ6eY2zk0hJNhkYJDPbYnviiZ4gadnf-bB@mail.gmail.com>
	<20101019101229.GG31170@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 13:52:10 +0300
Message-ID: <AANLkTikmc1DmHZuhySM1gourjETsaXoCvgfqk7p-b6aQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 1:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 04:55:04AM -0500, Felipe Contreras wrote:
>>
>> I'm not talking about phonet, I replied to your comment regarding
>> USB_GADGET_MUSB_HDRC. For me USB_GADGET_MUSB_HDRC=n USB_G_NOKIA=y
>> doesn't work, but the Kconfig allows it.
>
> I see, that's a problem for sure.
>
>> Ok, I'll make it: depends on (NOP_USB_XCEIV || TWL4030_USB)
>>
>> BTW, if you want to try this:
>> ./scripts/kconfig/conf --defconfig=usb_defconfig arch/arm/Kconfig
>>
>> usb_defconfig:
>> CONFIG_ARCH_OMAP=y
>> CONFIG_EXPERIMENTAL=y
>> CONFIG_NET=y
>> CONFIG_PHONET=y
>>
>> CONFIG_USB=y
>> CONFIG_USB_GADGET=y
>> CONFIG_USB_MUSB_OTG=y
>> CONFIG_USB_MUSB_HDRC=y
>> CONFIG_USB_G_NOKIA=y
>>
>> # TODO USB_MUSB_OTG should select this
>> CONFIG_USB_GADGET_MUSB_HDRC=y
>>
>> I expect TWL4030_USB and USB_OTG to be automatically selected.
>
> could be, but that's a board-by-board thing. It's not mandatory to have
> twl4030-usb, it's mandatory to have a transceiver, not matter which one
> it is.

I see, but is it possible that in a board you have the two? If not,
there must be a way to find the correct transceiver based on the
configuration. If yes, then there must be a way to select a sensible
one by default, rather than not having any.

This way, for example it would be possible to get rid of some lines in
a minimal n900_defconfig (used in MeeGo[1]), and eventually hopefully
get rid of all of them (except CONFIG_SND_OMAP_SOC_RX51=y).

[1] http://meego.gitorious.org/meego-os-base/kernel-source/blobs/master/config-arm-n900

-- 
Felipe Contreras
