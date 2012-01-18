Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2ARJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:37:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2ARJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:37:04 -0500
Date: Wed, 18 Jan 2012 09:36:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, linus.walleij@linaro.org, mirko.gardi@st.com,
        perex@perex.cz, vipin.kumar@st.com, vipulkumar.samar@st.com,
        egtvedt@samfundet.no, pratyush.anand@st.com, deepak.sikri@st.com,
        cjb@laptop.org, hskinnemoen@gmail.com, bhavna.yadav@st.com,
        armando.visconti@st.com, shiraz.hashim@st.com, amit.virdi@st.com,
        vincenzo.frascino@st.com, ulf.hansson@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.linux@gmail.com,
        kernel@pengutronix.de
Subject: Re: [PATCH V2 08/12] dmaengine/dw_dmac: Unmap all memory buffers
	after completion of slave transfers
Message-ID: <20120118093620.GC1068@n2100.arm.linux.org.uk>
References: <cover.1326876464.git.viresh.kumar@st.com> <ba53f229f3f594bfe0459b01a9ebb4d9b2c15882.1326876464.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba53f229f3f594bfe0459b01a9ebb4d9b2c15882.1326876464.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 02:41:55PM +0530, Viresh Kumar wrote:
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

NAK.  For reasons stated previously and subsequently ignored.
