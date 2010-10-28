Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab0J1Tf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:35:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:44255 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab0J1TfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:35:24 -0400
X-SpamScore: -11
X-BigFish: VS-11(z3b68iz1432N98dNzz1202hzzz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4CC9D074.3060108@freescale.com>
Date: Thu, 28 Oct 2010 14:35:16 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <20101027231948.5e62dd09@lxorguk.ukuu.org.uk>
In-Reply-To: <20101027231948.5e62dd09@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 19:35:48.0358 (UTC) FILETIME=[52742260:01CB76D7]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> drivers/mmc/card/sdio_uart.c
> 
> is in some ways the best example, it handles all the horrible cases
> including unloading of hardware v open races, its way more than you'd
> need but does illustrate it all.

Thanks Alan.  As always, you're a great help.

I've made some progress adding support for tty_port.  I'm registering the ISR in
the tty_port .activate function.

I see something weird, though.  I lose the console after I log in:

p4080 login: root
Password:
ehv_bc_tty_open:442 ttys=dce50000 stdout_irq=68
ehv_bc_tty_close:450 tty=dce50000
ls

logout
ehv_bc_tty_close:450 tty=dce50000
ehv_bc_console_device:390
ehv_bc_tty_open:442 ttys=dce50000 stdout_irq=68










p4080 login:

The "ehv_bc_..." lines are my debug printks.

When I type "ls", I don't get a listing.  The "logout" occurs after I press ^D.

-- 
Timur Tabi
Linux kernel developer at Freescale

