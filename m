Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1G0UPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:15:40 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:2324 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab1G0UPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:15:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJlxME5tgyRT/2dsb2JhbAA1AQVAICURCVUUASoDKgGnYHiIfsFWDoVTXwSjWQ
Date: Wed, 27 Jul 2011 22:15:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/9 v4] Generic Watchdog Timer Driver
Message-ID: <20110727201537.GA13819@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be> <20110711213145.GB5811@pengutronix.de> <20110722191847.GI31767@infomag.iguana.be> <20110722193857.GU3834@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722193857.GU3834@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common
watchdog timer driver functions. The changes from the third post have been incorporated.

The code is ready to be sent upstream, but just to be sure I sent out this last version anyway.

This framework/API consists of the following patches:
part 1: Introduction of the WatchDog Timer Driver Core
part 2: Add the basic ioctl functionality
part 3: Add the WDIOC_KEEPALIVE ioctl
part 4: Add the WDIOC_SETOPTIONS ioctl
part 5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
part 6: Add the Magic Close feature
part 7: Add the nowayout feature
part 8: Add support for extra ioctl calls
part 9: Add the minimum and maximum timeout parameters.

The code is added to linux-2.6-watchdog-next since this weekend.

Changes since V3:
* removed overdocumentation
* removed MODULE_SUPPORTED_DEVICE and MODULE_ALIAS_MISCDEV
* removed return -ENOTTY after switch (cmd) because we have the default allready
* s/sent/send/
* I'd suggest to swap the logic here (branch taken on error)
* no_llseek removal squashed into patch 1
* provide getter/setter methods for driver specific data so that we can easily do the conversion towards the device driver model
* removed parent because this would change when we will start using the device driver model
* Changed CONFIG_WATCHDOG_CORE from tristate to bool
* Added Docbook documentation for include/linux/watchdog.h

Kind regards,
Wim.

