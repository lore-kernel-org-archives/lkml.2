Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2APKzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:55:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58507 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2APKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:55:16 -0500
Date: Mon, 16 Jan 2012 10:54:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        armando.visconti@st.com, linus.walleij@linaro.org, mirko.gardi@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, bhavna.yadav@st.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@st.com
Subject: Re: [PATCH 7/8] dmaengine/dw_dmac: Unmap all memory buffers after
	completion of slave transfers
Message-ID: <20120116105448.GT1068@n2100.arm.linux.org.uk>
References: <cover.1326707233.git.viresh.kumar@st.com> <5e5d0fcff79b9b78e64c7424317d6b77736eca43.1326707233.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e5d0fcff79b9b78e64c7424317d6b77736eca43.1326707233.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 03:20:35PM +0530, Viresh Kumar wrote:
> Currently, after completion of transfer, source address or destination address
> of only the first LLI descriptor is unmapped. And length passed for unmap is
> total length of all descriptors in the list. Which means unmapping code assumed
> that the memory buffers pointed to by the descriptors will be physically
> contiguous, which might not be the case. It is possible for other drivers to
> pass sglist to slave_sg(), in which all buffers are scattered throughout the
> memory.
> 
> This patch intends to fix this wrong expectation of dw_dmac. Now, first desc
> will not contain total length of transfer. But individual descriptors will
> contain their individual lengths. Finally, we will call unmap for all
> descriptors.

Note that DMA engine drivers are not responsible for unmapping the buffers
when the transfer completes - that is the responsibility of the caller.

The automatic buffer unmapping is required for the async_tx APIs and
offload APIs.
