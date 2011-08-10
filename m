Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1HJBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:09:42 -0400
Received: from infernal.debian.net ([87.230.26.131]:51763 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HJBJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:09:40 -0400
Date: Wed, 10 Aug 2011 03:09:33 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
Message-ID: <20110810010933.GA4733@amos.fritz.box>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
 <20110719003503.GA4138@amos.fritz.box>
 <4E3FE2D2.5020801@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <4E3FE2D2.5020801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 08, 2011 at 03:21:22PM +0200, Jiri Slaby wrote:
> On 07/19/2011 02:35 AM, Andreas Bombe wrote:
> > On Thu, Jul 14, 2011 at 02:35:10PM +0200, Jiri Slaby wrote:
> >> This should also fix the issue Andreas is seeing (BTM in comparison to
> >> BKL doesn't have any hidden functionality like unlocking during
> >> sleeping).
> > 
> > I tested the patch series and it does not appear to make a difference
> > for the internal (16550A) serial ports on my system. Also, I am still
> > unclear on why it freezes the X display during the timeout period.
> 
> Sorry for the delay. Could you attach output of sysrq-t when this
> happens? I mean with a kernel patched by my patch.

I did my simple test on ttyS0 again: "stty -F /dev/ttyS0 crtscts" then
"echo >/dev/ttyS0". I attached the gzipped sysrq-t list in case you need
the complete output. This is just the process while it is trying to
close the device (bash's internal echo):

[  321.948012] bash            S ffff8800bcc85e80     0  4000   2828 0x00000000
[  321.948012]  ffff880127079c38 0000000000000046 ffff880127079c50 0000000100002fff
[  321.948012]  ffff880127079fd8 0000000000011fc0 ffff880127079fd8 0000000000011fc0
[  321.948012]  ffff8801270dde80 ffff8800bcc85e80 ffff880127079c38 0000000100002fff
[  321.948012] Call Trace:
[  321.948012]  [<ffffffff813cdf2e>] schedule_timeout+0xb5/0xf2
[  321.948012]  [<ffffffff8104ae2b>] ? call_timer_fn+0x154/0x154
[  321.948012]  [<ffffffff81255d60>] tty_wait_until_sent+0xa3/0xec
[  321.948012]  [<ffffffff8105a190>] ? __init_waitqueue_head+0x46/0x46
[  321.948012]  [<ffffffff81268c05>] uart_close+0x12b/0x243
[  321.948012]  [<ffffffff81250454>] ? __tty_fasync+0x5c/0x124
[  321.948012]  [<ffffffff81251a00>] tty_release+0x1d3/0x4d7
[  321.948012]  [<ffffffff813cfbd8>] ? _raw_spin_unlock+0x43/0x51
[  321.948012]  [<ffffffff8110db81>] ? dput+0xfe/0x11d
[  321.948012]  [<ffffffff810fdc86>] __fput+0x107/0x1a2
[  321.948012]  [<ffffffff810fdd36>] fput+0x15/0x17
[  321.948012]  [<ffffffff810fb014>] filp_close+0x69/0x75
[  321.948012]  [<ffffffff81109654>] sys_dup3+0x12b/0x153
[  321.948012]  [<ffffffff811096d5>] sys_dup2+0x59/0x60
[  321.948012]  [<ffffffff813d0a12>] system_call_fastpath+0x16/0x1b


[  321.948012] Sched Debug Version: v0.10, 3.1.0-rc1+ser-00011-g37ed45d #87
[  321.948012] ktime                                   : 321967.638593
[  321.948012] sched_clk                               : 321738.307013
[  321.948012] cpu_clk                                 : 321948.012318
[  321.948012] jiffies                                 : 4294972787
[  321.948012] sched_clock_stable                      : 0
[  321.948012] 
[  321.948012] sysctl_sched
[  321.948012]   .sysctl_sched_latency                    : 12.000000
[  321.948012]   .sysctl_sched_min_granularity            : 1.500000
[  321.948012]   .sysctl_sched_wakeup_granularity         : 2.000000
[  321.948012]   .sysctl_sched_child_runs_first           : 0
[  321.948012]   .sysctl_sched_features                   : 15471
[  321.948012]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  321.948012] 
[  321.948012] cpu#0, 3166.466 MHz
[  321.948012]   .nr_running                    : 2
[  321.948012]   .load                          : 1927
[  321.948012]   .nr_switches                   : 181895
[  321.948012]   .nr_load_updates               : 28885
[  321.948012]   .nr_uninterruptible            : 58
[  321.948012]   .next_balance                  : 4294.972819
[  321.948012]   .curr->pid                     : 11
[  321.948012]   .clock                         : 321964.006925
[  321.948012]   .cpu_load[0]                   : 1927
[  321.948012]   .cpu_load[1]                   : 1743
[  321.948012]   .cpu_load[2]                   : 1400
[  321.948012]   .cpu_load[3]                   : 1137
[  321.948012]   .cpu_load[4]                   : 871
[  321.948012]   .yld_count                     : 20444
[  321.948012]   .sched_switch                  : 0
[  321.948012]   .sched_count                   : 203439
[  321.948012]   .sched_goidle                  : 58617
[  321.948012]   .avg_idle                      : 1000000
[  321.948012]   .ttwu_count                    : 112788
[  321.948012]   .ttwu_local                    : 63063
[  321.948012] 
[  321.948012] cfs_rq[0]:/autogroup-58
[  321.948012]   .exec_clock                    : 995.435149
[  321.948012]   .MIN_vruntime                  : 962.061080
[  321.948012]   .min_vruntime                  : 962.061080
[  321.948012]   .max_vruntime                  : 962.061080
[  321.948012]   .spread                        : 0.000000
[  321.948012]   .spread0                       : -22090.643266
[  321.948012]   .nr_spread_over                : 0
[  321.948012]   .nr_running                    : 1
[  321.948012]   .load                          : 1024
[  321.948012]   .load_avg                      : 6435.076254
[  321.948012]   .load_period                   : 6.287393
[  321.948012]   .load_contrib                  : 1004
[  321.948012]   .load_tg                       : 1140
[  321.948012]   .se->exec_start                : 321727.319580
[  321.948012]   .se->vruntime                  : 23059.712463
[  321.948012]   .se->sum_exec_runtime          : 995.837577
[  321.948012]   .se->statistics.wait_start     : 321964.006925
[  321.948012]   .se->statistics.sleep_start    : 0.000000
[  321.948012]   .se->statistics.block_start    : 0.000000
[  321.948012]   .se->statistics.sleep_max      : 0.000000
[  321.948012]   .se->statistics.block_max      : 0.000000
[  321.948012]   .se->statistics.exec_max       : 4.000979
[  321.948012]   .se->statistics.slice_max      : 2.977407
[  321.948012]   .se->statistics.wait_max       : 8.300527
[  321.948012]   .se->statistics.wait_sum       : 309.360276
[  321.948012]   .se->statistics.wait_count     : 8489
[  321.948012]   .se->load.weight               : 903
[  321.948012] 
[  321.948012] cfs_rq[0]:/
[  321.948012]   .exec_clock                    : 20767.422942
[  321.948012]   .MIN_vruntime                  : 23059.712463
[  321.948012]   .min_vruntime                  : 23052.704346
[  321.948012]   .max_vruntime                  : 23059.712463
[  321.948012]   .spread                        : 0.000000
[  321.948012]   .spread0                       : 0.000000
[  321.948012]   .nr_spread_over                : 73
[  321.948012]   .nr_running                    : 2
[  321.948012]   .load                          : 1927
[  321.948012]   .load_avg                      : 0.000000
[  321.948012]   .load_period                   : 0.000000
[  321.948012]   .load_contrib                  : 0
[  321.948012]   .load_tg                       : 0
[  321.948012] 
[  321.948012] rt_rq[0]:
[  321.948012]   .rt_nr_running                 : 0
[  321.948012]   .rt_throttled                  : 0
[  321.948012]   .rt_time                       : 0.000000
[  321.948012]   .rt_runtime                    : 950.000000
[  321.948012] 
[  321.948012] runnable tasks:
[  321.948012]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  321.948012] ----------------------------------------------------------------------------------------------------------
[  321.948012] R    kworker/0:1    11     23052.704346     13969   120     23052.704346       555.720586    321027.845811 /
[  321.948012]        alsa-sink  3110       962.061080      4307   120       962.061080      1411.254175    258698.264923 /autogroup-58
[  321.948012] 
[  321.948012] cpu#1, 3166.466 MHz
[  321.948012]   .nr_running                    : 0
[  321.948012]   .load                          : 0
[  321.948012]   .nr_switches                   : 206709
[  321.948012]   .nr_load_updates               : 30117
[  321.948012]   .nr_uninterruptible            : -58
[  321.948012]   .next_balance                  : 4294.972776
[  321.948012]   .curr->pid                     : 0
[  321.948012]   .clock                         : 321846.477751
[  321.948012]   .cpu_load[0]                   : 947
[  321.948012]   .cpu_load[1]                   : 481
[  321.948012]   .cpu_load[2]                   : 282
[  321.948012]   .cpu_load[3]                   : 183
[  321.948012]   .cpu_load[4]                   : 133
[  321.948012]   .yld_count                     : 26864
[  321.948012]   .sched_switch                  : 0
[  321.948012]   .sched_count                   : 233886
[  321.948012]   .sched_goidle                  : 75296
[  321.948012]   .avg_idle                      : 1000000
[  321.948012]   .ttwu_count                    : 96142
[  321.948012]   .ttwu_local                    : 60872
[  321.948012] 
[  321.948012] cfs_rq[1]:/autogroup-58
[  321.948012]   .exec_clock                    : 1096.255751
[  321.948012]   .MIN_vruntime                  : 0.000001
[  321.948012]   .min_vruntime                  : 1043.264049
[  321.948012]   .max_vruntime                  : 0.000001
[  321.948012]   .spread                        : 0.000000
[  321.948012]   .spread0                       : -22009.440297
[  321.948012]   .nr_spread_over                : 0
[  321.948012]   .nr_running                    : 0
[  321.948012]   .load                          : 0
[  321.948012]   .load_avg                      : 894.748356
[  321.948012]   .load_period                   : 6.572338
[  321.948012]   .load_contrib                  : 136
[  321.948012]   .load_tg                       : 1140
[  321.948012]   .se->exec_start                : 321808.596733
[  321.948012]   .se->vruntime                  : 20943.081256
[  321.948012]   .se->sum_exec_runtime          : 1096.712219
[  321.948012]   .se->statistics.wait_start     : 0.000000
[  321.948012]   .se->statistics.sleep_start    : 0.000000
[  321.948012]   .se->statistics.block_start    : 0.000000
[  321.948012]   .se->statistics.sleep_max      : 0.000000
[  321.948012]   .se->statistics.block_max      : 0.000000
[  321.948012]   .se->statistics.exec_max       : 4.042092
[  321.948012]   .se->statistics.slice_max      : 1.274462
[  321.948012]   .se->statistics.wait_max       : 11.013496
[  321.948012]   .se->statistics.wait_sum       : 303.941198
[  321.948012]   .se->statistics.wait_count     : 8528
[  321.948012]   .se->load.weight               : 2
[  321.948012] 
[  321.948012] cfs_rq[1]:/autogroup-53
[  321.948012]   .exec_clock                    : 5152.934351
[  321.948012]   .MIN_vruntime                  : 0.000001
[  321.948012]   .min_vruntime                  : 10693.441896
[  321.948012]   .max_vruntime                  : 0.000001
[  321.948012]   .spread                        : 0.000000
[  321.948012]   .spread0                       : -12359.262450
[  321.948012]   .nr_spread_over                : 81
[  321.948012]   .nr_running                    : 0
[  321.948012]   .load                          : 0
[  321.948012]   .load_avg                      : 124.928296
[  321.948012]   .load_period                   : 6.455088
[  321.948012]   .load_contrib                  : 19
[  321.948012]   .load_tg                       : 19
[  321.948012]   .se->exec_start                : 321807.916228
[  321.948012]   .se->vruntime                  : 20936.418846
[  321.948012]   .se->sum_exec_runtime          : 5153.129023
[  321.948012]   .se->statistics.wait_start     : 0.000000
[  321.948012]   .se->statistics.sleep_start    : 0.000000
[  321.948012]   .se->statistics.block_start    : 0.000000
[  321.948012]   .se->statistics.sleep_max      : 0.000000
[  321.948012]   .se->statistics.block_max      : 0.000000
[  321.948012]   .se->statistics.exec_max       : 4.032091
[  321.948012]   .se->statistics.slice_max      : 7.996020
[  321.948012]   .se->statistics.wait_max       : 32.784820
[  321.948012]   .se->statistics.wait_sum       : 839.992046
[  321.948012]   .se->statistics.wait_count     : 55429
[  321.948012]   .se->load.weight               : 2
[  321.948012] 
[  321.948012] cfs_rq[1]:/
[  321.948012]   .exec_clock                    : 18512.679083
[  321.948012]   .MIN_vruntime                  : 0.000001
[  321.948012]   .min_vruntime                  : 20943.081256
[  321.948012]   .max_vruntime                  : 0.000001
[  321.948012]   .spread                        : 0.000000
[  321.948012]   .spread0                       : -2109.623090
[  321.948012]   .nr_spread_over                : 91
[  321.948012]   .nr_running                    : 0
[  321.948012]   .load                          : 0
[  321.948012]   .load_avg                      : 0.000000
[  321.948012]   .load_period                   : 0.000000
[  321.948012]   .load_contrib                  : 0
[  321.948012]   .load_tg                       : 0
[  321.948012] 
[  321.948012] rt_rq[1]:
[  321.948012]   .rt_nr_running                 : 0
[  321.948012]   .rt_throttled                  : 0
[  321.948012]   .rt_time                       : 0.000000
[  321.948012]   .rt_runtime                    : 950.000000
[  321.948012] 
[  321.948012] runnable tasks:
[  321.948012]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  321.948012] ----------------------------------------------------------------------------------------------------------
[  321.948012] 
[  321.948012] INFO: lockdep is turned off.

-- 
Andreas Bombe

--tThc/1wpZn/ma/RB
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="dmesg.sysrqt-complete.gz"
Content-Transfer-Encoding: base64

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
Um/WC/jMy6KIfvd/DsHZGI2jBwA=

--tThc/1wpZn/ma/RB--
