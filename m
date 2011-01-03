Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1ACLPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:15:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46858 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1ACLPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:15:18 -0500
Date: Mon, 3 Jan 2011 11:14:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20110103111446.GK26785@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com> <20101223001012.GF29368@n2100.arm.linux.org.uk> <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com> <AANLkTikP+JZkN7AjqaNfHY8jZ7bVsV-af=YR=MTdfnNU@mail.gmail.com> <20101231215018.GB5012@n2100.arm.linux.org.uk> <AANLkTiktQbR5cm6qKzrhCBEMqmxOq4WhryoZnQ-kge0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiktQbR5cm6qKzrhCBEMqmxOq4WhryoZnQ-kge0g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 09:33:34PM +0100, Linus Walleij wrote:
> As for the in-tree PL08x driver I'd say it's doing pretty well for
> memcpy() so we could add platform data for that on supported
> platforms, then for device transfers we need more elaborative
> work.

It has the issue that it's not unmapping the buffers after the memcpy()
operation has completed, so on ARMv6+ we have the possibility for
speculative prefetches to corrupt the destination buffer.

Neither are a number of the other DMA engine drivers.  This is why I'd
like to see some common infrastructure in the DMA engine core for saying
"this tx descriptor is now complete" so that DMA engine driver authors
don't have to even think about whether they should be unmapping buffers.

I'd also like to see DMA_COMPL_SKIP_*_UNMAP always set by prep_slave_sg()
in tx->flags so we don't have to end up with "is this a slave operation"
tests in the completion handler.
