Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2KTJ6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:58:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2KTJ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:58:01 -0500
Date: Tue, 20 Nov 2012 01:57:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121120095757.GB11732@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <20121120093242.GK3290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120093242.GK3290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:32:42AM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 20, 2012 at 01:22:17AM -0800, Dmitry Torokhov wrote:
> > We'll need to invoke clk_unprepare() via a pointer in our devm_*
> > conversion so let's uninline the pair.
> 
> NAK.  This breaks non-common clock using implementations.

As Viresh mentioned I provided stubs for case when we do not have
CONFIG_HAVE_CLK, so I am not sure how I'll break these platforms, but I
am certainly open for suggestions.
 
> 
> Why do you need to call this function via a pointer?  That sounds absurd.

devres framework takes and stores a pointer to a "destructor" which will
be used later.

Thanks.

-- 
Dmitry
