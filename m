Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1ITLW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:22:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1ITLW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:22:56 -0400
Message-ID: <4E78775F.9020501@ru.mvista.com>
Date: Tue, 20 Sep 2011 15:22:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        stable@kernel.org, Andiry Xu <andiry.xu@amd.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 2/3] USB: xhci: Set change bit when warm reset change
 is set.
References: <20110919230833.469891151@clark.kroah.org>
In-Reply-To: <20110919230833.469891151@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-09-2011 3:05, Greg KH wrote:

    From: line is missing?

> Sometimes, when a USB 3.0 device is disconnected, the Intel Panther Point
> xHCI host controller will report a link state change with the state set
> to "SS.Inactive".  This causes the xHCI host controller to issue a warm
> port reset, which doesn't finish before the USB core times out while
> waiting for it to complete.

> When the warm port reset does complete, and the xHC gives back a port
> status change event, the xHCI driver kicks khubd.  However, it fails to
> set the bit indicating there is a change event for that port because the
> logic in xhci-hub.c doesn't check for the warm port reset bit.

> After that, the warm port status change bit is never cleared by the USB
> core, and the xHC stops reporting port status change bits.  (The xHCI spec
> says it shouldn't report more port events until all change bits are
> cleared.)  This means any port changes when a new device is connected will
> never be reported, and the port will seem "dead" until the xHCI driver is
> unloaded and reloaded, or the computer is rebooted.  Fix this by making
> the xHCI driver set the port change bit when a warm port reset change bit
> is set.

> A better solution would be to make the USB core handle warm port reset in
> differently, merging the current code with the standard port reset code
> that does an incremental backoff on the timeout, and tries to complete the
> port reset two more times before giving up.  That more complicated fix
> will be merged next window, and this fix will be backported to stable.

> This should be backported to kernels as old as 3.0, since that was the
> first kernel with commit a11496ebf37534177d67222285e8debed7a39788
> "xHCI: warm reset support".

> Signed-off-by: Sarah Sharp<sarah.a.sharp@linux.intel.com>
> Cc: stable@kernel.org
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>

WBR, Sergei

