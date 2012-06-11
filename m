Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2FKIKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:10:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40611 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2FKIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:10:30 -0400
Date: Mon, 11 Jun 2012 01:10:26 -0700 (PDT)
Message-Id: <20120611.011026.1545016970136342488.davem@davemloft.net>
To: stigge@antcom.de
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple
 pr_warn()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339401793-12258-1-git-send-email-stigge@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Mon, 11 Jun 2012 10:03:11 +0200

> A WARN() trace indicating a "BUG!" was identified as a "normal" case in the
> xmit function in case all TX descriptors are occupied already. In this case,
> NETDEV_TX_BUSY is returned, nothing buggy at all.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

This is not normal.

Read the comment above this code you are changing.  If we are
out of TX descriptors, the queue must be stopped, and therefore
if the queue is stopped this transmit method should not be
invoked.

It is a hard error condition, should never occur, and indicates
a very serious error condition in the driver.
