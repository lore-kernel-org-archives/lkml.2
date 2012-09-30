Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2I3ID1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:03:27 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:57789 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2I3IDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:03:21 -0400
Message-ID: <5067FCC5.5090206@asyr.hopto.org>
Date: Sun, 30 Sep 2012 11:03:17 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org> <20120924231216.GA20015@electric-eye.fr.zoreil.com> <20120925095403.GA29497@electric-eye.fr.zoreil.com> <5061AC2D.6030407@asyr.hopto.org> <20120925205342.GA11361@electric-eye.fr.zoreil.com> <5062957C.7080508@asyr.hopto.org>
In-Reply-To: <5062957C.7080508@asyr.hopto.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 09/26/2012 08:41 AM Thanasis wrote the following:
> on 09/25/2012 11:53 PM Francois Romieu wrote the following:
>> Thanasis <thanasis@asyr.hopto.org> :
>> [...]
>>> Ping failed in the following step:
>>>
>>> HEAD is now at 3c6ad46 r8169: move rtl_set_rx_mode before its
>>> rtl_hw_start callers.
>>
>> *spleen*
>>
>> It's a genuine code move without any real change. Imho it's more a
>> matter of sleeping a few seconds for the link to settle after the
>> device is brought up.
>>
>> The differences between the top-most r8169 driver you tried and the
>> real v3.5.4 r8169 driver are minor : mostly Ben Grear's corrupted
>> frames rx work (default: disabled) and a skb_timestamp which comes
>> too late in your setup.
>>
>> So, either your problem lacks of reproducibility with 3.5.4 - cold reboot,
>> driver which does not fail the first time - or it needs something else
>> in the kernel to happen.
>>
>> The "PME# disabled" messages have disappeared between 2.6 and 3.5.4 in your
>> dmesg. It's probably due to a dev_dbg/dev_printk + CONFIG_DYNAMIC_DEBUG
>> change. It's still worth checking runtime pm settings though
>>
> 
> Sorry but I don't understand much of what you said above...
> 
>> Can you check the content of /sys/class/pci_bus/0000:02/power, set it
>> to "on" if it contains "auto" and plug the cable again (with 3.5.4) ?
>>
> 
> I changed /sys/class/pci_bus/0000\:02/power/control from auto to on,
> did unplug and plug the cable again, also I manually assigned thte IP
> address to the NIC, but it did not make it work.
> 
> Here is the situation in /sys/class/pci_bus/0000\:02/power:
> 
> atom ~ # ls /sys/class/pci_bus/0000\:02/power
> autosuspend_delay_ms  control  runtime_active_time  runtime_status
> runtime_suspended_time
> atom ~ # cat /sys/class/pci_bus/0000\:02/power/*
> cat: /sys/class/pci_bus/0000:02/power/autosuspend_delay_ms: Input/output
> error
> on
> 0
> unsupported
> 0
> atom ~ # cat /sys/class/pci_bus/0000\:02/power/runtime_status
> unsupported
> atom ~ # cat /sys/class/pci_bus/0000\:02/power/control
> on
> atom ~ # cat /sys/class/pci_bus/0000\:02/power/runtime_active_time
> 0
> atom ~ # cat /sys/class/pci_bus/0000\:02/power/runtime_suspended_time
> 0
> atom ~ #
> 
> I attach the dmesg where it can be seen that the card every few seconds
> reports:
> r8169 0000:02:00.0: eth0: link up
> r8169 0000:02:00.0: eth0: link up
> r8169 0000:02:00.0: eth0: link up
> r8169 0000:02:00.0: eth0: link up
> ...
> 

Any news about the issue?
Should we file a bug?


