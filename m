Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1HDFJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:09:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:59022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1HDFJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="35633592"
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case
 of error interrupt
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk,
        bhupesh.sharma@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
	 <1311941799.1536.532.camel@vkoul-udesk3>
	 <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 09:55:18 +0530
Message-ID: <1312431918.1536.559.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 08:30 -0700, viresh kumar wrote:
> On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> > On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> >> +		dev_err(&pl08x->adev->dev, "%s error interrupt, register value"
> >> +				"0x%08x\n", __func__, err);
> > again this looks convoluted, and the stuff is quotes can be in single
> > line :)
> 
> Will take care of this in all patches.
> 
> > but in tasklet you will call the client callback, so how does the client
> > know if this was success or error? Did I miss anything?
> 
> No you didn't. I couldn't find a way in framework to report back to
> client success or failure.
> Is there any way? For now i have only kept error prints.
Sorry for not responding earlier.

Yes that's the whole point, today callback mechanism doesn't tell the
_status_ of the transfer (which if we need change can be discussed as
well), but to counter argue I have never been able to generate the error
interrupt, are you able to do on your controller?

One more point wrt this patch, what do we gain here from calling
tasklet, are you cleaning up your queue for the error descriptor or
something, I think not. so just calling to print doesn't make sense to
me, comments?


-- 
~Vinod

