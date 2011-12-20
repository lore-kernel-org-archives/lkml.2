Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1LTJWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:22:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:28428 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1LTJVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:21:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98258164"
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem
 transfers.
From: Vinod Koul <vinod.koul@intel.com>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
In-Reply-To: <4EE99A15.8010608@st.com>
References: <4EE038BD.7010705@st.com>
	 <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com>
	 <4EE8469B.8050201@st.com> <4EE97E77.8060703@st.com>
	 <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>
	 <4EE98478.5070209@st.com>  <4EE99A15.8010608@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 14:51:35 +0530
Message-ID: <1324372895.1641.10087.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 12:26 +0530, Pratyush Anand wrote:
> >> That way existing mechanism would work well for you.
> >> You need to split the chunks properly, which is what dma would do
> anyway
> >>
> >
> > Yes, they can be split like this, but then splitting onus will go on
> dma
> > user driver, and so there would be replication of similar logic at
> > several places. Therefore, I was thinking to make device_prep_dma_sg
> as
> > generic by adding these flags.
Well I am not sure how adding flags handles this?
There are few things you should consider
1) do you have h/w support for these, if yes then we can talk about
dmaengine APIs doing such a thing
2) if objective is to support such transfers from dma driver POV, then I
wouldn't agree, as these can be split easily to standard dma sg list.
>From the code POV, it wouldn't hurt to create a wrapper which take in
these non standard sg list list and converts then to uniform list

Most important question:
in which practical scenario would src and dstn lengths be different?

> 
> I see one more issue in using device_prep_interleaved_dma.
> 
> Src and Dst address has been allocated in user space.
> Now a kernel module extracts physical addresses from these pages and
> prepares a sg list, which it submits to DMA.
> These addresses would be virtually contiguous and incrementing. But,
> I 
> am not sure if they are always physically incrementing too. If they
> are 
> not guaranteed to be incrementing, then I see issue.
> 
> Otherwise also, a situation can arise when scattered memory is not 
> always incrementing or decrementing in the same sg list.
What _exactly_ are you trying to do?

DMA would need buffers which are physically contagious. Also the user
pages can be swapped out, you would need to pin these pages.

-- 
~Vinod

