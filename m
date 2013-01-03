Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3ACKU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:20:57 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:11151 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134Ab3ACKUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:20:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,402,1355094000"; 
   d="scan'208";a="188315332"
Date: Thu, 3 Jan 2013 11:20:52 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: davem@davemloft.net, richardcochran@gmail.com, tony@atomide.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: clk dereference in drivers/net/ethernet/ti/cpts.c
Message-ID: <alpine.DEB.2.02.1301031040320.1989@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been a discussion recently about how the result of get_clk
should be an opaque handle, not a value that can be dereferenced:

https://lkml.org/lkml/2012/12/20/105

There is such a dereference in drivers/net/ethernet/ti/cpts.c, in the
function cpts_clk_init:

cpts->freq = cpts->refclk->recalc(cpts->refclk);

It was not obvious to me, however, what API function should be used
instead, so I am just reporting the (potential) problem.

thanks,
julia
