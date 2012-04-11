Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213Ab2DKXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:06:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52734 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2DKXGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:06:20 -0400
Date: Thu, 12 Apr 2012 00:05:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@st.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH 2/2 v2] dma/amba-pl08x: add support for the Nomadik
	variant
Message-ID: <20120411230558.GF24211@n2100.arm.linux.org.uk>
References: <1334185214-27250-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334185214-27250-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 01:00:14AM +0200, Linus Walleij wrote:
> The Nomadik PL080 variant has some extra protection bits that
> may be set, so we need to check these bits to see if the
> channels are actually available for the DMAengine to use.

Actually, there is another issue to be considered with PL080.  For memcpy
transfers, a restricted set of channels should be used, because the PL080
only guarantees certain channels won't consume all bus bandwidth, locking
out (eg) the CPU from doing other stuff while the memcpy DMA is running.

So really the way physical channels are selected needs to become more
inteligent overall.
