Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1BFTQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:16:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52052
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab1BFTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:16:30 -0500
Date: Sun, 06 Feb 2011 11:17:05 -0800 (PST)
Message-Id: <20110206.111705.183051866.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        cz-bobek-lists-aranym@lists.bobek.cz,
        schmitz@opal.biophys.uni-duesseldorf.de, pstehlik@sophics.cz,
        M.Jurik@sh.cvut.cz, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] m68k/atari: ARAnyM - Add support for network access
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296989469-7844-5-git-send-email-geert@linux-m68k.org>
References: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
	<1296989469-7844-5-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun,  6 Feb 2011 11:51:09 +0100

> +	dev->trans_start = jiffies;

Device drivers no longer make this operation, the generic code
does it (see net/core/dev.c:dev_hard_start_xmit() and how it
invokes txq_trans_update() on ->ndo_start_xmit() success).

Therefore, please remove this line.

> +	pr_debug(DRV_NAME ": send %d bytes\n", len);

For consistency with other network drivers, add an appropriate CPP
define for "pr_fmt" and use netdev_info(), netdev_debug(), etc.

In situations where a netdev pointer is not available
(ie. pre-register_netdev()), use "dev_*()" instead.

Thanks.
