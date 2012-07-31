Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2GaUsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:48:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62194 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2GaUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <1343765698.4474.10.camel@jlt3.sipsolutions.net>
References: <CADKZ3FKDw78ac9JPXJuw0s7Mqg1RrVfonbjXZ6zHmtwF2i5HoQ@mail.gmail.com>
	<1343765698.4474.10.camel@jlt3.sipsolutions.net>
Date: Wed, 1 Aug 2012 00:48:17 +0400
Message-ID: <CADKZ3FLs444RfLx=RyBPKs+Lza_mZHhT=zHauMt3BUnqAUtY0w@mail.gmail.com>
Subject: Re: wlcore: might_sleep operation in interrupt handler
From: Denis Yefremov <yefremov.denis@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More precise (IRQF_ONESHOT flag may be used):

int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
{
...
        if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
                irqflags = IRQF_TRIGGER_RISING;
        else
                irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;

        ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
                                   irqflags,
                                   pdev->name, wl);


2012/8/1 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2012-07-31 at 22:28 +0400, Denis Yefremov wrote:
>> Interrupt handler wlcore_irq in wlcore/main.c file
>> invokes mutex_lock that is might sleep operation.
>
>> int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
>> {
>> ...
>>         ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
>>                                    irqflags,
>>                                    pdev->name, wl);
>
> Yes, umm, why do you think they're using a *threaded* IRQ? :-)
>
> johannes
>
