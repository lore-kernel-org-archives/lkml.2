Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0IABdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:33:36 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48684 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0IABde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:33:34 -0400
Date: Tue, 31 Aug 2010 18:33:31 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] drivers/net/pch_gbe: Cleanup stats use
Message-ID: <20100831183331.5a6aa508@nehalam>
In-Reply-To: <1283279915.1797.66.camel@Joe-Laptop>
References: <4C763A67.5040107@dsn.okisemi.com>
	<4C7D0E7A.5060309@dsn.okisemi.com>
	<1283271009.1797.28.camel@Joe-Laptop>
	<1283275514.1797.36.camel@Joe-Laptop>
	<1283279915.1797.66.camel@Joe-Laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 11:38:35 -0700
Joe Perches <joe@perches.com> wrote:

>  struct pch_gbe_stats {
> -	signed char stat_string[ETH_GSTRING_LEN];
> -	int sizeof_stat;
> -	int stat_offset;
> +	signed char string[ETH_GSTRING_LEN];
> +	size_t size;
> +	size_t offset;
>  };

Is this driver really using 'signed char' here?
Should just be 'char' for a simple string.
