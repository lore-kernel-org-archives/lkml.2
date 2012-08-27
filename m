Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2H0SxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:53:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2H0SxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:53:05 -0400
Date: Mon, 27 Aug 2012 19:52:48 +0100
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
Message-ID: <20120827185248.GE25321@flint.arm.linux.org.uk>
References: <503B920F.30509@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503B920F.30509@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 11:28:15AM -0400, Jeff Mahoney wrote:
> Commit 93abe8e4 (clk: add non HAVE_CLK routines) added shims for
> the clk code but HAVE_CLK isn't enough. It's possible to have the
> clk support but not enable it. We end up with full prototypes for code
> that is never built - causing module linking to fail later.
> 
> This patch changes the guard to use COMMON_CLK, which actually guards
> the code.

This is wrong.  COMMON_CLK is an _implementation_ of the CLK API.  It
is not the only implementation in the kernel.  Conditionalizing like
this breaks existing users.

HAVE_CLK is the right thing here - if you define HAVE_CLK then you _are_
providing an implementation of clk_get() et.al.  If you're not, then you
do not define HAVE_CLK.  Simples.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
