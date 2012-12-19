Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2LSSgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:36:07 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:37105 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2LSSf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:35:59 -0500
Date: Wed, 19 Dec 2012 12:36:17 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Message-ID: <20121219183617.GC1005@beefymiracle.amer.corp.natinst.com>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
 <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
 <20121219172619.GB1005@beefymiracle.amer.corp.natinst.com>
 <50D2056E.9000507@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50D2056E.9000507@codeaurora.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 12:35:55 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 12:35:55 PM,
	Serialize complete at 12/19/2012 12:35:55 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_08:2012-12-19,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:20:30AM -0800, Stephen Boyd wrote:
> On 12/19/12 09:26, Josh Cartwright wrote:
> > On Mon, Dec 17, 2012 at 01:02:15PM -0800, Stephen Boyd wrote:
[..]
> 
> Can you show the code at those line numbers? There are quite a few
> WARN_ONs in that code and it's possible the WARN_ON is the one
> introduced in this patch.

It looks like we're not hitting the WARN_ON() you added, but several of
the other ones.

> >    ------------[ cut here ]------------
> >    WARNING: at drivers/clk/clk-zynq.c:159 zynq_periph_clk_setup+0x190/0x248()
> >    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
> >    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
> >    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193520>] (zynq_periph_clk_setup+0x190/0x248)
> >    [<c0193520>] (zynq_periph_clk_setup+0x190/0x248) from [<c0192944>] (of_clk_init+0x30/0x58)
> >    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
> >    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
> >    [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
> >    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
> >    ---[ end trace 1b75b31a2719ed1c ]---

zynq_periph_clk_setup:
156 >-------periph->gates[0] = clk_register_gate(NULL, name, np->name, 0,
157 >------->------->------->------->-------     periph->clk_ctrl, 0, 0,
158 >------->------->------->------->-------     &periph->clkact_lock);
159 >-------if (WARN_ON(IS_ERR(periph->gates[0])))
160 >------->-------return;

> >    ------------[ cut here ]------------
> >    WARNING: at drivers/clk/clk-zynq.c:296 zynq_cpu_clk_setup+0x1e0/0x26c()
> >    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
> >    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
> >    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c)
> >    [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
> >    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
> >    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
> >    [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
> >    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
> >    ---[ end trace 1b75b31a2719ed1d ]---

zynq_cpu_subclk_setup:
295 >-------clk = clk_register(NULL, &subclk->hw);
296 >-------if (WARN_ON(IS_ERR(clk)))
297 >------->-------goto err_clk_register;

> >    ------------[ cut here ]------------
> >    WARNING: at drivers/clk/clk-zynq.c:347 zynq_cpu_clk_setup+0x210/0x26c()
> >    [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
> >    [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
> >    [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c)
> >    [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
> >    [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
> >    [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
> >    [<c0185d54>] (time_init+0x28/0x30) fr m [<c0183650>] (start_kernel+0x1a8/0x2c0)
> >    [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
> >    ---[ end trace 1b75b31a2719ed1e ]---

zynq_cpu_clk_setup:
345 >-------for (i = 0; i < 4; i++) {
346 >------->-------cpuclk->subclks[i] = zynq_cpu_subclk_setup(np, i, clk_621);
347 >------->-------if (WARN_ON(IS_ERR(cpuclk->subclks[i])))
348 >------->------->-------return;
349 >-------}

The third warning is a bit redundant, it is triggered by the same conditions
that triggered the second warning.

	  Josh
