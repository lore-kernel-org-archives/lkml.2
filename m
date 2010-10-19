Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0JSLQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:16:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49406 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab0JSLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:16:31 -0400
Date: Tue, 19 Oct 2010 14:16:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
 <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
 <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 05:59:58AM -0500, Felipe Contreras wrote:
>The USB_MUSB_HDRC dependency on NOP_USB_XCEIV || TWL4030_USB is
>already there, I'm just making it explicit. The rest are not
>dependencies, just sensible defaults, and they are already in
>drivers/usb/musb/Kconfig, I'm just moving them.

might be true, but what will happen is that other developers will just
"follow what's in the tree" so they'll keep on adding more and more
"sesible defaults" to this line.

Linus had some really good comments about Kconfig usage some time ago
and I'm sure he wouldn't like us adding "sensible defaults" all over the
place.

>If you have a better approach to avoid manually selecting TWL4030_USB
>on defconfigs, and making sure USB_MUSB_HDRC works, please share it.

that's the thing. Currently, I don't think it should be automatic as we
can only have one transceiver structure. Look into
drivers/usb/otg/otg.c, it's just a static global pointer on that file,
which prevents us from having a working solution if you enable more than
one transceiver.

Ideally there would be a class or something similar to allow us to
register N transceiver and use the correct one in runtime, that would
make distro-makers' life easier. It'll probably help Linaro also at some
point, but as of today, enabling more than one transceiver will never
work.

-- 
balbi
