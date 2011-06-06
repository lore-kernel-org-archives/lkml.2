Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1FFCLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 22:11:22 -0400
Received: from trent.utfs.org ([194.246.123.103]:40731 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1FFCLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 22:11:21 -0400
Date: Sun, 5 Jun 2011 19:11:18 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linville@tuxdriver.com, LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <1307000008.29297.59.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1106051907190.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>  <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>  <1306983467.29297.51.camel@pasglop>  <alpine.DEB.2.01.1106012057130.21697@trent.utfs.org> <1307000008.29297.59.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 at 17:33, Benjamin Herrenschmidt wrote:
> It -looks- to me that something goes wrong in the tty code when a large
> file is piped through a pty, causing the kernel to hang for minutes in
> the workqueue / ldisk flush code. I've just sent an initial report to
> Alan Cox about it and am currently bisecting it.

This was the "tty vs workqueue oddities" thread, right? FWIW, 
55db4c64eddf37 ("Revert "tty: make receive_buf() return the amout of bytes 
received"") seems to have fixed it on this powerpc machine as well.

With your "ssb: pci: Don't call PCIe specific workarounds on PCI cores" 
patch applied, powerpc32 seems to be quite happy with 3.0-rc1+

Thanks,
Christian.
-- 
BOFH excuse #382:

Someone was smoking in the computer room and set off the halon systems.
