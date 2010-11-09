Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0KIE5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:57:15 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45217 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab0KIE5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:57:12 -0500
Message-ID: <001601cb7fca$918dc5e0$66f8800a@maildom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: =?utf-8?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>,
        "Andy Isaacson" <adi@hexapodia.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
References: <4CC55AD9.6020800@dsn.okisemi.com> <20101103183750.GA23043@hexapodia.org> <op.vlum8dzo7p4s8u@pikus>
Subject: Re: [PATCH v7] USB device driver of Topcliff PCH
Date: Tue, 9 Nov 2010 13:57:05 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal

Thank you for your comment.
I will modify to "if-else-if-else" as follows.

-----------
if (!list_empty(&ep->queue)) {
    dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
    ret = -EAGAIN;
} else {
    if (halt) { /* halt or clear halt */
        if (ep->num == PCH_UDC_EP0)
            ep->dev->stall = 1;
        pch_udc_ep_set_stall(ep);
        pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in,
ep->num));
        ret = 0;
    } else {
        pch_udc_ep_clear_stall(ep);
        ret = 0;
    }
}
-------------

Best regards
Toshiharu Okada (OKI SEMICONDUCTOR)
-----
Date: Mon, 08 Nov 2010 12:22:51 +0100
From: "Michał Nazarewicz" <m.nazarewicz@samsung.com>
> On Wed, 03 Nov 2010 19:37:50 +0100, Andy Isaacson <adi@hexapodia.org>
wrote:
> > I think this would be clearer as
> >
> > + if (!list_empty(&ep->queue)) {
> > + dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
> > + ret = -EAGAIN;
> > + }
> > + if (halt) {
> > + if (ep->num == PCH_UDC_EP0)
> > + ep->dev->stall = 1;
> > + pch_udc_ep_set_stall(ep);
> > + pch_udc_enable_ep_interrupts(ep->dev,
> > +      PCH_UDC_EPINT(ep->in, ep->num));
> > + ret = 0;
> > + } else {
> > + pch_udc_ep_clear_stall(ep);
> > + ret = 0;
> > + }
>
> This changes the behavior of the construct though.
>
> > because:
> > 1. if (!list_empty  is a standalone check, there is no if/else if/else
> > connection between list_empty() and halt.
>
> This depends on how you look at it.  The way I see it is that there are
three
> mutually exclusive cases: the list is not empty, it is a halt, it is not a
> halt.  This way, if-else-if-else seems like a good construct to me.
>
> > 2. I prefer if (foo) {} else {} instead of if (!foo) {} else {}, unless
> > there is a significant reason to do the negated test.
>
> I agree on that though.
>
> >> + pr_debug("%s: %s", __func__, usbep->name);
> >
> > There are probably too many pr_debug() and dev_dbg()s in this driver.
> > Please reconsider which ones are appropriate for mainline.
>
> Do we really care?  Just don't define DEBUG...
>
> -- 
> Best regards,                                        _     _
> | Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
> | Computer Science,  Michał "mina86" Nazarewicz       (o o)
> +----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

