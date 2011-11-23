Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1KWLfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:35:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:9540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1KWLfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:35:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,557,1315206000"; 
   d="scan'208";a="78342195"
Subject: Re: [PATCH] dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg
 register on resume
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
In-Reply-To: <4ECCD4F4.8080903@st.com>
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>
	 <1321935206.1516.217.camel@vkoul-udesk3>  <4ECB3F1F.9060806@st.com>
	 <1322045375.1516.249.camel@vkoul-udesk3>  <4ECCD4F4.8080903@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 17:02:13 +0530
Message-ID: <1322047933.1516.266.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 16:41 +0530, Viresh Kumar wrote:
> On 11/23/2011 4:19 PM, Vinod Koul wrote:
> > then why not perform save and restore in your suspend and restore
> > callbacks. That way you don't pay penalty of doing that in every alloc
> > as you seem to be doing now?
> 
> Not actually. I am not saving anything to be restored after suspend.
> There are few things (configuring CFG regs and enabling interrupts),
> which are done earlier on alloc_channels. As this will not be called after
> resume, so we need to set them again.
> 
> What i have done is, removed all this stuff from alloc channels and moved it
> to dwc_dostart(). Here, i am checking if channel is already programmed or not.
> If not (Can happen only in two cases: On resume and other on fresh channel alloc),
> i configure them. So there is no save/restore actually done.
> 

okay, why were you writing to registers in alloc in the first place :)
it should have been in the dostart.

Okay now i get it, looks fine to me, I will apply it


-- 
~Vinod

