Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2BCWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:05:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47913 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab2BCWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120202124529.3e274223@s6510.linuxnetplumber.net>
References: <20120202192115.GA8480@elliptictech.com>
	<20120202124529.3e274223@s6510.linuxnetplumber.net>
Date: Fri, 3 Feb 2012 23:05:26 +0100
Message-ID: <CAA879TM1i7prdY_=o2NYPYd5U2NuyyvMstT-qFoF1===qfQekA@mail.gmail.com>
Subject: Re: Sudden kernel panic with skge in 3.3-rc2
From: Guillaume Chazarain <guichaz@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 9:45 PM, Stephen Hemminger <shemminger@vyatta.com> wrote:
> Try reverting this commit, it seems problematic
> commit d0249e44432aa0ffcf710b64449b8eaa3722547e

Reverting this commit fixed skge for me. The NIC stopped working after
a kernel upgrade with nothing interesting in dmesg:

skge: 1.14 addr 0xfbffc000 irq 18 chip Yukon-Lite rev 9
skge 0000:03:00.0: eth0: addr 00:15:f2:46:d3:3b
skge 0000:03:00.0: eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
skge 0000:03:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present

NetworkManager would Oops during shutting down: http://i.imgur.com/eAFgM.jpg

-- 
Guillaume
