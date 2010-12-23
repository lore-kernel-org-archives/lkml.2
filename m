Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0LWALh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:11:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49499 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0LWALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:11:36 -0500
Date: Thu, 23 Dec 2010 00:10:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101223001012.GF29368@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
> 3.6 Constraints:
> 1/ Calls to async_<operation> are not permitted in IRQ context.  Other
>    contexts are permitted provided constraint #2 is not violated.

BTW, this is misleading.  Have the functions been renamed dma_async_xxx(),
eg dma_async_memcpy_buf_to_buf etc, or are you referring just to:

	async_dmaengine_get
	async_dmaengine_put
	async_dma_find_channel
	async_dma_find_channel
	async_tx_ack
	async_tx_clear_ack
	async_tx_test_ack

Beware of just renaming it to dma_async_<operation> as there's other
functions in that namespace which may not be appropriate.

Eg, is it really illegal to issue call dma_async_issue_pending() from
IRQ context?  That'd make it exceedingly difficult to use the DMA
engine with the slave API in a lot of device drivers.
