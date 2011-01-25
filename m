Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AYKoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:44:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1AYKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:44:33 -0500
Date: Tue, 25 Jan 2011 10:43:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: walter harms <wharms@bfs.de>
Cc: Julia Lawall <julia@diku.dk>, Vasiliy Kulikov <segooon@gmail.com>,
        Ryan Mallon <ryan@bluewatersys.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Message-ID: <20110125104333.GE11507@n2100.arm.linux.org.uk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk> <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com> <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros> <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk> <4D3EA6EC.5050305@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3EA6EC.5050305@bfs.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:33:16AM +0100, walter harms wrote:
> Would it be more easy to return NULL in the error case of clk_get() instead
> of ERR_PTR(-ENOENT) ?
> 
> So the default could be return NULL and an architecture depending solution
> replacing that.

That's not how the API is defined.  The API defines error-pointers to be
errors, everything should be considered valid.  Please don't go down the
route of doing something architecturally different from that.

What if, say, you couldn't return the struct clk because maybe it could
only be controlled by one user?  Returning an EBUSY error pointer would
indicate this condition.  What if the module providing the struct clk
hasn't finished initializing - that's another reason for EBUSY rather
than ENOENT.

Error codes are useful to describe why something failed.  NULL pointers
can't do that.
