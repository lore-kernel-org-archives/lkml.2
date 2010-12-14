Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0LNRam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:30:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54206 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475Ab0LNRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:30:41 -0500
Date: Tue, 14 Dec 2010 17:30:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v4 4/5] msm: hotplug: support cpu hotplug on msm
Message-ID: <20101214173007.GA24303@n2100.arm.linux.org.uk>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org> <1292302233-16194-5-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292302233-16194-5-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 08:50:32PM -0800, Jeff Ohlstein wrote:
> +static inline void platform_do_lowpower(unsigned int cpu)
> +{
> +	/* Just enter wfe for now. */
> +	for (;;) {
> +		asm("wfe" : : : "memory");
> +		if (pen_release == cpu) {
> +			/*
> +			 * OK, proper wakeup, we're done
> +			 */
> +			break;
> +		}
> +		smp_rmb();

I can't work out what this read memory barrier is doing here.  Could you
suggest what purpose it's serving please?
