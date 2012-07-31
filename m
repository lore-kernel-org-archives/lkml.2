Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab2GaUPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:15:10 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2GaUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:15:07 -0400
Message-ID: <1343765698.4474.10.camel@jlt3.sipsolutions.net>
Subject: Re: wlcore: might_sleep operation in interrupt handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Yefremov <yefremov.denis@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Date: Tue, 31 Jul 2012 22:14:58 +0200
In-Reply-To: <CADKZ3FKDw78ac9JPXJuw0s7Mqg1RrVfonbjXZ6zHmtwF2i5HoQ@mail.gmail.com> (sfid-20120731_202836_974056_A601A727)
References: <CADKZ3FKDw78ac9JPXJuw0s7Mqg1RrVfonbjXZ6zHmtwF2i5HoQ@mail.gmail.com>
	 (sfid-20120731_202836_974056_A601A727)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 22:28 +0400, Denis Yefremov wrote:
> Interrupt handler wlcore_irq in wlcore/main.c file
> invokes mutex_lock that is might sleep operation.

> int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
> {
> ...
>         ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
>                                    irqflags,
>                                    pdev->name, wl);

Yes, umm, why do you think they're using a *threaded* IRQ? :-)

johannes

