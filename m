Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2AKG0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:26:25 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:42024 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159Ab2AKG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:26:23 -0500
Message-ID: <4F0D2B75.7000800@st.com>
Date: Wed, 11 Jan 2012 11:55:57 +0530
From: deepaksi <deepak.sikri@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Rajeev KUMAR <rajeev-dlh.kumar@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] dmaengine/dw_dmac: Hibernation support in dw_dmac
References: <1326262989-18608-1-git-send-email-rajeev-dlh.kumar@st.com>
In-Reply-To: <1326262989-18608-1-git-send-email-rajeev-dlh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/2012 11:53 AM, Rajeev KUMAR wrote:
> The suspend and resume implementation is through dev_pm_ops in dmac. So
> in order to support hibernation, freeze, thaw and restore features are required.
>
> Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d2e1c25..cb346d6 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1568,6 +1568,9 @@ static int dw_resume_noirq(struct device *dev)
>  static const struct dev_pm_ops dw_dev_pm_ops = {
>  	.suspend_noirq = dw_suspend_noirq,
>  	.resume_noirq = dw_resume_noirq,
> +	.freeze_noirq = dw_suspend_noirq,
> +	.thaw_noirq =	dw_resume_noirq,
> +	.restore_noirq = dw_resume_noirq,
>  };
>  
>   
Spacing and tab issue ..Please check at 

thaw_noirq


>  static struct platform_driver dw_driver = {
>   

