Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HAU46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:56:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab2HAU4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:56:54 -0400
Date: Wed, 1 Aug 2012 21:56:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: simplify use of shared IRQ
Message-ID: <20120801205650.GB29157@opensource.wolfsonmicro.com>
References: <1343853455-29131-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343853455-29131-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:37:35PM -0600, Stephen Warren wrote:

> One outstanding issue with this change is that it removes the pm_runtime
> calls from the interrupt handler thread. Equivalent code should presumably
> be added to regmap_irq_thread(). However, I haven't attempted this yet
> since I understand some pm_runtime support has already been added to
> regmap, so don't want to duplicate anything, although I haven't seen
> those changes yet to be sure.

This would cause massive breakage if applied as is due to the above
issue (the device won't have physical I/O when handling most interrupts)
and now that I think about it future work means that I'd actually prefer
to keep the code as-is for now anyway.
