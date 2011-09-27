Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1I0N5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:57:10 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:54131 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab1I0N5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:57:08 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
 <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com> <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
 <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com> <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com>
 <cbad72cea703d117067f7c628f7db806@mail.gmail.com> <1317127327.3820.31.camel@sokoban>
 <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com> <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acx9GOKFkQqiD1MJS8q2Nwb6ed5v0gAAtUGw
Date: Tue, 27 Sep 2011 19:27:03 +0530
Message-ID: <0b1de2fa258335ba9f7dde3baa41cee9@mail.gmail.com>
Subject: RE: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
To: balbi@ti.com, Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>, parthab@india.ti.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anand Gadiyar <gadiyar@ti.com>,
        sameo@linux.intel.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        johnstul@us.ibm.com, Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Felipe Balbi [mailto:balbi@ti.com]
>Sent: Tuesday, September 27, 2011 6:55 PM
>To: Munegowda, Keshava
>Cc: t-kristo@ti.com; Paul Walmsley; Cousson, Benoit; Basak, Partha;
>Balbi, Felipe; parthab@india.ti.com; linux-usb@vger.kernel.org; linux-
>omap@vger.kernel.org; linux-kernel@vger.kernel.org; Gadiyar, Anand;
>sameo@linux.intel.com; tony@atomide.com; Hilman, Kevin;
>johnstul@us.ibm.com; Sripathy, Vishwanath
>Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod
>structures for omap3
>
>Hi,
>
>On Tue, Sep 27, 2011 at 06:48:35PM +0530, Munegowda, Keshava wrote:
>> > So, you would need a mechanism to do something like this:
>> >
>> > pad a or b wakeup detected -> irq0
>> > pad c or d wakeup detected -> irq1?
>>
>> yes, if get something like this , its perfect.
>
>can't you have different IRQs for each pad ? I mean, allocate one
>irq_desc for each pad and let drivers request a pad/pin as an IRQ
>source. Then, when you detect a pad wakeup, you can:
>
>unsigned	pad_irq = pad_number - pad->irq_base;
>
>handle_nested_thread(pad_irq);
>
>this will make use of threaded IRQ handlers even. Could it be something
>like that ?

Felipe, your suggestion would mean more design change from the existing
implementation of Tero.

I would propose something like what Tero said initially:
For each mux-info have an associated irq handler.
So, say pads a..d form mux info1. This gets associated to irq_handler1.
Similarly, say pads e..h form mux info2. This gets associated to
irq_handler2.
Both get associated to the same uhh_hwmod. Now, when chain handler scans
for wakeup sources,
it scans both mux-info1 & mux-info2.
If at-least one pad in mux-info1 is woken up, irqhandler1 is called & same
for irqhandler2.
This mechanism would need multiple mux-infos to be attached to the same
hwmod.

So, fundamentally, if we are in alignment, can we go ahead now to collapse
the ehci & ohci hwmods into one?

>
>--
>balbi
