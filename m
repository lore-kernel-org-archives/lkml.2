Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab2B1NmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:42:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2B1Nl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:41:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
Date: Tue, 28 Feb 2012 13:41:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: David Laight <David.Laight@aculab.com>, baruch@tkos.co.il,
        alexander.h.duyck@intel.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, eilong@broadcom.com,
        Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, jeffrey.t.kirsher@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com> <4F4CD781.2090802@antcom.de>
In-Reply-To: <4F4CD781.2090802@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202281341.01690.arnd@arndb.de>
X-Provags-ID: V02:K0:OgX9EOAvdKOwCoTXsjrPaLv7hYVcLbd9okUpD1moVbO
 ZZiaiMDza2tGs/qoyNwEjyxQPVLWiVr0ZqRqb89aCMzUzu0+gW
 btRN50asdyeQvzu9KvyN/63PpPJE25MJAi29ZHy+I0iUmN3Czw
 K0aQI4eDGR1ojdQoRwkKZ6kO+10ewXuqfphXLAtA+0K9Z/41vg
 bm1bqxrTFdA32em/KJaG8r+VkFRuNNqb3h7D0MxgMd+lSp7sow
 /djEaWdq6N2c0OsX3DpuRlpehw5hraG3nxWupWgqWLbJmGZkMD
 PDO0YQQhx0YWqAUmooq2EagXIOUvP24ptwWT0ZdH6qNDJVpm9Q
 CYTJeT4UGrYS/p2SfrWQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 February 2012, Roland Stigge wrote:
> Yes, that's why we previously had a cmdline param for it (but removed it
> upon request from the netdev maintainer).
> 
> So if the hardware defaults to 00:00:00:00:00:00, what is the
> "consistent policy we want to enforce in all drivers"?
> 
> A link or hint would be sufficient.

I think the most common strategy for platform drivers these days is

1. use what the hardware provides
2. call of_get_mac_address(dev->of_node, ...)
3. use random_ether_addr

in that order. of_get_mac_address just returns NULL when there
is no device tree or no local-mac-address property, so you can
put it into the driver right away.

	Arnd
