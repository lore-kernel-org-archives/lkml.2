Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2ALI65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:58:57 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:59621 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab2ALI64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:58:56 -0500
Message-ID: <4F0EA0B9.2090700@st.com>
Date: Thu, 12 Jan 2012 14:28:33 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rajeev KUMAR <rajeev-dlh.kumar@st.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V2] dmaengine/dw_dmac: Hibernation support in dw_dmac
References: <1326358055-6576-1-git-send-email-rajeev-dlh.kumar@st.com>
In-Reply-To: <1326358055-6576-1-git-send-email-rajeev-dlh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/2012 2:17 PM, Rajeev KUMAR wrote:
> The suspend and resume implementation is through dev_pm_ops in dmac. So
> in order to support hibernation, freeze, thaw, restore and poweroff
> features are required.
> 
> Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 9b592b0..3a3d7ed 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1562,6 +1562,10 @@ static int dw_resume_noirq(struct device *dev)
>  static const struct dev_pm_ops dw_dev_pm_ops = {
>  	.suspend_noirq = dw_suspend_noirq,
>  	.resume_noirq = dw_resume_noirq,
> +	.freeze_noirq = dw_suspend_noirq,
> +	.thaw_noirq = dw_resume_noirq,
> +	.restore_noirq = dw_resume_noirq,
> +	.poweroff_noirq = dw_suspend_noirq,

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
