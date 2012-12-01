Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2LAQyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:54:13 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37796 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752464Ab2LAQyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:54:11 -0500
Date: Sat, 1 Dec 2012 11:54:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <50B9C545.4060808@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1212011137160.30617-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2012, Udo van den Heuvel wrote:

> > Secondly, try building a kernel with the patch below and 
> > CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
> > problem occurs.
> [root@a mesa]# dmesg|sort|uniq

The sort messes up the order of the messages.  uniq by itself would be
okay, though.  It would help if you also turn on CONFIG_PRINTK_TIME.

These lines looks significant:

> ohci_hcd 0000:00:13.0: IRQ: 44 8000001a
> ohci_hcd 0000:00:13.0: IRQ: 4 8000001a
> ohci_hcd 0000:00:13.0: IRQ: 4 8000005a
> ohci_hcd 0000:00:13.0: IRQ: 64 5a

The last one is strange.  I wouldn't expect it to appear, because 0x64
& 0x5a = 0x40 is nonzero.  But it's had to say much without knowing
where this message belongs in the log.

> I had to hurry as the debug patch overflows dmesg very quickly.
> That is the reason why the dmesg is sorted and uniq'd etc.
> I do hope there is enough info to further this issue.

No, not really.  The patch could be modified to reduce the amount of 
output, if you think that would help.

Alan Stern

