Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2BTAGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:06:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40719 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2BTAGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:06:13 -0500
Date: Sun, 19 Feb 2012 19:05:04 -0500 (EST)
Message-Id: <20120219.190504.1559694496609520740.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: vapier@gentoo.org, sonic.zhang@analog.com, jeffrey.t.kirsher@intel.com,
        bob.liu@analog.com, uclinux-dist-devel@blackfin.uclinux.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] adi: adapt to eth_hw_addr_random() and changes
 in arch/blackfin
From: David Miller <davem@davemloft.net>
In-Reply-To: <201202171157.55585.danny.kukawka@bisect.de>
References: <1329412171-20704-3-git-send-email-danny.kukawka@bisect.de>
	<CAMjpGUdAe66Nw16EyM1_dv4e8uHV02tcfqiuWL8ipeUrQ=HThg@mail.gmail.com>
	<201202171157.55585.danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 16:05:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 11:57:54 +0100

> On Freitag, 17. Februar 2012, Mike Frysinger wrote:
>> On Thu, Feb 16, 2012 at 12:09, Danny Kukawka wrote:
>> > +                       netdev_warn(ndev, "Setting Ethernet MAC to a
>> > random one\n"); +                       eth_hw_addr_random(ndev);
>>
>> would it make sense to have the core dump the warning ?
> 
> Maybe. Many drivers already print information about setting a random mac 
> address to a netdevice. Some with printk, some via 
> netdev_warn/netdev_info/netdev_dbg or netif_dbg and other with costum 
> methods. I could unify this, in a next step with a netdev_info in 
> eth_hw_addr_random(), if it's okay for David. 

All of these log messages are stupid and should be removed.

If someone is seriously interested in it, we have the damn random
address boolean state which can be inspected in the sysfs addr_assign_type
node for the device.

End of story.
