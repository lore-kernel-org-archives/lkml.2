Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1HRIjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:39:01 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54192 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab1HRIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:38:59 -0400
Message-ID: <4E4CCF7B.8060704@st.com>
Date: Thu, 18 Aug 2011 14:08:19 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len greater
 than one for slave transfers
References: <cover.1311936523.git.viresh.kumar@st.com> <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com> <20110814083618.GE4986@n2100.arm.linux.org.uk>
In-Reply-To: <20110814083618.GE4986@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Russell & Linus,

Sorry for being late to reply.

On 8/14/2011 2:06 PM, Russell King - ARM Linux wrote:
> On Fri, Jul 29, 2011 at 04:19:26PM +0530, Viresh Kumar wrote:
>> Untill now, sg_len greater than one is not supported. This patch adds support to
>> do that.
> 
> I'm not sure that this is the correct approach.  memcpy()s can only be
> used with one single buffer, so the sg stuff for that (and the unmapping
> support) doesn't make sense at all.
> 

I am not sure if i get this completely. In memcpy, we still don't support
more than one sg. We have created a new member in txd, which keeps track of
data (addresses, len).

While unmapping, we are unmapping only single dsg. I think i don't need to
use list_for_each_entry() there, as there is only one element present in list.
But can still keep that.

> The only place where this makes sense is the slave sg stuff.  I wonder
> whether we can better deal with that by having the LLI setup code deal
> with one SG list entry at a time, and chain each together.
> 
> Something I've also been pondering which is related to this is linking
> together DMA operations using the LLI chaining when interrupts and
> callbacks aren't required.  It's a very similar problem.  Other DMA
> engine drivers do this.
> 

Are you talking about linking all sg's together or linking multiple calls to
prep_dma_memcpy? I am handling the first.

> Finally, note that some of the PL08x code assumes that for any TXD,
> the LLI list is a contiguous array.  See the first part of
> pl08x_getbytes_chan(). That needs fixing as soon as we start going to
> more than one SG list entry.

We still have one contiguous array for LLI list. In pl08x_fill_llis_for_desc()
i am using same txd->llis_va for all sg's.

Sorry if i misunderstood your concerns.

-- 
viresh
