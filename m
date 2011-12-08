Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1LHHj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:39:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:29521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1LHHjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="84867447"
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem
 transfers.
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        deepak sikri <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <amit.virdi@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
In-Reply-To: <4EE038BD.7010705@st.com>
References: <4EE038BD.7010705@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 13:07:50 +0530
Message-ID: <1323329870.1641.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 09:40 +0530, Viresh Kumar wrote:
> Hi Dan/Vinod
> 
> I am looking to implement scatter/gather interface for mem to mem transfers.
> But before that, i wanted to know your feedback about it.
> 
> In my case, i have memory scattered in pages and performance is not good, if
> i submit transfers page by page.
> 
> If you are Okay with the idea, i can implement it and submit soon.
> 

You mean something like:
       struct dma_async_tx_descriptor *(*device_prep_dma_sg)(
                struct dma_chan *chan,
                struct scatterlist *dst_sg, unsigned int dst_nents,
                struct scatterlist *src_sg, unsigned int src_nents,
                unsigned long flags);

Its already there, you need to implement in your driver :)

-- 
~Vinod

