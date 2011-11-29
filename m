Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1K2TnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:43:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab1K2TnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:43:15 -0500
Date: Tue, 29 Nov 2011 14:47:25 -0500 (EST)
Message-Id: <20111129.144725.183069721.davem@davemloft.net>
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org, sjurbren@gmail.com,
        pebolle@tiscali.nl, netdev@vger.kernel.org
Subject: Re: [RFCv2 9/9] caif-xshm: Add CAIF driver for Shared memory for
 M7400
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322595550-6473-10-git-send-email-sjur.brandeland@stericsson.com>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
	<1322595550-6473-10-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 11:43:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>
Date: Tue, 29 Nov 2011 20:39:10 +0100

> This patch introduces a caif shared memory link layer driver
> for ST-Ericsson's Thor M7400 LTE modem.
> 
> M7400 uses a ring-buffer in shared memory for transporting data from the modem.
> Each ring-buffer element contains an array of caif frames. caif_xshm calls
> napi_schedule() when receiving notification about incoming data.
> The napi-poll function copies data from the ring-buffer to SKBs until
> ring-buffer is empty, or quota is exceeded.
> 
> If transmit ring-buffer is full, it also uses napi for scheduling transmission
> of queued transmit buffer.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: netdev@vger.kernel.org

I'm happy for this to go into the tree where the necessary xshm infrastructure
goes first:

Acked-by: David S. Miller <davem@davemloft.net>
