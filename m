Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2FNLOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:14:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56100 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2FNLN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:13:58 -0400
Date: Thu, 14 Jun 2012 12:13:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/17] i2c: omap: simplify omap_i2c_ack_stat()
Message-ID: <20120614111333.GA31187@n2100.arm.linux.org.uk>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-5-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339669250-9183-5-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:20:37PM +0300, Felipe Balbi wrote:
> stat & BIT(1) is the same as BIT(1), so let's
> simplify things a bit by removing "stat &" from
> all omap_i2c_ack_stat() calls.

This doesn't feel right, and the explanation is definitely wrong.

"stat & BIT(1)" is not the same as "BIT(1)" _unless_ you're saying that
stat always has BIT(1) already set.  Can you guarantee that in this code?
If so, how?

What happens if you read the status register, and it has bit 1 clear.
immediately after the read, the status register bit 1 becomes set, and
then you write bit 1 set (because you've dropped the stat & BIT(1) from
the code.)

Is it not going to acknowledge that bit-1-set but because you haven't
read it, you're going to miss that event?

This feels like a buggy change to me.
