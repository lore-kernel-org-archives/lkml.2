Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1G3MIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:08:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35488 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1G3MIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:08:01 -0400
Date: Sat, 30 Jul 2011 13:07:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk
	with channel requests
Message-ID: <20110730120740.GA15791@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:19:17PM +0530, Viresh Kumar wrote:
> Amba devices have interface clocks attached as adev->pclk. This is the only
> clock associated with DMAC and it can be disabled when DMAC is not in use. This
> patch adds support to enable/disable this clk as and when channels are requested
> and freed. Also it disables this clock at the end of probe.

It may make better sense to convert this to runtime PM.  I suspect
that there's core support which the amba/bus.c can do to help in that
respect (eg, managing the apb pclk itself) so that we don't have to
add the same code to every primecell driver.
