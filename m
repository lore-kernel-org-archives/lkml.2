Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1KWKxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:53:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:13852 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab1KWKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:53:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,558,1315206000"; 
   d="scan'208";a="40453385"
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
In-Reply-To: <4ECB3F1F.9060806@st.com>
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>
	 <1321935206.1516.217.camel@vkoul-udesk3>  <4ECB3F1F.9060806@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 16:19:35 +0530
Message-ID: <1322045375.1516.249.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 11:50 +0530, Viresh Kumar wrote:
> On 11/22/2011 9:43 AM, Vinod Koul wrote:
> > On Thu, 2011-11-17 at 16:01 +0530, Viresh Kumar wrote:
> >> > In S2R all DMA registers are reset by hardware and thus they are required to be
> > When are they reset, whenever you leave channel idle or once you come
> > back from suspend?
> 
> Whenever we do S2R, many power islands are switched off and so DMAC controller looses
> all its power. On resume, all registers are in their reset state.
then why not perform save and restore in your suspend and restore
callbacks. That way you don't pay penalty of doing that in every alloc
as you seem to be doing now?

-- 
~Vinod

