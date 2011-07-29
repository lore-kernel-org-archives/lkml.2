Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1G2LTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:19:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56398 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab1G2LTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:19:37 -0400
Date: Fri, 29 Jul 2011 12:19:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
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
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
Message-ID: <20110729111920.GK25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <20110729105759.GE25640@n2100.arm.linux.org.uk> <4E329616.2030505@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E329616.2030505@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:44:30PM +0530, viresh kumar wrote:
> There can be two cases here:
> 
> - Memory addresses are contiguous and are not scattered.
> Here, Only one sg will be passed by user driver, with memory address and
> zero length. We pass this to controller and after the transfer it will
> receive the last burst request from peripheral and so transfer finishes.
> 
> - Memory addresses are scattered and are not contiguous.
> Here, Obviously as DMA controller doesn't know when a lli's transfer gets over,
> it can't load next lli. So in this case, there has to be an assumption that only
> one lli is supported. Thus, we can't have scattered addresses.

Ok, so lets have the driver explicitly enforce one SG entry if peripheral
flow is set.  It would also be a good idea to pass not zero length, but
the real transfer size in the SG entry for the sake of having the API
know the full information about the transfer.

(Ok, it already only supports one SG entry, but that's something else
which needs fixing - which may be possible now that you've cleaned up
the LLI creation code.)
