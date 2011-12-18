Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1LRRGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 12:06:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57902 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751781Ab1LRRGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 12:06:50 -0500
Message-ID: <1324228007.14500.4.camel@joe2Laptop>
Subject: Re: [PATCH] m68k/irq: don't use pr_crit in an header
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, debian-kernel@lists.debian.org,
        linux-m68k@vger.kernel.org, Thorsten Glaser <tg@debian.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 18 Dec 2011 09:06:47 -0800
In-Reply-To: <20111218104248.GS24496@pengutronix.de>
References: <Pine.BSM.4.64L.1112161437090.856@herc.mirbsd.org>
	 <1324152592-1718-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <CAMuHMdXyf_ofM+y6yKrzftyKTOyrSKzW7fUVAJyY6XTV_FVhNA@mail.gmail.com>
	 <20111218104248.GS24496@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-18 at 11:42 +0100, Uwe Kleine-König wrote:
> On Sun, Dec 18, 2011 at 11:32:21AM +0100, Geert Uytterhoeven wrote:
> > 2011/12/17 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > > Using pr_crit in an header results in funny messages. Consider
> > >        #define pr_fmt(fmt) "mydriver: " fmt
> > >        #include <linux/hardirq.h>
> > > which makes the message from ack_bad_irq
> > >        mydriver: unexpected IRQ trap...
> > > so better use plain printk with KERN_CRIT directly.

Why or when is that inappropriate?

> I only wondered if it is also desirable to
> have messages in headers modified depending on the module the header is
> included in.
[]
> > Nack. Nowadays pr_crit(...) is recommended over "printk(KERN_CRIT ...)".
> I know that, I just wonder if the proponents of this recommendation are
> aware of the issue when using pr_* in headers. Joe?

I believe it to be a feature rather than a defect.

For instance:  commit 256ee435b9a9ee9cca69602fe8046b27ca99fbee

    netdevice: Convert printk to pr_info in netif_tx_stop_queue
    
    This allows any caller to be prefaced by any specific
    pr_fmt to better identify which device driver is using
    this function inappropriately. 

cheers, Joe

