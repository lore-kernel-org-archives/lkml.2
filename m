Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2DSRkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:40:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46800 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754674Ab2DSRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:40:14 -0400
Date: Thu, 19 Apr 2012 13:40:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grzegorz Nosek <root@localdomain.pl>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <support@supermicro.com>
Subject: Re: EHCI software retries break Supermicro IPKVM
In-Reply-To: <4F902F60.4080709@localdomain.pl>
Message-ID: <Pine.LNX.4.44L0.1204191337520.2070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Grzegorz Nosek wrote:

> Hi,
> 
> (Supermicro support: cc'd as you might be interested)
> 
> Commit a2c2706e1043c17139c2dafd171c4a5cf008ef7e introduced software
> retries for transient USB errors. Unfortunately, it turns out that
> this change breaks the Supermicro AOC SIMSO IPKVM board plugged into
> a SYS-6015B-3R server, X7DBR-3 board. It renders unusable both the
> keyboard and media redirection as soon as the kernel boots (display
> works fine). An excerpt from dmesg:
> 
> [   76.587521] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
...
> [   76.591264] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
> [   76.591388] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
> [   76.591402] usb 1-7: can't set config #1, error -71
> [   76.596519] drivers/usb/core/inode.c: creating file '007'
> [   76.596542] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
> 
> After disarming the retry logic with the patch below, the KVM works
> fine again. Now, this is certainly a crude hack but apparently some
> better checks are needed to determine whether to retry the
> transaction.

Do you have any idea what's going wrong?

Can you provide complete dmesg logs for kernels both with and without
your patch (and with CONFIG_USB_DEBUG enabled)?  Maybe also usbmon 
traces too.

Alan Stern

