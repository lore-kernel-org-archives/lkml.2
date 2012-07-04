Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab2GDFrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:47:40 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:52017 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab2GDFri convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <E0D6B3D7803B1A49AC7CEA9958379F630375BD5A@DFLE36.ent.ti.com>
References: <1340367055-19835-1-git-send-email-kishon@ti.com>
	<1340367055-19835-3-git-send-email-kishon@ti.com>
	<E0D6B3D7803B1A49AC7CEA9958379F630375BD5A@DFLE36.ent.ti.com>
Date: Wed, 4 Jul 2012 11:17:36 +0530
Message-ID: <CAAe_U6+3sf5Nm5bQeY=Pi=sYMPp3GfXWxfbbbo1mSH2u9xjTyQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS or ID events
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: "Matcovschi, Oleg" <oleg.matcovschi@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, Jul 3, 2012 at 11:09 PM, Matcovschi, Oleg
<oleg.matcovschi@ti.com> wrote:
>>From: linux-omap-owner@vger.kernel.org [linux-omap-owner@vger.kernel.org] on behalf of ABRAHAM, KISHON VIJAY
>>Sent: Friday, June 22, 2012 5:10 AM
>>To: gregkh@linuxfoundation.org; ABRAHAM, KISHON VIJAY; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Balbi, Felipe
>>Subject: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS or ID events
>
>>The atomic notifier from twl4030/twl6030 to notifiy VBUS and ID events,
>>is replaced by a direct call to omap musb blue.
>
>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>---
>> drivers/usb/musb/omap2430.c   |   94 +++++++++++++++++++++++++---------------
>> drivers/usb/otg/twl4030-usb.c |   46 ++++++++++----------
>> drivers/usb/otg/twl6030-usb.c |   47 +++++++++-----------
>> include/linux/usb/musb-omap.h |   30 +++++++++++++
>> 4 files changed, 133 insertions(+), 84 deletions(-)
>> create mode 100644 include/linux/usb/musb-omap.h
> .....
> +enum omap_musb_vbus_id_status {
> +       OMAP_MUSB_UNKNOWN = 0,
> +       OMAP_MUSB_ID_GROUND,
> +       OMAP_MUSB_ID_FLOAT,
> +       OMAP_MUSB_VBUS_VALID,
> +       OMAP_MUSB_VBUS_OFF,
> +};
> +
>
> Why did you choose to introduce OMAP_MUSB specific VBUS, ID events?
> IMHO, it makes more sense to introduce mailbox functionality only without extra translation layer.
> Same mailbox glue layer could be used for other PHY drivers, not just twl.

We've decided to make twl as a comparator driver since we have a
separate phy driver (not yet merged). Hence we dint want twl to use
usb_phy specific events. So if you have other PHY drivers, you can
still use the OMAP_MUSB specific events.

Thanks
Kishon
