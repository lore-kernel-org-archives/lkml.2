Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2IYVMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:12:36 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:39516 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2IYVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:12:34 -0400
Date: Tue, 25 Sep 2012 22:53:42 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120925205342.GA11361@electric-eye.fr.zoreil.com>
References: <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org> <20120924231216.GA20015@electric-eye.fr.zoreil.com> <20120925095403.GA29497@electric-eye.fr.zoreil.com> <5061AC2D.6030407@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061AC2D.6030407@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
[...]
> Ping failed in the following step:
> 
> HEAD is now at 3c6ad46 r8169: move rtl_set_rx_mode before its
> rtl_hw_start callers.

*spleen*

It's a genuine code move without any real change. Imho it's more a
matter of sleeping a few seconds for the link to settle after the
device is brought up.

The differences between the top-most r8169 driver you tried and the
real v3.5.4 r8169 driver are minor : mostly Ben Grear's corrupted
frames rx work (default: disabled) and a skb_timestamp which comes
too late in your setup.

So, either your problem lacks of reproducibility with 3.5.4 - cold reboot,
driver which does not fail the first time - or it needs something else
in the kernel to happen.

The "PME# disabled" messages have disappeared between 2.6 and 3.5.4 in your
dmesg. It's probably due to a dev_dbg/dev_printk + CONFIG_DYNAMIC_DEBUG
change. It's still worth checking runtime pm settings though

Can you check the content of /sys/class/pci_bus/0000:02/power, set it
to "on" if it contains "auto" and plug the cable again (with 3.5.4) ?

-- 
Ueimor
