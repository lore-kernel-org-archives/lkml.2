Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1IHXdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:33:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:55576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1IHXco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:32:44 -0400
Subject: Re: [PATCH 16/18] dmaengine/ambhe rest oa-pl08x: Add support for
 sg len greater than one for slave transfers
From: Vinod Koul <vkoul@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: vinod.koul@intel.com, Viresh Kumar <viresh.kumar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CACRpkdaqTYK5TJL2u+aeOfnzhdtdjxZhyu661eGKrNBOXTUTeA@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	 <20110814083618.GE4986@n2100.arm.linux.org.uk> <4E4CCF7B.8060704@st.com>
	 <20110821083306.GA12028@n2100.arm.linux.org.uk> <4E532B19.6000103@st.com>
	 <4E5715CE.2070806@st.com>
	 <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com>
	 <4E575E75.40603@st.com> <4E5F594D.10203@st.com>
	 <438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com>
	 <CAKnu2Mp3Ui7jZS2kjJykjuzcTzJhiAkoaVxZ2+tQX0banGh6mw@mail.gmail.com>
	 <4E683B74.5000701@st.com>
	 <CACRpkdaqTYK5TJL2u+aeOfnzhdtdjxZhyu661eGKrNBOXTUTeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Fri, 09 Sep 2011 03:24:33 +0530
Message-ID: <1315518873.6638.7.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 12:29 +0200, Linus Walleij wrote:
> On Thu, Sep 8, 2011 at 5:50 AM, Viresh Kumar <viresh.kumar@st.com> wrote:
> 
> > If i am getting this clearly, the concern is "why to queue separate transfers for
> > individual sg's? Better would be to prepare the complete list at once and
> > start the transfer, so that DMA stops only after finishing all sg's
> > passed from user." Is this what you are pointing at?
> 
> Yes.
> 
> > If yes, then the same is done in this patch too. An array for llis is allocated at
> > the start, then for each sg i prepare lli list from this array. Last lli from one sg
> > is followed by first lli from next sg. And so i get a continuous chain of llis.
> 
> OK so I guess I was lost in the code ...
> 
> So this is mainy cached as txd->dsg_list so you can quickly retrieve the
> number of bytes pending in the LLI by traversing that sglist.
> 
> This is better than what the coh901318 does, because that driver
> resorts to going into the physical LLIs themselves to retrieve this
> info.
> 
> It also seems like this will play nice with Per Forlin's MMC
> speed-up patches, so that will become effective for your MMC
> usecases.
> 
> Now I really like this patch.
> 
> Sorry for being such a slow learner!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Okay, great. I will check the rest of the series (i think 3 patches) and
apply then next week.

-- 
~Vinod Koul
Intel Corp.

