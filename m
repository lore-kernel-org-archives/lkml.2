Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1AXKPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:15:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44641 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1AXKPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:15:35 -0500
Date: Mon, 24 Jan 2011 10:15:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        Gary King <gking@nvidia.com>, linux-kernel@vger.kernel.org,
        olof@lixom.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] ARM: tegra: Add suspend and hotplug support
Message-ID: <20110124101516.GD16202@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-14-git-send-email-ccross@android.com> <20110124090708.GA16202@n2100.arm.linux.org.uk> <AANLkTimEdkMsv+NERv6E6AyBcAKv9szJBsJYHmFBDnbS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimEdkMsv+NERv6E6AyBcAKv9szJBsJYHmFBDnbS@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 01:26:39AM -0800, Colin Cross wrote:
> Despite what the patch description says, this version of the patch
> does not save VFP state any more.  I will update the description.

I was going by the definitions of the context save area.

> It looks like if CONFIG_SMP=y, the VFP code saves the VFP context on
> every task switch, so nothing is needed during cpu idle.  However, if
> CONFIG_SMP=n, I think some way to save the VFP context is needed.

I think we need proper idle PM support as I think this will become
commonplace.

> This version of the patch does not save breakpoint/watchdogs, but
> something will need to save them during idle when the cpu is powered
> down.

Ditto.

> > Lastly, L2 cache controller should have suspend/resume support added.
> 
> Patch 4 in this series improves the L2 controller's PM support, and
> this patch uses l2x0_disable, l2x0_enable, and l2x0_init.

I was going by the definitions of the context save state - maybe the
ones which aren't used anymore should be removed?
