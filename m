Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2AQIhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:37:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65335 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2AQIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:37:15 -0500
MIME-Version: 1.0
In-Reply-To: <5f9ec59562e86536c4123f61891b95590293030f.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
	<5f9ec59562e86536c4123f61891b95590293030f.1326707233.git.viresh.kumar@st.com>
Date: Tue, 17 Jan 2012 09:37:14 +0100
Message-ID: <CACRpkdY4QQK6wtB5aPU+FwdyyGq-owsDxMmxdwJVnkzdJTRs_Q@mail.gmail.com>
Subject: Re: [PATCH 2/8] dmaengine: Add flow controller information to dma_slave_config
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:50 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> Flow controller is programmable for few controllers and there are few
> intelligent peripherals like, Synopsys JPEG controller, that needs to be a flow
> controller of DMA transfers on dest side.
>
> For this, currently two drivers, pl08x and dw_dmac, support flow controller to
> be passed from platform to these drivers.

OK

> Perhaps, this should be a part of struct dma_slave_config. This patch adds
> another field device_fc to this structure. User drivers must pass this as true
> if they want to be flow controller of certain transfers.

I dma_slave_config is supposed to be about info that

1) Must to be set-up at runtime
2) All DMA controllers need to know

So if it doesn't *have* to be set up by drivers at runtime, please keep it in
platform data.

If it is (1), so you have a use case where you have to switch a certain channel
between DMA master and device flow control at run-time it looks like it could
be useful for others as well, but I doubt this so I'd like some back-up on
that.

Yours,
Linus Walleij
