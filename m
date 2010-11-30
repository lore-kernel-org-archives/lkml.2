Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0K3ATP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:19:15 -0500
Received: from mail.candelatech.com ([208.74.158.172]:33821 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0K3ATO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:19:14 -0500
Message-ID: <4CF442FA.4070701@candelatech.com>
Date: Mon, 29 Nov 2010 16:19:06 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michael Leun <lkml20101129@newton.leun.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.35 -> 2.6.36 panic when vlan and promisc with tg3
References: <20101129201716.1d0257c4@xenia.leun.net>
In-Reply-To: <20101129201716.1d0257c4@xenia.leun.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 11:17 AM, Michael Leun wrote:
> Hi,
>
> only kernel message I was able to capture on serial were:
>
> UG: unable to handle kernel paging request at 01cc921c
> IP: [<c034bfce>] vlan_hwaccel_do_receive+0x59/0xd0
> *pdpt = 0000000036a2a001 *pde = 0000000000000000
> Oops: 0002 [#1] SMP
> last sysfs
>
> Then machine dead.
>
> In 2.6.35.x this did not happen (but vlans broken - cannot see vlan
> tags with tcpdump),

Try this patch:

http://permalink.gmane.org/gmane.linux.network/176566

It looks like this hasn't made it into stable yet?

Thanks,
Ben

>
> To reproduce:
>
> ip link set eth0 up
> vconfig add eth0 2
> ip link set eth0 promisc on
>
> Machines with these ethernet cards I've seen to be affected:
>
> Ethernet controller: Broadcom Corporation NetXtreme BCM5714 Gigabit
> Ethernet (rev a3)
>
> Ethernet controller: Broadcom Corporation NetXtreme BCM5752M Gigabit
> Ethernet PCI Express (rev 02)
>
> Machine with this card is NOT affected (no vlan hw accel?):
>
> Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast
> Ethernet PCI Express (rev 02)
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

