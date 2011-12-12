Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1LLOP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:15:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:3182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1LLOP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:15:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95209091"
Date: Mon, 12 Dec 2011 15:20:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Mirko GARDI <mirko.gardi@st.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 5/5] gpio/gpio-stmpe: ADD support for stmpe variant 801
Message-ID: <20111212142058.GE13952@sortiz-mobl>
References: <cover.1321507421.git.viresh.kumar@st.com>
 <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com>
 <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com>
 <4EC9D175.2070008@st.com>
 <20111121145116.GA32137@sirena.org.uk>
 <4ECB1BA6.4050803@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB1BA6.4050803@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Tue, Nov 22, 2011 at 09:18:54AM +0530, Viresh Kumar wrote:
> On 11/21/2011 8:21 PM, Mark Brown wrote:
> >> > I assumed stmpe_set_bits will only affect bits which are 1
> >> > in mask and i was wrong. :(
> > That does look like a straight bug in stmpe_set_bits() which ought to be
> > fixed regardless of anything else.
> > 
> 
> I think so. I will fix it in a separate patch.
> 
> >>> > >  (2) for other devices, adds an an unnecessary read (within stmpe_set_bits()),
> >>> > >      which wasn't there before.
> >> > Correct.
> >>> > > Please rework to something like:
> > Looking at the code in stmpe.c it might be as well to convert to regmap
> > which would if nothing else save a bunch of custom code in the driver
> > and let you use the cache code to eliminate the read.  Probably that
> > will help eliminate reads in other places too.
> 
> Ya, i already got this feedback from Rabin. I am a bit busy right now and so
> requested sameo to accept this patchset as it is. I will update drivers to use
> regmap as soon as i get some time.
Ok, so I reverted your first 2 patches patchset since it seems it was
problematic. Now, I think Rabin's concern on your patch #5 seems valid, and
I'd like you to fix it before applying this patchset.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
