Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2LCSet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:34:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39196 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LCSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:34:48 -0500
Date: Mon, 03 Dec 2012 13:34:45 -0500 (EST)
Message-Id: <20121203.133445.1850294260156519269.davem@davemloft.net>
To: tremyfr@yahoo.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        otavio@ossystems.com.br, javier@dowhile0.org, jkosina@suse.cz,
        eric.jarrige@armadeus.org, julien.boibessot@armadeus.com,
        thomas.petazzoni@free-electrons.com
Subject: Re: [PATCH] net: phy: smsc: force all capable mode if the phy is
 started in powerdown mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354394689-28281-1-git-send-email-tremyfr@yahoo.fr>
References: <1354394689-28281-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Reynes <tremyfr@yahoo.fr>
Date: Sat,  1 Dec 2012 21:44:49 +0100

>  static int smsc_phy_config_init(struct phy_device *phydev)
>  {
> -	int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> +	/*
> +	 * If the SMSC PHY is in power down mode, then set it
> +	 * in all capable mode before using it.
> +	 */
> +	int rc = phy_read(phydev, MII_LAN83C185_SPECIAL_MODES);

This is formatted poorly.  Do not put comments above the basic
block variable declarations, it looks terrible.

Also, comments in the networking code should be formatted:

	/* Like
	 * this.
	 */

	/*
	 * Not like
	 * this.
	 */

Thanks.
