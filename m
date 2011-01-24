Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1AXU20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:28:26 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43133 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1AXU2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:28:24 -0500
Date: Mon, 24 Jan 2011 21:28:17 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
In-Reply-To: <4D3DDD07.1030809@bluewatersys.com>
Message-ID: <Pine.LNX.4.64.1101242126570.3167@ask.diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
 <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com>
 <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros>
 <4D3DDD07.1030809@bluewatersys.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Julia is correct. Some architectures can return NULL from clk_get, but I
> didn't check the at91 before posting :-/. If we can't return NULL from
> clk_get then we shouldn't bother checking for it. I do think we should
> drop the !IS_ERR(clk_get(dev, func)) check though.

It seems a bit subtle, because the clk manipulated by clk_get in the call 
of clk_get(dev, func) is not necessarily the same as the one in 
clock_associate.  But perhaps this is the only possibility in practice?

julia
