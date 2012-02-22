Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2BVJsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:48:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43391 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVJst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:48:49 -0500
Date: Wed, 22 Feb 2012 09:48:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rmallon@gmail.com
Subject: Re: [PATCH v2 19/19] ARM: at91/board-dt: move at91_initialize() to
	init_irq()
Message-ID: <20120222094827.GT22562@n2100.arm.linux.org.uk>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com> <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:39:45AM +0100, Nicolas Ferre wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Remove the need for at91_initialize() to be called at init_early().
> We move it to init_irq() function as we still need it before the
> timer initialization.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

NAK.  Keep the callback methods pure.  The whole point of the init_early
is so that soc people don't end up polluting things like the IRQ
initialization and timer initialization with stuff like this.

So this is a backwards step.
