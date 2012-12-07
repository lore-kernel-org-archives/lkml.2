Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2LGUIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:08:25 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:38634 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2LGUIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:08:24 -0500
Message-ID: <50C24C44.8000809@tlinx.org>
Date: Fri, 07 Dec 2012 12:06:28 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: BUG: scheduling while atomic: ifup-bonding/3711/0x00000002 -- V3.6.7
References: <50B5248A.5010908@tlinx.org> <CAM_iQpUW2Oz9p0K0gGKc6JoD7WAu0kJtRa4uBSe+WfXg0Nn3jA@mail.gmail.com> <50B67F6B.6050008@tlinx.org> <50B6B4B6.3070304@tlinx.org> <4913.1354154236@death.nxdomain>
In-Reply-To: <4913.1354154236@death.nxdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.... my distro (Suse) has made rebooting my system
a chore (have to often boot from rescue to get it to come up because
they put mount libs in /usr/lib expecting they will always boot
from their ram disk -- preventing those of use who boot directly
from disk from doing so easily...grrr.

Jay Vosburgh wrote:
> 	The miimon functionality is used to check link state and notice
> when slaves lose carrier.
---
    If I am running 'rr' on 2 channels -- specifically for the purpose
of link speed aggregation (getting 1 20Gb channel out of 2 10Gb channels)
I'm not sure I see how miimon would provide benefit.  -- if 1 link dies,
the other, being on the same card is likely to be dead too, so would
it really serve a purpose?


>   Running without it will not detect failure of
> the bonding slaves, which is likely not what you want.  The mode,
> balance-rr in your case, is what selects the load balance to use, and is
> separate from the miimon.
>   
----
    Wouldn't the entire link die if a slave dies -- like RAID0, 1 disk
dies, the entire link goes down? 

    The other end (windows) doesn't dynamically config for a static-link
aggregation, so I don't think it would provide benefit.

> 	That said, the problem you're seeing appears to be caused by two
> things: bonding holds a lock (in addition to RTNL) when calling
> __ethtool_get_settings, and an ixgbe function in the call path to
> retrieve the settings, ixgbe_acquire_swfw_sync_X540, can sleep.
>
> 	The test patch above handles one case in bond_enslave, but there
> is another case in bond_miimon_commit when a slave changes link state
> from down to up, which will occur shortly after the slave is added.
>   
----
    Added your 2nd patch -- no more error messages...

    however -- likely unrelated, the max speed read or write I am seeing
is about 500MB/s, and that is rare -- usually it's barely <3x a 1Gb 
network speed. (119/125 MB R/W).  I'm not at all sure it's really 
combining the links
properly.  Anyway to verify that?


    On the windows side it shows the bond-link as a 20Gb connection, but
I don't see anyplace for something similar on linux. 



