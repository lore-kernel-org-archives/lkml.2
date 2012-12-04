Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2LDSWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:22:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53767 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2LDSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:22:34 -0500
Date: Tue, 04 Dec 2012 13:22:27 -0500 (EST)
Message-Id: <20121204.132227.1430662061932892582.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, manabian@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] net/macb: increase RX buffer size for GEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354536943-6356-1-git-send-email-nicolas.ferre@atmel.com>
References: <1354536943-6356-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Mon, 3 Dec 2012 13:15:43 +0100

> Macb Ethernet controller requires a RX buffer of 128 bytes. It is
> highly sub-optimal for Gigabit-capable GEM that is able to use
> a bigger DMA buffer. Change this constant and associated macros
> with data stored in the private structure.
> I also kept the result of buffers per page calculation to lower the
> impact of this move to a variable rx buffer size on rx hot path.
> RX DMA buffer size has to be multiple of 64 bytes as indicated in
> DMA Configuration Register specification.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

This looks like it will waste a couple hundred bytes for 1500 MTU
frames, am I right?
