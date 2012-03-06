Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab2CFKoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:44:03 -0500
Received: from antcom.de ([188.40.178.216]:44082 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905Ab2CFKoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:44:00 -0500
Message-ID: <4F55EA6D.3070602@antcom.de>
Date: Tue, 06 Mar 2012 11:43:57 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, baruch@tkos.co.il,
        joe@perches.com
Subject: Re: [PATCH v4] lpc32xx: Added ethernet driver: smp_wmb()
References: <1330983641-32622-1-git-send-email-stigge@antcom.de> <1330987524.2538.61.camel@bwh-desktop>
In-Reply-To: <1330987524.2538.61.camel@bwh-desktop>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 11:45 PM, Ben Hutchings wrote:
>> +	/* Clear and enable interrupts */
>> +	writel(0xFFFF, LPC_ENET_INTCLEAR(pldat->net_base));
>> +	lpc_eth_enable_int(pldat->net_base);
>> +
>> +	/* Get the next TX buffer output index */
>> +	pldat->num_used_tx_buffs = 0;
>> +	pldat->last_tx_idx =
>> +		readl(LPC_ENET_TXCONSUMEINDEX(pldat->net_base));
> 
> Doesn't this need to be done *before* enabling interrupts?  Also, I
> think you need an smp_wmb() so that the interrupt handler is guaranteed
> to see all these writes.

Do you mean _one_ smp_wmb() directly after lpc_eth_enable_int() (which
I'm moving behind the above code?

Note that there is no SMP in LPCs and NXP is not planning to build one
AFAIK. However, I'm fine with including smp_wmb() anyway for completeness.

Thanks in advance,

Roland
