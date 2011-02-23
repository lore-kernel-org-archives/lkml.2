Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1BWJ7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:59:22 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50822 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1BWJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:59:20 -0500
Date: Wed, 23 Feb 2011 10:55:38 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hans Nieser <hnsr@xs4all.nl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Mass udp flow reboot linux with RealTek RTL-8169 Gigabit
Message-ID: <20110223095538.GA12662@electric-eye.fr.zoreil.com>
References: <1298396007.23906.27.camel@krikkit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298396007.23906.27.camel@krikkit>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Nieser <hnsr@xs4all.nl> :
[...]
> With your patches applied to 2.6.38-rc6, I have gathered some of the
> info you requested from Seblu as well, I hope it's helpful:
> 
> 1: see attachment

Ok.

The chipset requires no trivial last minute regression fix (yet).

> 2: I'm not sure how to check the size of the packets, but I'm just
> fetching a (large) file over http/tcp, so I guess they are mostly of the
> size of my MTU which is 1500 looking at ifconfig output

Fine.

Your testcases are always based on a real download, whence including some
disk activity, as opposed to a pure network test, right ?

> For the other vmstat/ethtool/interrupts output, I started the following
> commands remotely via ssh a second or two before starting the download,
> and the machine locked up a few seconds later:

SysRq is enabled (/etc/sysctl.conf::kernel.sysrq = 1), the computer was
switched back on a no-X console before the test. Then the keyboard leds
ignore keypresses and the sysrq keys don't display anything in the
console, right ?

You may enable PCIEASPM_DEBUG, force 'pcie_aspm=off' and switch from
SLUB to SLAB but it's a bit cargo-cultish.

A bisection could help. Bisecting 2.6.35 .. 2.6.35.9 may be enough if
2.6.35.9 works well.

-- 
Ueimor
