Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1BVU4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:56:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58915 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1BVU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:56:50 -0500
Date: Tue, 22 Feb 2011 20:56:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com, mike@compulab.co.il,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/7] ARM: tegra: timer: Enable timer and rtc clocks
Message-ID: <20110222205634.GF29559@n2100.arm.linux.org.uk>
References: <1298342392-21236-1-git-send-email-ccross@android.com> <1298342392-21236-6-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298342392-21236-6-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:39:50PM -0800, Colin Cross wrote:
> +	struct clk *clk;
>  	unsigned long rate = clk_measure_input_freq();
>  	int ret;
>  
> +	clk = clk_get_sys("timer", NULL);
> +	BUG_ON(IS_ERR(clk));
> +	clk_enable(clk);
> +	clk_put(clk);
> +
> +	clk = clk_get_sys("rtc-tegra", NULL);
> +	BUG_ON(IS_ERR(clk));
> +	clk_enable(clk);
> +	clk_put(clk);

It's probably better to leave them get'd if you're continuing to use
them and just forget the reference.
