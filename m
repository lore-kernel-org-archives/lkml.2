Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1G3Xxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:53:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1G3Xxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110730130537.GB15791@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
	<20110730120740.GA15791@n2100.arm.linux.org.uk>
	<20110730130537.GB15791@n2100.arm.linux.org.uk>
Date: Sun, 31 Jul 2011 01:53:41 +0200
X-Google-Sender-Auth: -qlbeYFHxBTR_f1zuROkh_vSRlM
Message-ID: <CAKnu2MqTYF43wW3axM--jXdtvsCyRBTLEHDc3hPoJYAmTAL5UA@mail.gmail.com>
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk with
 channel requests
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/30 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sat, Jul 30, 2011 at 01:07:40PM +0100, Russell King - ARM Linux wrote:
>> It may make better sense to convert this to runtime PM.  I suspect
>> that there's core support which the amba/bus.c can do to help in that
>> respect (eg, managing the apb pclk itself) so that we don't have to
>> add the same code to every primecell driver.
>
> Something like this for the bus driver (untested):
>
>  drivers/amba/bus.c |   38 ++++++++++++++++++++++++++++++++++++--
>  1 files changed, 36 insertions(+), 2 deletions(-)

I think the pm_runtime_* code Rabin put in place inside
drivers/spi/spi-pl022.c would play really well with this approach, and
just work, so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
