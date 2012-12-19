Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2LSSUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:20:43 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41963 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2LSSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:20:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,318,1355126400"; 
   d="scan'208";a="15315996"
Message-ID: <50D2056E.9000507@codeaurora.org>
Date: Wed, 19 Dec 2012 10:20:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org> <1355778135-32458-5-git-send-email-sboyd@codeaurora.org> <20121219172619.GB1005@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121219172619.GB1005@beefymiracle.amer.corp.natinst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/12 09:26, Josh Cartwright wrote:
> On Mon, Dec 17, 2012 at 01:02:15PM -0800, Stephen Boyd wrote:
>> Reduce lines of code and simplify this driver by using the
>> generic clock binding parsing function. This also fixes a bug
>> where the 'flags' member of the init struct is not initialized.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Josh Cartwright <josh.cartwright@ni.com>
>> Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>>  drivers/clk/clk-zynq.c | 28 +++++++++-------------------
>>  1 file changed, 9 insertions(+), 19 deletions(-)
> Stephen-
>
> Is there a particular tree I should be testing this against?  Booting this set
> on top of linus/master gives me:

I based the patches off of linux-next-20121217 although it seems like it
applied fine for you on linus/master.

>    ------------[ cut here ]------------
>    WARNING: at drivers/clk/clk-zynq.c:159 zynq_periph_clk_setup+0x190/0x248()
>    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
>    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
>    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193520>] (zynq_periph_clk_setup+0x190/0x248)
>    [<c0193520>] (zynq_periph_clk_setup+0x190/0x248) from [<c0192944>] (of_clk_init+0x30/0x58)
>    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
>    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
>    [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
>    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
>    ---[ end trace 1b75b31a2719ed1c ]---
>    ------------[ cut here ]------------
>    WARNING: at drivers/clk/clk-zynq.c:296 zynq_cpu_clk_setup+0x1e0/0x26c()
>    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
>    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
>    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c)
>    [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
>    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
>    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
>    [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
>    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
>    ---[ end trace 1b75b31a2719ed1d ]---
>    ------------[ cut here ]------------
>    WARNING: at drivers/clk/clk-zynq.c:347 zynq_cpu_clk_setup+0x210/0x26c()
>    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
>    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
>    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c)
>    [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
>    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
>    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
>    [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
>    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
>    ---[ end trace 1b75b31a2719ed1e ]---

Can you show the code at those line numbers? There are quite a few
WARN_ONs in that code and it's possible the WARN_ON is the one
introduced in this patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

