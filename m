Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab1F3Flg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:41:36 -0400
Received: from linux-sh.org ([111.68.239.195]:49018 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1F3Fl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:41:29 -0400
Date: Thu, 30 Jun 2011 14:38:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] arm: platsmp: Allow secondary cpu hotplug with maxcpus=1
Message-ID: <20110630053851.GC22023@linux-sh.org>
References: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:31:39AM -0700, Stephen Boyd wrote:
> If an ARM system has multiple cpus in the same socket and the
> kernel is booted with maxcpus=1, secondary cpus are possible but
> not present due to how platform_smp_prepare_cpus() is called.
> Fix this by always calling platform_smp_prepare_cpus() as long as
> max_cpus is non-zero (0 means no SMP) to allow platform code to
> decide if any non-boot cpus are present in the system. Since
> all current platform code doesn't support physical hotplug we
> have a situation where possible == present and thus we can
> simply copy the possible map to the present map.
> 
> With this patch it's possible to boot an ARM system with
> maxcpus=1 on the command line and then hotplug in secondary cpus
> via sysfs. This is more in line with how x86 works with maxcpus=1
> on the command line.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
