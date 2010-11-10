Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0KJMaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:30:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42259 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0KJMaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:30:02 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 10 Nov 2010 13:29:58 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH v7] USB device driver of Topcliff PCH
In-reply-to: <001601cb7fca$918dc5e0$66f8800a@maildom.okisemi.com>
To: Andy Isaacson <adi@hexapodia.org>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Message-id: <op.vlyfn8qo7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.63 (Linux)
References: <4CC55AD9.6020800@dsn.okisemi.com>
 <20101103183750.GA23043@hexapodia.org> <op.vlum8dzo7p4s8u@pikus>
 <001601cb7fca$918dc5e0$66f8800a@maildom.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 05:57:05 +0100, Toshiharu Okada <toshiharu-linux@dsn.okisemi.com> wrote:
> I will modify to "if-else-if-else" as follows.

> if (!list_empty(&ep->queue)) {
>     dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
>     ret = -EAGAIN;
> } else {
>     if (halt) { /* halt or clear halt */
>         if (ep->num == PCH_UDC_EP0)
>             ep->dev->stall = 1;
>         pch_udc_ep_set_stall(ep);
>         pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in,
> ep->num));
>         ret = 0;
>     } else {
>         pch_udc_ep_clear_stall(ep);
>         ret = 0;
>     }
> }

In that case, make it:

if (list_empty(&ep->queue)) {
	if (halt) { /* halt or clear halt */
		if (ep->num == PCH_UDC_EP0)
			ep->dev->stall = 1;
		pch_udc_ep_set_stall(ep);
		pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in, ep->num));
	} else {
		pch_udc_ep_clear_stall(ep);
	}
	ret = 0;
} else {
	dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
	ret = -EAGAIN;
}

Ie. no need to put "ret = 0;" twice in the code.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
