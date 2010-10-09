Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0JILLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:11:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0JILLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:11:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Date: Sat, 9 Oct 2010 13:11:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, "linux-main" <linux-kernel@vger.kernel.org>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
In-Reply-To: <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201010091311.26335.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:RuzcrmNTNpavP08k/Shgzz+tW3+05Hya08b+/WgJUAp
 udF+7yfnFxl6tMnModJY38gQxzg5/aGuWkbGhrgQ8QCjv0m05D
 u1Bt/z0VO7qsNILfvaRgomjoXOB0PtjFYgyvyxXMe+UFcUQO8n
 Go7+ophrTIrcVM4QuqcYaSp4/WglLYBLHqFlyNdH4fsWOKarcv
 3ZnWGSDO4ajWDIGWs+3uQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 October 2010 12:28:19 Felipe Contreras wrote:
> Also, what do you think is the right attitude? Do you think all
> driver writers should follow each and every patch on the mailing list
> or always try release candidates? Even if they all did (some do),
> there's no generic solution, so they all are scratching their heads
> about how to solve this. It might be crystal clear for you how such
> generic solution could be implemented, or perhaps how some of these
> drivers can be fixed individually, if so, why don't you come with a
> proposal to mitigate the pain of fixing such drivers.

Please put this into perspective, it's not like this was ever a
normal thing to do, and drivers doing an ioremap on kernel memory
would typically not make it through a review. I've looked through
the ARM specific drivers that do ioremap and practically all of
them just map their MMIO registers as they should.

The few drivers that may be hit by this are typically in drivers/staging
exactly because issues like this have not been fixed yet.

We should probably just fix the non-staging drivers that are hit by
this now and declare the issue done.

When you say that "many drivers broken", can you list the ones you know
about? It would probably help resolve this the right way.

	Arnd
