Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2HGRvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:51:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:40770 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2HGRvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:51:44 -0400
Subject: Re: [PATCH 3/4] cpu: export cpu hotplug disable/enable functions as global functions
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 7 Aug 2012 12:51:13 -0500
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B4FC7F5E-EA8F-4FCA-B206-353FE4481DCE@kernel.crashing.org>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com> <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
To: srivatsa.bhat@linux.vnet.ibm.com, rjw@sisk.pl
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2012, at 3:43 AM, Zhao Chenhui wrote:

> The cpufreq driver of mpc85xx will disable/enable cpu hotplug temporarily.
> Therefore, the related functions should be exported.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
> include/linux/cpu.h |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)

Rafael, Srivatsa,

Wanted to get your ack on export these functions for direct calling by arch code.

- k

> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index ce7a074..df8f73d 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -146,6 +146,8 @@ void notify_cpu_starting(unsigned int cpu);
> extern void cpu_maps_update_begin(void);
> extern void cpu_maps_update_done(void);
> 
> +extern void cpu_hotplug_disable_before_freeze(void);
> +extern void cpu_hotplug_enable_after_thaw(void);
> #else	/* CONFIG_SMP */
> 
> #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> @@ -167,6 +169,8 @@ static inline void cpu_maps_update_done(void)
> {
> }
> 
> +static inline void cpu_hotplug_disable_before_freeze(void)	{}
> +static inline void cpu_hotplug_enable_after_thaw(void)	{}
> #endif /* CONFIG_SMP */
> extern struct bus_type cpu_subsys;
> 
> -- 
> 1.6.4.1
> 

