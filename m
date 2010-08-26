Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0HZQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:16:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1383 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0HZQQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:16:14 -0400
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>,
        Greg Rose <gregory.v.rose@intel.com>, Maxime Bizon <mbizon@freebox.fr>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Linn <john.linn@xilinx.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>
In-Reply-To: <20100826090504.30ce58e5@nehalam>
References: <4C763A67.5040107@dsn.okisemi.com>
	 <20100826090504.30ce58e5@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 09:16:12 -0700
Message-ID: <1282839372.1875.78.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 09:05 -0700, Stephen Hemminger wrote:
> +	for (i = 0; i < 6; i++)
> +		printk(KERN_INFO "%2.2x%c",
> +			netdev->dev_addr[i], i == 5 ? '\n' : ':');
> 
> you just want:
>          printk(KERN_INFO "%pM", netdev->dev_addr);
> 
> or better yet, convert to dev_printk

or perhaps better still convert to netdev_info

My message logging order preference:

if there's a netif_msg_<type> and a struct net_device
	netif_<level>		(struct private *, netif_msg_<type>,
				 struct net_device *, fmt, args...)
if there's a struct net_device
	netdev_<level>		(struct net_device *, fmt, args...)
if there's a struct device
	dev_<level>		(struct device *, fmt, args...)
otherwise
	pr_<level>		(fmt, args...)


