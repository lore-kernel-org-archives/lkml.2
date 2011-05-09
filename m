Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1EIGDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:03:48 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:47937 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab1EIGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:03:47 -0400
Message-ID: <4DC783A9.5060802@st.com>
Date: Mon, 9 May 2011 11:33:21 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V4 3/5] dmaengine/dw_dmac: Divide one sg to many desc,
 if sg len is greater than DWC_MAX_COUNT
References: <cover.1304596524.git.viresh.kumar@st.com>	 <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com> <1304918425.32447.20.camel@vkoul-udesk3>
In-Reply-To: <1304918425.32447.20.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 10:50 AM, Koul, Vinod wrote:
>> > @@ -695,9 +695,15 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>> >  		reg = dws->tx_reg;
>> >  		for_each_sg(sgl, sg, sg_len, i) {
>> >  			struct dw_desc	*desc;
>> > -			u32		len;
>> > -			u32		mem;
>> > +			u32		len, dlen, mem;
>> >  
>> > +			mem = sg_phys(sg);
>> > +			len = sg_dma_len(sg);
>> > +			mem_width = 2;
> hardcoding mem_width doesn't make sense, you should take this from input
> params

Firstly, this change is not introduced in this patch, i have just rearranged this.
So, will send separate patch if this change is required.

Secondly, peripheral width is taken from chan->private. And by 2 for mem_width,
we meant word-by-word here. Shouldn't we always try word-by-word here?
How should we pass width for memory?

-- 
viresh
