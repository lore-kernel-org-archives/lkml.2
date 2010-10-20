Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0JTOil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:38:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32775 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0JTOij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BMdM/x/yX1CSqS1O/uOHvQf75EouOcFPCF5M6l3ALFZMrHQuhTUmmjT8fy1MuFcSFz
         upjwoCZxO9eJI1qyY0PTwvcgTDWbtauJYndElf5RPLuM6FxvXEVwSn3cytrFstAM17ls
         2XTB7JhcSQ1ogCiMDLGhP6qUBZRWfTGkWJP7k=
MIME-Version: 1.0
In-Reply-To: <4CBEE186.8090701@nokia.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<4CBD9FD5.506@nokia.com>
	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
	<4CBE9E69.6060803@nokia.com>
	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
	<4CBEB312.7060400@nokia.com>
	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
	<4CBEE186.8090701@nokia.com>
Date: Wed, 20 Oct 2010 17:38:37 +0300
Message-ID: <AANLkTinULxyUg_vHjk9RsQm4Row7vRC9ApzYXt7ZMQJD@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 3:33 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
> On 10/20/2010 12:23 PM, ext Felipe Contreras wrote:
>> On Wed, Oct 20, 2010 at 12:14 PM, Roger Quadros<roger.quadros@nokia.com>
>>  wrote:
>>> USB_G_NOKIA just needs a USB gadget controller to work. The gadget
>>> controller used for the board should come from the board's Kconfig which
>>> will ideally be supplied by the board's vendor.
>>
>> Ok, but USB_OMAP is not supposed to work on the N900? (I tried and it
>> didn't)
>
> No it won't work. USB_OMAP was for older OMAP's. MUSB is on OMAP3 and later.
> But MUSB is not limited to OMAP SoC.

config USB_GADGET_OMAP
  depends ARCH_OMAP

So how about s/ARCH_OMAP/ARCH_OMAP1/

Then USB_GADGET_MUSB_HDRC would be selected by default on OMAP2+.

>>> For example, can't USB_GADGET_MUSB_HDRC be selected in MACH_NOKIA_RX51 in
>>> arch/arm/mach-omap2/Kconfig? or is there a better place to put it?
>>
>> I don't think so, because people might not want USB at all. The ideal
>> case would be for USB_GADGET_MUSB_HDRC to be selected automatically
>> when the user selects USB and USB_GADGET, but that's not happening
>> because USB_GADGET_OMAP is selected first (all the dependencies are
>> met).
>>
> Yes you are right. In think with the current setup (i.e. controller
> selection at kconfig and limitation to one controller per config) we will
> never be able to satisfy all users.
>
> We might need to move to some kind of gadget controller framework and
> runtime controller selection to solve this problem.

Definitely, for multi-omap. But for OMAP1/OMAP2+ setting ARCH_OMAP1 as
I just suggested would do the trick.

-- 
Felipe Contreras
