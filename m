Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1BEUgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:36:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46190 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1BEUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:36:18 -0500
Date: Sat, 5 Feb 2011 20:36:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Per Forlin <per.forlin@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dev@lists.linaro.org
Subject: Re: [PATCH 0/5] mmc: add double buffering for mmc block requests
Message-ID: <20110205203600.GA31760@n2100.arm.linux.org.uk>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org> <20110205170255.GG29411@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205170255.GG29411@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 05:02:55PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 12, 2011 at 07:13:58PM +0100, Per Forlin wrote:
> > Add support to prepare one MMC request while another is active on
> > the host. This is done by making the issue_rw_rq() asynchronous.
> > The increase in throughput is proportional to the time it takes to
> > prepare a request and how fast the memory is. The faster the MMC/SD is
> > the more significant the prepare request time becomes. Measurements on U5500
> > and U8500 on eMMC shows significant performance gain for DMA on MMC for large
> > reads. In the PIO case there is some gain in performance for large reads too.
> > There seems to be no or small performance gain for write, don't have a good
> > explanation for this yet.
> 
> It might be worth seeing what effect the following patch has.  This
> moves the dsb out of the cache operations into a separate function,
> so we only do one dsb per DMA mapping/unmapping operation.  That's
> particularly significant for the scattergather code.
> 
> I don't remember the reason why this was dropped as a candidate for
> merging - could that be because the dsb needs to be before the outer
> cache maintainence?  Adding Catalin for comment on that.

FWIW, trying this with MMC on OMAP4, I see no measurable difference in
performance nor CPU usage.
