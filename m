Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1ERN7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:59:48 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:54875 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab1ERN7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:59:47 -0400
Date: Wed, 18 May 2011 16:59:45 +0300 (EEST)
From: mroos@linux.ee
To: Grant Likely <grant.likely@secretlab.ca>
cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: SBus devices sometimes detected, sometimes not
In-Reply-To: <BANLkTikhKqcpdadpM3RQdYvDrPn46_v6_Q@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1105181149290.9877@math.ut.ee>
References: <alpine.SOC.1.00.1105021259220.6200@math.ut.ee> <20110517.134312.226762699.davem@davemloft.net> <BANLkTikhKqcpdadpM3RQdYvDrPn46_v6_Q@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be good to know the exact failure mode, so we need to know if
> of_driver_match_device() is setting of_match which is subsequently
> getting cleared, or if of_driver_match_device() isn't getting called
> at all.  Meelis, can you add something like the following code to
> include/linux/of_device.h in the of_driver_match_device() function
> between the of_match_device() call and the return statement:
> 
> if (dev->of_match)
>         printk("found match; node=%s, driver=%s\n",
>                  dev->of_node->full_name, drv->name);
> 

Tried it with todays 2.6.39-rc7-00211-gc1d10d1. It was harder to 
reproduce this time, about 1 time out of 10.

In normal operation:

[   77.794877] found match; node=/sbus@1f,0/SUNW,hme@0,8c00000, driver=hme
[   77.872379] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
[   77.962865] eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:88:6d:6a

In case of error (bpp show only as an example that some things work):

[   70.312166] found match; node=/sbus@1f,0/SUNW,bpp@e,c800000, driver=bpp
[   70.389649] parport0: sunbpp at 0x1ffec800000
[   70.477720] found match; node=/sbus@1f,0/SUNW,hme@0,8c00000, driver=hme
[   70.578023] found match; node=/sbus@1f,0/QLGC,isp@1,10000, driver=qpti
[   70.915544] hme: probe of f006be34 failed with error -22
[   70.978825] qpti: probe of f00798c4 failed with error -22

-- 
Meelis Roos (mroos@linux.ee)
