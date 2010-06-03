Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0FCHyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:54:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57272 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0FCHyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K1rjdnAf09eyL9m5xG2IqPCmLeBt+LWna2nNrewcQDNww0JYQhmGLQgpD2Ug96tZoE
         SsGN6ewa0FzUp58cl+Eey9ksxDvwkYBZ33N0SrVQcev1QMhb3RGBEdR6oEO+Lx0U8BTM
         yB8KsobecoYlnsC8zdhQIU5yDHF6hyot5CA5c=
Date: Thu, 3 Jun 2010 11:54:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jgarzik@redhat.com
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603075402.GA11093@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 03:02:25PM +0800, Luming Yu wrote:
> Hi there,
> 
> I happened to notice that the commit 365cfa1ed5 caused the following
> boot error with 2.6.25-rc1
> on a system with ICH10 SATA AHCI controller. It's weird if there is
> really no function changes in the patch.
> 
> Any ideas?
> 
> 
> dracut: Starting plymouth daemon
> pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> scsi0 : pata_jmicron
> Initializing USB Mass Storage driver...
> scsi1 : usb-storage 1-5:1.0
> scsi2 : pata_jmicron
> ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
> ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> scsi 1:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
> sr0: scsi-1 drive

Can you provide full boot log (dmesg) please?

I wonder if you're using ahci.ignore_sss and/or ahci.skip_host_reset
kernel command line options or module params. You should probably use
libahci.* for these now.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
