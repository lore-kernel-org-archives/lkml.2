Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1G2LLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:11:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1G2LLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:11:07 -0400
Date: Fri, 29 Jul 2011 12:10:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/18] dmaengine/amba-pl08x: Pass flow controller
	information with slave channel data
Message-ID: <20110729111049.GI25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from my initial question in this thread...

On Fri, Jul 29, 2011 at 04:19:25PM +0530, Viresh Kumar wrote:
> +	if (plchan->cd->fc)
> +		tmp = plchan->cd->fc;
> +	else
> +		tmp = (direction == DMA_TO_DEVICE) ? PL080_FLOW_MEM2PER :
> +			PL080_FLOW_PER2MEM;
> +
> +	txd->ccfg |= tmp << PL080_CONFIG_FLOW_CONTROL_SHIFT;
> +

Please, no, don't go back to encoding the flow mask into the platform
data.  Instead use 'fc' as an indication of who should be the flow
controller, and hav ethis select the flow control based on both
'fc' and the direction.
