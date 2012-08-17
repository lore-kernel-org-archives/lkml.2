Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2HQJ7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:59:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40142 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2HQJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:58:54 -0400
Date: Fri, 17 Aug 2012 10:58:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: clk_find() misses some clocks
Message-ID: <20120817095837.GM18957@n2100.arm.linux.org.uk>
References: <1345196843-23059-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345196843-23059-1-git-send-email-richard.genoud@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please read the comments on the function:

 * Find the correct struct clk for the device and connection ID.
 * We do slightly fuzzy matching here:
 *  An entry with a NULL ID is assumed to be a wildcard.
 *  If an entry has a device ID, it must match
 *  If an entry has a connection ID, it must match
 * Then we take the most specific entry - with the following
 * order of precedence: dev+con > dev only > con only.

On Fri, Aug 17, 2012 at 11:47:23AM +0200, Richard Genoud wrote:
> if a clock is declared like that:
> CLKDEV_CON_DEV_ID("pioA", "fffff400.gpio", &pioAB_clk)

So you've declared it with a connection ID.  Therefore, as the comment
above says, "it must match" what the driver is asking for.

It's not a bug, this is done intentionally so that mismatches do not
occur.
