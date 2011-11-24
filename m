Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1KXNqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:46:08 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:39369 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab1KXNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:46:05 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGtJzk5tg6zW/2dsb2JhbAA7CKpxgQaBcgEBBAE6HCMFCwgDRhQlAyGIGAK0eRKHH4MxBJRJkg0
Date: Thu, 24 Nov 2011 14:42:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: w.sang@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111124134247.GS23376@infomag.iguana.be>
References: <20111122173227.GK6624@sirena.org.uk> <20111122184051.GA30941@pengutronix.de> <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com> <20111123124037.GN23376@infomag.iguana.be> <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com> <20111123214614.GQ23376@infomag.iguana.be> <4ece231e./LkW+9i4Wmz+9zzn%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ece231e./LkW+9i4Wmz+9zzn%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> I have tested your version and it works fine. I saw that you enforced
> the NO_WAY_OUT bit and implemented the KEEPALIVEPING and MAGICCLOSE
> features properly. Many thanks.

No problem.

> Regarding the timer, the driver can not read the timeout value set in
> the BIOS, so there is still a risk of reboot if the BIOS value is lower
> than driver one. I assume that other drivers may be in the same case,
> and that is required for user compatibility anyway.

The driver assumes 1 second as heartbeat of the watchdog device.
It thus takes half of this time do actually 'tickle' the watchdog. (or 500ms).
We should set this 1 second value to the smallest time that is possible (either
the smallest value that can be set in the BIOS or the smallest value that is
listed in the datasheets).

> Here is the comment block that I propose to insert regarding register
> programming issues:
> 
> /*
>  * Caveat: the only known way to activate the watchdog timer or to set
>  * its period is through BIOS configuration, when the hardware supports it.
>  * It seems that the watchdog control registers are locked and disabled if
>  * the watchdog is not exposed or enabled by BIOS, and that writing them is
>  * useless. No public documentation is available regarding this limitation.
>  */

Looks good. I will add this. Just let me know what the smallest value is for
the timeout in the BIOS and/or datasheet and I will do the necessary for inclusion
in the watchdog tree.

Kind regards,
Wim.

