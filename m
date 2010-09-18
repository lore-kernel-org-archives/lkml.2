Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0IRGI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 02:08:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52489
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab0IRGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 02:08:28 -0400
Date: Fri, 17 Sep 2010 23:08:46 -0700 (PDT)
Message-Id: <20100917.230846.226755853.davem@davemloft.net>
To: masa-korg@dsn.okisemi.com
Cc: randy.dunlap@oracle.com, john.linn@xilinx.com, ralf@linux-mips.org,
        kristoffer@gaisler.com, mbizon@freebox.fr, gregory.v.rose@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        okada533@dsn.okisemi.com, shimizu394@dsn.okisemi.com,
        morinaga526@dsn.okisemi.com, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        margie.foster@intel.com, arjan@linux.intel.com
Subject: Re: [PATCH v4] Gigabit Ethernet driver of Topcliff PCH
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C90CBC9.7000203@dsn.okisemi.com>
References: <4C90CBC9.7000203@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Date: Wed, 15 Sep 2010 22:36:09 +0900

> +struct pch_gbe_regs_mac_adr {
> +	u32 high;
> +	u32 low;
> +} __attribute__ ((packed));;
 ...
> +struct pch_gbe_regs {
 ...
> +} __attribute__ ((packed));
...
> +struct pch_gbe_rx_desc {
 ...
> +} __attribute__ ((packed));;
 ...
> +struct pch_gbe_tx_desc {
 ...
> +} __attribute__ ((packed));;

The packed attribute should not be necessary for any of these
datastructures, so unless you can prove they are needed please
remove the attribute tag.

Besides being unnecessary, it will make cpu access to these
descriptors extremely slow on risc cpus, as the compiler will
emit byte-at-a-time accesses for all members of the structure
larger than one byte.
