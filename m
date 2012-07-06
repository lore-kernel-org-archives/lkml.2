Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2GFFwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:52:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40738 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2GFFwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:52:44 -0400
From: "Matcovschi, Oleg" <oleg.matcovschi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS or
 ID events
Thread-Topic: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS or
 ID events
Thread-Index: AQHNUHCEuT2u1eRrW0C70iLRXp7v85cX4sGxgAEhNgCAAg3QoA==
Date: Fri, 6 Jul 2012 05:52:42 +0000
Message-ID: <E0D6B3D7803B1A49AC7CEA9958379F630375C1E7@DFLE36.ent.ti.com>
References: <1340367055-19835-1-git-send-email-kishon@ti.com>
	<1340367055-19835-3-git-send-email-kishon@ti.com>
	<E0D6B3D7803B1A49AC7CEA9958379F630375BD5A@DFLE36.ent.ti.com>
 <CAAe_U6+3sf5Nm5bQeY=Pi=sYMPp3GfXWxfbbbo1mSH2u9xjTyQ@mail.gmail.com>
In-Reply-To: <CAAe_U6+3sf5Nm5bQeY=Pi=sYMPp3GfXWxfbbbo1mSH2u9xjTyQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


>-----Original Message-----
>From: ABRAHAM, KISHON VIJAY 
>Sent: Tuesday, July 03, 2012 10:48 PM
>To: Matcovschi, Oleg
>Cc: gregkh@linuxfoundation.org; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; >Balbi, Felipe
>Subject: Re: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS or ID events

>Hi Oleg,

>On Tue, Jul 3, 2012 at 11:09 PM, Matcovschi, Oleg <oleg.matcovschi@ti.com> wrote:
>>>From: linux-omap-owner@vger.kernel.org 
>>>[linux-omap-owner@vger.kernel.org] on behalf of ABRAHAM, KISHON VIJAY
>>>Sent: Friday, June 22, 2012 5:10 AM
>>>To: gregkh@linuxfoundation.org; ABRAHAM, KISHON VIJAY; 
>>>linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; 
>>>linux-usb@vger.kernel.org; Balbi, Felipe
>>>Subject: [PATCH v3 2/5] usb: musb: twl: use mailbox API to send VBUS 
>>>or ID events
>>
>>>The atomic notifier from twl4030/twl6030 to notifiy VBUS and ID 
>>>events, is replaced by a direct call to omap musb blue.
>>
>>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>---
>>> drivers/usb/musb/omap2430.c   |   94 
>>>+++++++++++++++++++++++++---------------
>>> drivers/usb/otg/twl4030-usb.c |   46 ++++++++++----------  
>>>drivers/usb/otg/twl6030-usb.c |   47 +++++++++-----------  
>>>include/linux/usb/musb-omap.h |   30 +++++++++++++
>>> 4 files changed, 133 insertions(+), 84 deletions(-)  create mode 
>>>100644 include/linux/usb/musb-omap.h
>> .....
>> +enum omap_musb_vbus_id_status {
>> +       OMAP_MUSB_UNKNOWN = 0,
>> +       OMAP_MUSB_ID_GROUND,
>> +       OMAP_MUSB_ID_FLOAT,
>> +       OMAP_MUSB_VBUS_VALID,
>> +       OMAP_MUSB_VBUS_OFF,
>> +};
>> +
>>
>> Why did you choose to introduce OMAP_MUSB specific VBUS, ID events?
>> IMHO, it makes more sense to introduce mailbox functionality only without extra translation layer.
>> Same mailbox glue layer could be used for other PHY drivers, not just twl.

>We've decided to make twl as a comparator driver since we have a separate phy driver (not yet merged). Hence we dint >want twl to use usb_phy specific events. So if you have other PHY drivers, you can still use the OMAP_MUSB specific >events.
>Thanks
>Kishon

In other words: you are proposing to have 2 flavors of other phy drivers(OMAP and not-OMAP platform specific)...
Do you think it is necessary?
Could you please provide full description of your original problem?

Regards,
 Oleg
