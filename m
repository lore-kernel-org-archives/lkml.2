Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab2H1AvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:51:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46409 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2H1AvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:51:19 -0400
Date: Tue, 28 Aug 2012 01:51:00 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Garzik <jgarzik@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] clk.h: Fix shim ifdef guard (HAVE_CLK -> COMMON_CLK)
Message-ID: <20120828005100.GG25321@flint.arm.linux.org.uk>
References: <503B920F.30509@suse.com> <20120827185248.GE25321@flint.arm.linux.org.uk> <503BDE58.60101@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BDE58.60101@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:53:44PM -0400, Jeff Mahoney wrote:
> Should the clk_devm stuff be moved someplace generic? I don't have a
> horse in this race. My only interest here is to get these configs to
> build again. :)

devm_clk_get() should not be in clkdev.c, but should be entirely separate,
allowing anyone who is using the clk API to use it.  But unfortunately,
that's not how it ended up getting added...  Moving it is something that's
on my very long todo list.

It should still remain in drivers/clk, but it should be in a separate file,
probably built conditionally by HAVE_CLK being defined.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
