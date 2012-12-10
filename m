Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2LJOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:16:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57709 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2LJOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:16:29 -0500
Date: Mon, 10 Dec 2012 14:16:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        Boojin Kim <boojin.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
Message-ID: <20121210141604.GN14363@n2100.arm.linux.org.uk>
References: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com> <50C5ED3E.2050308@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5ED3E.2050308@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 07:40:06PM +0530, Santosh Shilimkar wrote:
> Whats the stand on such erratas ? I saw on one of thread one of
> you suggesting to stop patching kernel where secure/non-secure
> kernel will need different errata WA.

Well, yes, there's that too.  I think were we got to was deciding that
it is impossible to tell whether an errata is required for any particular
SoC: even when you know the rXpX number of the core, you don't know if,
as part of the design, the manufacturer incorporated some fix.

So, the conclusion we came to was that the _only_ place that work-arounds
like these can be enabled is before we get anywhere near the kernel - in
whatever pre-kernel code the platform has, and doing whatever platform
specific magic is required to get those work-arounds enabled.

What that means is that having the work-arounds in the kernel is pretty
pointless when it's a matter of enabling a bit or two in some secure-only
register.

I don't think I heard any objections to removing those work-arounds which
fall into this category from the kernel; I think that's something we need
to schedule for a few kernel versions time, after we've put them into the
feature-removal file, and marked them in the config as going away.
