Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2K3G7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:59:35 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:60980 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2K3G7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:59:34 -0500
Date: Fri, 30 Nov 2012 07:35:00 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Wang YanQing <udknight@gmail.com>
Cc: nic_swsd@realtek.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH]realtek:r8169: Bugfix or workaround for missing extended GigaMAC registers settings
Message-ID: <20121130063500.GA9436@electric-eye.fr.zoreil.com>
References: <20121130050619.GA12862@udknight>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130050619.GA12862@udknight>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang YanQing <udknight@gmail.com> :
[...]
> After add some debug code, I found this NIC only accept ethernet
> broadcast package, it can't filter out the package send to its
> MAC address, but it works good for sending.So ifconfig show the
> RX/TX status means it can receive ARP package.(It don't its MAC
> address, so below)

Which kernel version is it ?

[...]
> I haven't see any code to set GigaMAC registers in kernel when boot,
> so I guess BIOS or NIC's circuit make it, but of course one miss

I'd appreciate to figure it out (and understand why I did not notice
it when testing).

> the extended GigaMAC registers  in this problem. The probe code can
> get MAC address right, so MAC{0,4} must had been setted, but some
> guys forget the extended GigaMAC registers.
> 
> This patch fix it.

It is a good analysis job.

I'd rather see the GigaMAC registers written through a call to
rtl_rar_set when the mac address is read in rtl_init_one instead
of duplicating most of rtl_rar_set in a quite different place.

Hayes, can you specify if it would work or if it may mess the registers
init sequence ordering ?

Thanks.

-- 
Ueimor
