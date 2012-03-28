Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2C1CgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:36:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47867 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2C1CgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:36:04 -0400
Date: Tue, 27 Mar 2012 22:35:45 -0400 (EDT)
Message-Id: <20120327.223545.1996930432677091672.davem@davemloft.net>
To: msink@permonline.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v4] Ethernet driver for the WIZnet W5300 chip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332752876-1650-1-git-send-email-msink@permonline.ru>
References: <1332149037-12025-1-git-send-email-msink@permonline.ru>
	<1332752876-1650-1-git-send-email-msink@permonline.ru>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 19:35:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Sinkovsky <msink@permonline.ru>
Date: Mon, 26 Mar 2012 15:07:56 +0600

> +/*
> + * Frame size is hardwired to 1514 bytes (including header),
> + *  => MTU for 802.1Q frames must be set to 1500-4 = 1496
> + */
> +#define W5300_HARD_MTU		1500

I've told you that you must set the VLAN challenged feature flag
(NETIF_F_VLAN_CHALLENGED) for devices which have this restriction.

Just set that, and remove this comment, since the feature bit setting
documents this restriction fully and perfectly.
