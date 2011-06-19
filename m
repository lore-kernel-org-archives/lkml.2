Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1FSLZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:25:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1FSLZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:25:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Date: Sun, 19 Jun 2011 13:25:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
References: <20110618172537.GH3441@infomag.iguana.be> <201106182107.45682.arnd@arndb.de> <20110619110328.39c0f5e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110619110328.39c0f5e1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191325.17181.arnd@arndb.de>
X-Provags-ID: V02:K0:WiQfGjc8WG/+lIZnDcOrOmF5W/Rz+favx8HgyUL+IoY
 evQL/xt+v3OQUUh4Uexg8vs+N9K0OqAoI5kylwSiq6PkOEr029
 1IT1cpl+O0gKD06xfqbB2kQTmf/SgC86D7P6PlbFj85lrfgCdC
 sJP/KDXSBje4mGpBJNMsRzrGOp0h0m/1SR8jix40WLowoRQf8w
 QBB5CTSGVZum1yGtl5YIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 12:03:28 Alan Cox wrote:
> > >         /* Register the watchdog timer device */
> > >         res = watchdog_register_device(&wdt_dev);
> > 
> > Why is this a feature of the individual drivers and not of the core?
> 
> It's a hardware dependant feature - some watchdogs cannot be stopped once
> initialized.

Ah, I see. OTOH, 80 of the 107 watchdogs in the kernel do provide it as a
module option, which indicates that there is some room for consolidation,
even if it might not be appropriate for every one of them.

> > Maybe it can be in both, so existing drivers don't need to change the user
> > interface, but new drivers don't have to provide the option individually
> > when you can simply set it for the base module.
> 
> Then you'd need an additional interface to specify which watchdog as soon
> as we support multiple watchdogs.

You can always have multiple ways of setting nowayout -- hardware requirements,
global module option, local module option, and a new ioctl command -- but
what is being used is then the logical OR of all of them.

	Arnd
