Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab0JSLAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:00:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40051 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0JSLAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SWfodfgZnqJ4T7U92KDKMrLKY2bu+JnGO4yHh0zUynUm16BqiPoQytSNVFp00GO4LP
         Tr55u1ltMKsaVNi38yymAdTePsyDCfnXTyk8TVlnJWRARkwMoIU8KFGOYJjDL5hGSryX
         EsRwG9mle+ABoZdaFtR0bXhPOhJQCNJ5MXMVU=
MIME-Version: 1.0
In-Reply-To: <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
Date: Tue, 19 Oct 2010 13:59:58 +0300
Message-ID: <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 1:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 19, 2010 at 05:03:28AM -0500, Felipe Contreras wrote:
>>
>> +       depends on (NOP_USB_XCEIV || TWL4030_USB)
>> +       default y if ARCH_OMAP3
>> +       default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN
>
> it could be only me, but I see these kind of dependencies tend to
> disaster. They can all grow to infinity. Soon, we will have another twl
> family of devices, or we will have another MACH_* which will need
> nop_xceiv, etc etc.

The USB_MUSB_HDRC dependency on NOP_USB_XCEIV || TWL4030_USB is
already there, I'm just making it explicit. The rest are not
dependencies, just sensible defaults, and they are already in
drivers/usb/musb/Kconfig, I'm just moving them.

If you have a better approach to avoid manually selecting TWL4030_USB
on defconfigs, and making sure USB_MUSB_HDRC works, please share it.

-- 
Felipe Contreras
