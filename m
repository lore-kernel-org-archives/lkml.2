Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1CKOQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:16:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1CKOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:16:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] tty: serial: Fix build on architecture that does not have ioport
Date: Fri, 11 Mar 2011 15:16:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <1299848292-17101-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <20110311135414.2725b861@lxorguk.ukuu.org.uk>
In-Reply-To: <20110311135414.2725b861@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111516.19155.arnd@arndb.de>
X-Provags-ID: V02:K0:aCgM72WTKGU6WIM5W1hzJ6thBP3ADGqVImoy7pIZ6U2
 gO9nDkD2e5QkIYBQT0llBLARedCp43zzKafswYvLFZ4pVE8ZB+
 hItG+eKzy4vcEXmDdZwiOeSWt9vFYJUoskQRVuc+UvykqnX9HE
 TcpC7+zndpxzHbsTZqFaTyunM8xd5g9ZhORM/GxE+vxic/yE5i
 tKKK7vIfl2CC0QrKa1FWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Alan Cox wrote:
> > Some CPU's do not have ioport. Therefore, these do not have inX/outX.
> 
> The results of doing that are usually horrible and add a lot of
> configuration and ifdefs.

I guess a different implementation of this patch could convert the
driver to use ioport_map and ioread/iowrite to get rid of the
#ifdef. This might even make the driver simpler because it
does not have to special-case mmio vs. pio accesses.

Note that the 8250 driver is the basically the only driver that
uses inb/outb that can be built without setting CONFIG_ISA
or CONFIG_PCI.
 
> You will then get a backtrace if the methods are called rather than
> having to hack all the drivers. In addition if your platform ever has a
> PCI bridge attached to it you will now be able to replace those methods
> and provide PCI I/O space access, as you will need for many PCI devices.

That does not seem easier than writing new I/O space functions and
removing CONFIG_NO_IOPORT.

	Arnd
