Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DSG0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:26:08 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:45809 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab1DSG0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:26:05 -0400
Message-ID: <4DAD2AE9.7060106@st.com>
Date: Tue, 19 Apr 2011 11:55:45 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with irqsave
 variants
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
In-Reply-To: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 04:19 PM, Viresh KUMAR wrote:
> dmaengine routines can be called from interrupt context and with interrupts
> disabled.  Whereas spin_unlock_bh can't be called from such contexts. So this
> patch converts all spin_*_bh routines to irqsave variants.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c      |   56 +++++++++++++++++++++++++------------------
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 33 insertions(+), 24 deletions(-)
> 
> 
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 720f821..c89fd83 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -173,6 +173,7 @@ struct dw_dma {
>  	void __iomem		*regs;
>  	struct tasklet_struct	tasklet;
>  	struct clk		*clk;
> +	unsigned long		flags; /* for spin_lock_irqsave */

Oops!!!
This must have been added in dw_dma_chan instead :(
Will resend it.

-- 
viresh
