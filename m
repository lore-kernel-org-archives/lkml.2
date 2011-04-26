Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1DZUbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:31:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50603 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1DZUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:31:00 -0400
Date: Tue, 26 Apr 2011 21:30:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, amit.goel@st.com,
        viresh.linux@gmail.com, jamie@jamieiles.com
Subject: Re: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with
	irqsave variants
Message-ID: <20110426203044.GA17290@n2100.arm.linux.org.uk>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 04:19:59PM +0530, Viresh Kumar wrote:
>  static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
>  {
> +	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
>  	struct dw_desc *desc, *_desc;
>  	struct dw_desc *ret = NULL;
>  	unsigned int i = 0;
>  
> -	spin_lock_bh(&dwc->lock);
> +	spin_lock_irqsave(&dwc->lock, dw->flags);

It's a very bad idea to store the IRQ flags like this - it means that
another thread operating on this corrupts this threads interrupt flag
settings.

It should be a local variable.
