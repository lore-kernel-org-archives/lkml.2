Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2ATH25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 02:28:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2ATH2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 02:28:54 -0500
Date: Thu, 19 Jan 2012 23:34:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120119233418.65995f2b.akpm@linux-foundation.org>
In-Reply-To: <20120120181131.8fc4b0b29893b614e7f1fd6e@canb.auug.org.au>
References: <20120120181131.8fc4b0b29893b614e7f1fd6e@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 18:11:31 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (s390 allmodconfig)
> failed like this:
> 
> drivers/leds/leds-ot200.c: In function 'ot200_led_brightness_set':
> drivers/leds/leds-ot200.c:114: error: implicit declaration of function 'outb'
> 
> Caused by commit 891b7aeff9fe ("leds: add led driver for Bachmann's ot200").

Like this?

--- a/drivers/leds/Kconfig~leds-add-led-driver-for-bachmanns-ot200-fix
+++ a/drivers/leds/Kconfig
@@ -405,7 +405,7 @@ config LEDS_MAX8997
 
 config LEDS_OT200
 	tristate "LED support for the Bachmann OT200"
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS && HAS_IOMEM
 	help
 	  This option enables support for the LEDs on the Bachmann OT200.
 	  Say Y to enable LEDs on the Bachmann OT200.

