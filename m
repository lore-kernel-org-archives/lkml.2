Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1CKN4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:56:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1CKN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:56:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] tty: serial: Use hub6_serial_X when CONFIG_SERIAL_8250_HUB6 is defined
Date: Fri, 11 Mar 2011 14:56:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <20110311135024.400582fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20110311135024.400582fd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111456.15705.arnd@arndb.de>
X-Provags-ID: V02:K0:+wBtZdd5VEdnOoBtOan4vLgIT9SedG5yKkHUiun8ET7
 0j6t5N0IjP0TjJ9Cdaez4dB5lFu7F+v9p4T36ReH3cp448vgXt
 dq5odnXQub6r56nXy71wMlhWiUbIgahqgu6LO7AaNFCkFtBCqg
 KCO42RoncJbg2ncTjjPOfE515h1bY8AB1xP652AoQLGTQisx8c
 umGkULiEpACwQwl91UKVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Alan Cox wrote:
> Most of these are not needed
> 
> It is also such a miniscule amount of code it seems like it does not
> justify the complexity of being configurable this way.

The point is that the 8250 driver stands in the way of allowing
to build the kernel on architectures that do not support ISA or PCI
I/O spaces. Right now, the common solution is to do

#define inb(x) readb(void __iomem *)(x))

or some variation of this. It's fine as long as this code never gets
called, but incorrect nonetheless.

I think it would be much cleaner if architectures that cannot do this
would not have to define those functions and we could make sure that
all drivers that do inb() have correct Kconfig dependencies.

	Arnd
