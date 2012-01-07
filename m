Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2AGUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 15:09:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2AGUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 15:09:57 -0500
Date: Sat, 07 Jan 2012 12:09:47 -0800 (PST)
Message-Id: <20120107.120947.1387951434734479835.davem@davemloft.net>
To: cesarb@cesarb.net
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r6040: fix typo in use of MCR0 register bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1325949197-10143-1-git-send-email-cesarb@cesarb.net>
References: <1325949197-10143-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 07 Jan 2012 12:09:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Sat,  7 Jan 2012 13:13:17 -0200

> Commit 4e16d6ebd65b4f2c4e3f780b4c5704beef64019c (r6040: define more MCR0
> register bits) added #define values for MCR0 register bits and converted
> uses of hardcoded magic values to uses of these defines.
> 
> However, one of the conversions looks suspicious:
> 
>  #define MCR0		0x00	/* Control register 0 */
> +#define  MCR0_RCVEN	0x0002	/* Receive enable */
> +#define  MCR0_XMTEN	0x1000	/* Transmission enable */
> 
>  	/* Init RDC private data */
> -	lp->mcr0 = 0x1002;
> +	lp->mcr0 = MCR0_XMTEN | MCR0;
> 
> I believe what was meant here was MCR0_XMTEN | MCR0_RCVEN, which makes
> sense and matches the original values.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Good catch, applied, thanks a lot.
