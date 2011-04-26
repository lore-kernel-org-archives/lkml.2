Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1DZUbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:31:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1DZUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:31:47 -0400
Date: Tue, 26 Apr 2011 21:31:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "armando.visconti@st.com" <armando.visconti@st.com>,
        "shiraz.hashim@st.com" <shiraz.hashim@st.com>,
        "amit.goel@st.com" <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>
Subject: Re: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from
	callback routine.
Message-ID: <20110426203136.GB17290@n2100.arm.linux.org.uk>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com> <cf350c267897bd4eaf5a027c659771eee117ac74.1303123511.git.viresh.kumar@st.com> <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:42:24AM +0530, Koul, Vinod wrote:
> On 04/18/2011 04:20 PM, viresh kumar wrote:
> > 
> > Resubmission of new transfer must be allowed from callbacks. For this release
> > lock before calling callback routine and enable them again.
> Why would you like to do that?
> 
> IMO it's not a good thing as you are essentially doing it in your tasklet...
> Make sure the submit() is done by client before this and you use it to start
> next transaction in you tasklet and let client know in callback txn is
> finished.

No.  Submission is explicitly permitted (by Dan) in slave DMA callbacks.
