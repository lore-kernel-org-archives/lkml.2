Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2ABLZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:25:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:6507 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2ABLZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:25:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102297831"
Subject: Re: [PATCH] dmaengine/dw_dmac: Add support for device_prep_dma_sg
From: Vinod Koul <vinod.koul@intel.com>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Mirko GARDI <mirko.gardi@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
In-Reply-To: <4F0192F2.3010506@st.com>
References: <1323766064-13425-1-git-send-email-pratyush.anand@st.com>
	 <1324655898.1633.11.camel@vkoul-udesk3>  <4F0192F2.3010506@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 16:55:35 +0530
Message-ID: <1325503535.1540.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-02 at 16:50 +0530, Pratyush Anand wrote:
> On 12/23/2011 9:28 PM, Vinod Koul wrote:
> > On Tue, 2011-12-13 at 14:17 +0530, Pratyush Anand wrote:
> >> Memory to memory copy with scatter gather option has been implemented in
> >> this patch. Driver can manage even if number of nodes in src and dst
> >> list is different.
> > The logic looks okay, but it would be great if we could split this
> > prepare here.
> > Possibly later when we have multiple such cases we can create templates
> > for parsing the non linear sg list and create linear lists from it.
> >
> 
> Ok. So you suggest to have one patch with a function to align sglist
> w.r.t length, and to implement this dwc_prep_dma_sg with aligned list only.
IMO that would be a much better approach
> 
> Caller of dwc_prep_dma_sg function will also call something like
> align_sg_list(unaligned_dsgl, unaligned ssgl, aligned dsgl,aligned ssgl);
and this one can be common code in dmaengine

> dwc_prep_dma_sg(chan, aligned dsgl, dnents, aligned ssgl, snents, flag);
> 
> Is that what you suggest? will do that.
> 
> It would be helpful if we can also conclude following discussion.
> https://lkml.org/lkml/2011/12/20/95
> I am waiting for your reply.
Missed that, will check it now


-- 
~Vinod

