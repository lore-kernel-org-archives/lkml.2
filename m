Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2EHA2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:28:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33233 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757349Ab2EHA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:28:33 -0400
X-Sasl-enc: UQcGtBorJEEmd1ypVxMdDQ4r3r8Cz3egc/OgNoF98ckJ 1336436912
Date: Mon, 7 May 2012 17:28:30 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 2/3] kmsg: export printk records to the /dev/kmsg
 interface
Message-ID: <20120508002830.GA2204@kroah.com>
References: <1336004981.4240.10.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336004981.4240.10.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:29:41AM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: kmsg: export printk records to the /dev/kmsg interface
> 
> Support for multiple concurrent readers of /dev/kmsg, with read(),
> seek(), poll() support. Output of message sequence numbers, to allow
> userspace log consumers to reliably reconnect and reconstruct their
> state at any given time. After open("/dev/kmsg"), read() always
> returns *all* buffered records. If only future messages should be
> read, SEEK_END can be used. In case records get overwritten while
> /dev/kmsg is held open, or records get faster overwritten than they
> are read, the next read() will return -EPIPE and the current reading
> position gets updated to the next available record. The passed
> sequence numbers allow the log consumer to calculate the amount of
> lost messages.
> 
>   [root@mop ~]# cat /dev/kmsg
>   5,0,0;Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...
>   6,159,423091;ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>   7,160,424069;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
>    SUBSYSTEM=acpi
>    DEVICE=+acpi:PNP0A03:00
>   6,339,5140900;NET: Registered protocol family 10
>   30,340,5690716;udevd[80]: starting version 181
>   6,341,6081421;FDC 0 is a S82078B
>   6,345,6154686;microcode: CPU0 sig=0x623, pf=0x0, revision=0x0
>   7,346,6156968;sr 1:0:0:0: Attached scsi CD-ROM sr0
>    SUBSYSTEM=scsi
>    DEVICE=+scsi:1:0:0:0
>   6,347,6289375;microcode: CPU1 sig=0x623, pf=0x0, revision=0x0

Can you add a file somwhere in Documentation (Documentatin/ABI?) that
documents the file format for this file?

Other than that, nice, I've queued all of these up.

thanks,

greg k-h
