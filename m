Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1GHJKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:10:21 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48183 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1GHJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:10:18 -0400
Date: Fri, 8 Jul 2011 13:10:14 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: Re: [PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
Message-ID: <20110708091014.GA15142@oksana.dev.rtsoft.ru>
References: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 01:59:23PM +0800, Tommy Lin wrote:
> Original mpcore_wdt config dependency is as follow:
> MPCORE_WATCHDOG -> HAVE_ARM_TWD -> SMP -> (CPU_V6K || CPU_V7)
> This patch will remove SMP and made the dependency as follow:
> MPCORE_WATCHDOG -> HAVE_ARM_TWD -> (CPU_V6K || CPU_V7)
> 
> The MPCore watchdog (and timer) can be found at ARM11 MPCore (CPU_V6K) and
> Cortex A9 MPCore (CPU_V7). The dependency between MPCORE_WATCHDOG and
> (CPU_V6K || CPUV7) is necessary, but the dependency of SMP is redundant.
> The MPCore watchdog should function normally even SMP is not turned on with
> ARM11 or Cortex A9 CPU.
> 
> Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
> ---

Russell,

As the patch is needed for CNS3xxx Watchdog support, I'd like to take
it via CNS3xxx tree, if you're OK with that.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
