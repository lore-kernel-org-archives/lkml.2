Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0HBSjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:39:05 -0400
Received: from phil.doycomm.com ([66.219.128.249]:45352 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0HBSjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:39:03 -0400
Subject: Re: Linux 2.6.35
From: Donald Parsons <dparsons@brightdsl.net>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201008020748.09968.bjorn.helgaas@hp.com>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	 <201008012138.39036.bjorn.helgaas@hp.com>
	 <1280722876.5125.83.camel@falcon.homelinux.org>
	 <201008020748.09968.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 14:38:36 -0400
Message-ID: <1280774316.5098.36.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 07:48 -0600, Bjorn Helgaas wrote:

> Netconsole has special kernel support that doesn't require the normal
> networking stack to be configured, so it works quite early.  You
> would want to build your networking driver into the kernel for the
> most benefit.

I compiled network module sky2 and netconsole into kernel 2.6.35.

Inserted into kernel line:
"debug netconsole=192.168.1.10/eth0,192.168.1.5/00:11:25:aa:79:f7"

and ran on a laptop the cmd:   "nc -l -u 6666"
using all default ports if I read documentation correctly.

This failed to show any output at all. 

> If that doesn't work, you could try capturing the log on VGA with a
> digital camera or video camera, possibly with "boot_delay=" to
> slow things down.

What or how much do you want shot with my digital camera? I see
maybe 3 or 4 screens fulls go by to where boot fails.

I added "boot_delay=15" for next boot.

> > Should I try building sata driver into kernel?

I think it is already in kernel, since no sata modules load
in a booting kernel (assuming sata is part of module name).

> I doubt that will make a difference.  It seems like the problem
> is that we don't find your root filesystem, probably because there's
> something wrong with the HBA leading to that device.  For example,
> maybe the PCI core mistakenly moved or disabled the adapter, or
> there's some problem with its interrupt.

I only see one sata compiled into kernel: CONFIG_SATA_PMP=y
and I also see no sata's loaded with lsmod in a working
kernel (2.6.34.1).

I am going to rebuild again with CONFIG_SATA_AHCI=y
instead of =m as it is Fedora's config (do not know how
it got changed).   These modules are loaded in 2.6.34.1:

#lsmod | egrep "ata|ahci"
ata_generic     3427  0 
pata_acpi       3227  0 
pata_jmicron    2547  0 
ahci           35887  4 
libata        157450  4 ata_generic,pata_acpi,pata_jmicron,ahci
scsi_mod      147895  5 sg,sr_mod,usb_storage,sd_mod,libata

Thanks,
Don

