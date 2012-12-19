Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2LSR0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:26:06 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:59885 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2LSR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:26:01 -0500
Date: Wed, 19 Dec 2012 11:26:19 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Message-ID: <20121219172619.GB1005@beefymiracle.amer.corp.natinst.com>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
 <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 11:25:57 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 11:25:57 AM,
	Serialize complete at 12/19/2012 11:25:57 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_07:2012-12-19,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:02:15PM -0800, Stephen Boyd wrote:
> Reduce lines of code and simplify this driver by using the
> generic clock binding parsing function. This also fixes a bug
> where the 'flags' member of the init struct is not initialized.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Josh Cartwright <josh.cartwright@ni.com>
> Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  drivers/clk/clk-zynq.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)

Stephen-

Is there a particular tree I should be testing this against?  Booting this set
on top of linus/master gives me:

   Linux version 3.7.0-10837-g3bb3ebf (joshc@beefymiracle) (gcc version 4.6.3 (Sourcery CodeBench Lite 2012.03-57) ) #3 Wed Dec 19 11:19:20 CST 2012
   CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=18c53c7d
   CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
   Machine: Xilinx Zynq Platform, model: NI Zynq Prototype Board
   Memory policy: ECC disabled, Data cache writeback
   Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
   Kernel command line: console=ttyPS1,115200
   PID hash table entries: 2048 (order: 1, 8192 bytes)
   Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
   Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
   __ex_table already sorted, skipping sort
   Memory: 512MB = 512MB total
   Memory: 514304k/514304k available, 9984k reserved, 0K highmem
   Virtual kernel memory layout:
       vector  : 0xffff0000 - 0xffff1000   (   4 kB)
       fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
       vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
       lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
         .text : 0xc0008000 - 0xc0182e58   (1516 kB)
         .init : 0xc0183000 - 0xc01992cc   (  89 kB)
         .data : 0xc019a000 - 0xc01ac040   (  73 kB)
          .bss : 0xc01ac064 - 0xc01d30fc   ( 157 kB)
   SLUB: Genslabs=11, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
   NR_IRQS:16 nr_irqs:16 16
   ------------[ cut here ]------------
   WARNING: at drivers/clk/clk-zynq.c:159 zynq_periph_clk_setup+0x190/0x248()
   [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
   [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
   [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193520>] (zynq_periph_clk_setup+0x190/0x248)
   [<c0193520>] (zynq_periph_clk_setup+0x190/0x248) from [<c0192944>] (of_clk_init+0x30/0x58)
   [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
   [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
   [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
   [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
   ---[ end trace 1b75b31a2719ed1c ]---
   ------------[ cut here ]------------
   WARNING: at drivers/clk/clk-zynq.c:296 zynq_cpu_clk_setup+0x1e0/0x26c()
   [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
   [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
   [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c)
   [<c0193304>] (zynq_cpu_clk_setup+0x1e0/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
   [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
   [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
   [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
   [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
   ---[ end trace 1b75b31a2719ed1d ]---
   ------------[ cut here ]------------
   WARNING: at drivers/clk/clk-zynq.c:347 zynq_cpu_clk_setup+0x210/0x26c()
   [<c000d814>] (unwind_backtrace+0x0/0xf8) from [<c0016808>] (warn_slowpath_common+0x50/0x60)
   [<c0016808>] (warn_slowpath_common+0x50/0x60) from [<c00168e0>] (warn_slowpath_null+0x1c/0x24)
   [<c00168e0>] (warn_slowpath_null+0x1c/0x24) from [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c)
   [<c0193334>] (zynq_cpu_clk_setup+0x210/0x26c) from [<c0192944>] (of_clk_init+0x30/0x58)
   [<c0192944>] (of_clk_init+0x30/0x58) from [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48)
   [<c0189708>] (xilinx_zynq_timer_init+0x40/0x48) from [<c0185d54>] (time_init+0x28/0x30)
   [<c0185d54>] (time_init+0x28/0x30) from [<c0183650>] (start_kernel+0x1a8/0x2c0)
   [<c0183650>] (start_kernel+0x1a8/0x2c0) from [<00008074>] (0x8074)
   ---[ end trace 1b75b31a2719ed1e ]---
   sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms
   Calibrating delay loop... 3991.96 BogoMIPS (lpj=19959808)
   pid_max: default: 32768 minimum: 301
   Mount-cache hash table entries: 512
   CPU: Testing write buffer coherency: ok
   Setting up static identity map for 0x139e00 - 0x139e58
   devtmpfs: initialized
   DMA: preallocated 256 KiB pool for atomic coherent allocations
   L310 cache controller enabled
   l2x0: 8 ways, CACHE_ID 0x000000c0, AUX_CTRL 0x02060000, Cache size: 524288 B

Josh
