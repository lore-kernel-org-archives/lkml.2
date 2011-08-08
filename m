Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1HHOIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:08:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:35003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HHOIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:08:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,337,1309762800"; 
   d="scan'208";a="39146616"
Subject: Re: [PATCH] dmaengine/dmatest: Terminate transfers on all channels
 in case of error or exit
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com
In-Reply-To: <4560606c5b6665b47d22c571cd60e526e551c639.1311935349.git.viresh.kumar@st.com>
References: <4560606c5b6665b47d22c571cd60e526e551c639.1311935349.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 19:37:50 +0530
Message-ID: <1312812470.1539.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:21 +0530, Viresh Kumar wrote:
> In case, some error occurs while doing memcpy transfers, we must terminate all
> transfers physically too. This is achieved by calling device_control() routine
> with TERMINATE_ALL as parameter.
> 
> This is also required to be done in case module is removed while we are in
> middle of some transfers.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Applied, thanks

> ---
>  drivers/dma/dmatest.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index b4f5c32..cd8ae03 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -476,6 +476,8 @@ err_srcs:
>  	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
>  			thread_name, total_tests, failed_tests, ret);
>  
> +	/* terminate all transfers on specified channels */
> +	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
>  	if (iterations > 0)
>  		while (!kthread_should_stop()) {
>  			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
> @@ -498,6 +500,10 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
>  		list_del(&thread->node);
>  		kfree(thread);
>  	}
> +
> +	/* terminate all transfers on specified channels */
> +	dtc->chan->device->device_control(dtc->chan, DMA_TERMINATE_ALL, 0);
> +
>  	kfree(dtc);
>  }
>  


-- 
~Vinod

