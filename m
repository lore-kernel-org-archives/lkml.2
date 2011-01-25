Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1AYSOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:14:18 -0500
Received: from service87.mimecast.com ([94.185.240.25]:53608 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751435Ab1AYSOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:14:17 -0500
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
 re-enabling l2x0
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        konkers@android.com, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110125154133.GB17280@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	 <1295834493-5019-5-git-send-email-ccross@android.com>
	 <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
	 <20110125154133.GB17280@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 25 Jan 2011 18:14:02 +0000
Message-ID: <1295979242.10109.308.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Jan 2011 18:14:07.0231 (UTC) FILETIME=[A7EB40F0:01CBBCBB]
X-MC-Unique: 111012518141202901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 15:41 +0000, Russell King - ARM Linux wrote:
> I think we need to come up with some proper way to deal with cpuidle
> which doesn't involve adding lots of globally visible functions to all
> sorts of bits of code and having platforms call them individually,
> otherwise this is going to get _really_ messy in the future.
> 
> Maybe we need a notifier list which can be told when cpuidle events
> happen, so that parts of the system such as VFP and L2 cache support
> can do the right thing without having platforms add lots of stuff like
> 
>         gic_secondary_init();
>         gic_restore_interrupt_types();
>         vfp_enable();
>         l2x0_enable();
>         twd_enable();
>         ... etc ...
> 
> in their SoC specific code.

But do we need a strict order between such operations? The notifier call
chain isn't too flexible.

-- 
Catalin


