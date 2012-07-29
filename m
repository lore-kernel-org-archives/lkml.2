Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2G2Uji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:39:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46500 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2G2Ujh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:39:37 -0400
Date: Sun, 29 Jul 2012 21:39:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Fix argument to _notifier_call_chain
 call
Message-ID: <20120729203935.GG4384@opensource.wolfsonmicro.com>
References: <1343548396.9481.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343548396.9481.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 03:53:16PM +0800, Axel Lin wrote:
> Pass the address of best_val rather than the value of best_val for the third
> argument to _notifier_call_chain().
> 
> This fixes below build warning:
>   CC      drivers/regulator/core.o
> drivers/regulator/core.c: In function '_regulator_do_set_voltage':
> drivers/regulator/core.c:2183:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

No, this isn't a good idea - you're fixing a warning by changing the
semantics to be something obscure and not terribly helpful.  Just add a
cast if your compiler is getting upset.
