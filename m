Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2HENUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 09:20:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34698 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356Ab2HENUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 09:20:12 -0400
Date: Sun, 5 Aug 2012 14:20:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Don't enable GENERIC_LOCKBREAK with ticket spinlocks
Message-ID: <20120805132001.GA1591@mudshark.cambridge.arm.com>
References: <1344033762-3296-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344033762-3296-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:42:42PM +0100, Stephen Boyd wrote:
> Now that ARM has implemented its spinlocks with tickets we don't
> need to use the generic lockbreak algorithm. Remove the Kconfig
> from ARM so that we use the arch_spin_is_contended() definition
> from the asm header. This also saves a word in each lock because
> we don't need the break_lock member anymore.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> It seems we define the arch_spin_is_contended() macro but we don't
> use it on SMP && PREEMPT kernels?

Thanks, I missed that.

Acked-by: Will Deacon <will.deacon@arm.com>

Will
