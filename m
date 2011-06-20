Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1FTQ6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:58:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1FTQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:58:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 18:58:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201858.45624.arnd@arndb.de>
X-Provags-ID: V02:K0:8o+AQXYYSwSwugQEDIXp4kYwpON9dUeINfbbh2wn24C
 m1VP6l9t3iNvqj4K1eFbke3heZFAlSUoBbVVhsFIjKPahBoBo0
 RahsR4Jfq6zKpMNo1UJbi7IxSzB+rHOMMf10kbgFeSERAFZKzU
 183NA8itAU/em3DZS6Wirc2+fHgn/Gb8JJMKKbK47AwdvpvpMG
 sRxlwhfG1YnUYWed7vDyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011, Alan Stern wrote:
> I thought the source of the thread had nothing to do with any recent
> changes to gcc.  Maybe I was wrong.  In any case, the issue was not the
> lack of an alignment indication but rather the unnecessary presence of
> a ((packed)) attribute causing the compiler to forget about the natural
> alignment.
> 
> To put it another way, the problem was caused by having ((packed))  
> where it wasn't needed.  You want to fix the immediate fallout of the
> problem by adding an alignment attribute, instead of fixing the problem
> itself by removing the underlying cause.

A recent change in gcc changed the default behaviour when compiling the
ehci driver on ARM, but the behaviour was already nondeterministic
because the definition of the readl/writel macros on ARM relies on
unspecified behaviour (cast to pointer with larger aligment).

We are also going to change the ARM implementation to always do 32 bit
accesses in readl/writel, but the patch that went into the ehci driver
was correct nonetheless.

	Arnd
