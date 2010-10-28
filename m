Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0J1ANM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:13:12 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:31800
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757440Ab0J1ANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:13:10 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LAZ4LL-02-1VG-02
X-M-MSG: 
Date: Thu, 28 Oct 2010 02:12:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sricharan <r.sricharan@ti.com>
Subject: Re: [PATCH v2] oprofile: Fix the hang while offline the cpu
Message-ID: <20101028001257.GZ5969@erda.amd.com>
References: <1288192635-11053-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288192635-11053-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.10.10 11:17:15, Santosh Shilimkar wrote:
> The kernel build with CONFIG_OPROFILE and CPU_HOTPLUG enabled.
> The oprofile is initialised using system timer in absence of hardware
> counters supports. Oprofile isn't started from userland.
> 
> In this setup while doing a CPU offline the kernel hangs in infinite
> for loop inside lock_hrtimer_base() function
> 
> This happens because as part of oprofile_cpu_notify(, it tries to
> stop an hrtimer which was never started. These per-cpu hrtimers
> are started when the oprfile is started.
> 	echo 1	> /dev/oprofile/enable
> 
> This problem also existwhen the cpu is booted with maxcpus parameter
> set. When bringing the remaining cpus online the timers are started
> even if oprofile is not yet enabled.
> 
> This patch fix this issue by adding a state variable so that
> these hrtimer start/stop is only attempted when oprofile is
> started
> 
> Reported-by: Jan Sebastien <s-jan@ti.com>
> Signed-off-by: sricharan <r.sricharan@ti.com>
> Tested-by: sricharan <r.sricharan@ti.com>
> Cc: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> V2: Updated patch with comments from Robert Richter
>  drivers/oprofile/timer_int.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)

Applied to oprofile/urgent, thanks Santosh.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

