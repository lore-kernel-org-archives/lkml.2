Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1G2K62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:58:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47037 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1G2K6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:58:20 -0400
Date: Fri, 29 Jul 2011 11:57:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
Message-ID: <20110729105759.GE25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:19:10PM +0530, Viresh Kumar wrote:
> Hi Linus,
> 
> This patchset contains patches for ARM's pl08x DMA controller driver.
> Main changes introduced by this patchset are:
> - Formatting fixes
> - Logical Fixes
> - Support for Peripheral as flow controller

Peripheral flow is broken beyond belief.  It doesn't work for at all
for scatterlists.  The way peripheral flow control works on PL08x is
as follows:

1. You build a scatterlist which is a list of [address, length] pairs
2. You pass that to the DMA controller.  The DMA controller ignores the
   length field.
3. The DMA controller reads/writes to [address] and increments it.
4. The DMA controller moves to the next SG entry when the peripheral
   signals an end-of-transfer.

Please explain how you're getting around the issue where the scatterlist
length is not respected by the DMA controller.
