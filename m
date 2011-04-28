Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1D1RMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:12:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1D1RMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:12:41 -0400
Date: Thu, 28 Apr 2011 18:12:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, armando.visconti@st.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        viresh.linux@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 4/7] dmaengine/dw_dmac: Enable resubmission from
	callback routine.
Message-ID: <20110428171227.GD17290@n2100.arm.linux.org.uk>
References: <cover.1303896566.git.viresh.kumar@st.com> <adbd175c9fc15e65b584d342b65cd1c3c0c58322.1303896567.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adbd175c9fc15e65b584d342b65cd1c3c0c58322.1303896567.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:06:46PM +0530, Viresh Kumar wrote:
>  static void
>  dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
> -		bool callback_required)
> +		bool callback_required, unsigned long flags)
>  {
...
>  	if (callback_required) {
> +		spin_unlock_irqrestore(&dwc->lock, flags);
>  		if (callback)
>  			callback(param);
> +		spin_lock_irqsave(&dwc->lock, flags);

Again, this isn't really on.  It seems to me that this code needs some
serious reworking.
