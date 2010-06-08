Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0FHTeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:34:23 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:27625 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab0FHTeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:34:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH44DkxR9caZ/2dsb2JhbACeQXK/QQ6FCAQ
Date: Tue, 8 Jun 2010 21:34:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: setting miscdevice.parent after misc_register()
Message-ID: <20100608193418.GF3788@infomag.iguana.be>
References: <AANLkTilDZdke5V6TYtDheK9rCaxTDHqtoPR7I_tEvFR2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilDZdke5V6TYtDheK9rCaxTDHqtoPR7I_tEvFR2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

> In drivers/watchdog/at32ap700x_wdt.c, and drivers/watchdog/sch311x_wdt.c
> miscdevice.parent is set after misc_register().
> 
> drivers/watchdog/at32ap700x_wdt.c:
> 
> 	ret = misc_register(&wdt->miscdev);
> 	...
> 	wdt->miscdev.parent = &pdev->dev;
> 
> But it does nothing. (the miscdevice will not be a child of that parent
> device in sysfs)
> 
> So should it be set before misc_register() or just keep it as-is?

It should be fixed by setting it before the misc_register call.
I'll do the necessary.

Thanks,
Wim.

