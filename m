Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2ARJg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:36:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40783 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab2ARJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:36:26 -0500
Date: Wed, 18 Jan 2012 09:35:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Subject: Re: [PATCH 7/8] dmaengine/dw_dmac: Unmap all memory buffers after
	completion of slave transfers
Message-ID: <20120118093559.GB1068@n2100.arm.linux.org.uk>
References: <cover.1326707233.git.viresh.kumar@st.com> <5e5d0fcff79b9b78e64c7424317d6b77736eca43.1326707233.git.viresh.kumar@st.com> <20120116105448.GT1068@n2100.arm.linux.org.uk> <4F140DB7.3060300@st.com> <CACRpkdY-4wWeD=3mJiChi6+4=iBMcd3kVh3h4JmDZ5ySXY3KCA@mail.gmail.com> <4F153A3E.8010409@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F153A3E.8010409@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 02:37:10PM +0530, Viresh Kumar wrote:
> On 1/17/2012 2:22 PM, Linus Walleij wrote:
> > Basically the driver using the dmaengine shall map/unmap buffers
> > used for slave transfers, not the driver.
> > 
> > I usually map them before setting up a transfer and unmaps them
> > when egtting the callback from the DMA engine that the transfer is
> > complete.
> > 
> 
> You implemented similar stuff in amba-pl08x :) .
> 
> if (!plchan->slave)
> 	pl08x_unmap_buffers(txd);

Take a look at that.  "If *NOT* slave, unmap the buffers".  That is in
keeping with what I've been saying.  Slave transfers *do* *not* get
automatic buffer unmapping.
