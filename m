Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2JLJPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:15:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50946 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2JLJPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:15:52 -0400
Date: Fri, 12 Oct 2012 10:15:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2 5/8] clk: don't mark clkdev_add_table as init
Message-ID: <20121012091535.GD21164@n2100.arm.linux.org.uk>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de> <1349813638-4617-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349813638-4617-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:13:55PM +0200, Arnd Bergmann wrote:
> s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
> which means we might be calling it after the __init section is
> discarded.
> 
> Without this patch, building mini2440_defconfig results in:
> 
> WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
> The function s3c2440_clk_add() references
> the function __init clkdev_add_table().
> This is often because s3c2440_clk_add lacks a __init
> annotation or the annotation of clkdev_add_table is wrong.

I'm not sure this is the right thing to do.  I suspect this comes from the
stupidly complex samsung code, and that this is actually safe - I suspect
that s3c2440_clk_add() needs to be appropriately marked, but then you end
up having to trace its call path through various structures etc.
