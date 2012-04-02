Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2DBRE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:04:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52224 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2DBRE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:04:57 -0400
Date: Mon, 2 Apr 2012 18:04:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120402170442.GF24211@n2100.arm.linux.org.uk>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 12:32:40PM +0100, Mark Brown wrote:
> Allow clk API users to simplify their cleanup paths by providing a
> managed version of clk_get().
> 
> Due to the lack of a standard struct clk to look up the device from a
> managed clk_put() is not provided, it would be very unusual to use this
> function so it's not a big loss.

Err, why?  The contents of struct clk has nothing to do with clk_put().
You're doing something really wrong here.

Remember, there is not going to _ever_ be the situation where a struct clk
is specific to any particular struct device - it's a 1:N mapping between
clks and devices.

So, until you sort out your misunderstanding, NAK.
