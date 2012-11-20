Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2KTJhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:37:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46220 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2KTJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:36:59 -0500
Date: Tue, 20 Nov 2012 09:34:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC/PATCH 0/3] CLK: add more devm_* APIs
Message-ID: <20121120093445.GL3290@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 01:22:16AM -0800, Dmitry Torokhov wrote:
> Hi,
> 
> When looking at recent driver conversions to managed resources (devm_*) there
> is no devm_clk_prepare() and similar functions, which forces mixing of 2
> resource management styles (managed/classic) in the same driver, which is not
> great.
> 
> This patch series adds more devm_* managed APIs to the CLK subsystem so that
> driver conversions can be "pure".

So, how do you ensure the correct ordering between clk_unprepare() and
clk_put(), or even clk_disable() and clk_unprepare() ?  I see nothing
here which makes any guarantees as to the ordering of those operations
upon cleanup.
