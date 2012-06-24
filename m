Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2FXTti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 15:49:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:16334 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2FXTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 15:49:37 -0400
Date: Sun, 24 Jun 2012 21:49:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpufeature:   Rename X86_FEATURE_DTS to
 X86_FEATURE_DTHERM
Message-ID: <20120624214908.4177fc4a@endymion.delvare>
In-Reply-To: <tip-3bac8715443fc83413e221a5cd9d5cf3d82b79b4@git.kernel.org>
References: <4FE34BCB.5050305@linux.intel.com>
	<tip-3bac8715443fc83413e221a5cd9d5cf3d82b79b4@git.kernel.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 13:38:21 -0700, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  3bac8715443fc83413e221a5cd9d5cf3d82b79b4
> Gitweb:     http://git.kernel.org/tip/3bac8715443fc83413e221a5cd9d5cf3d82b79b4
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Fri, 22 Jun 2012 10:58:06 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 22 Jun 2012 10:58:06 -0700
> 
> x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
> 
> It makes sense to label "Digital Thermal Store" as "DTS", but

You mean "Digital Thermal Sensor".

> unfortunately the string "dts" was already used for "Debug Store", and
> /proc/cpuinfo is a user space ABI.
> 
> Therefore, rename this to "dtherm".

I see the rationale for changing the string in /proc/cpuinfo, and
"dtherm" is reasonably good. I fail to see the rationale for changing
the X86_FEATURE_ name though, this is an API change we don't need. Plus
X86_FEATURE_DTS has the merit of naming the feature the way it is
commonly done in technical documentation, so readers know exactly what
it refers too, which isn't the case of DTHERM. So can we please stick
to X86_FEATURE_DTS?

> This conflict went into mainline via the hwmon tree without any x86
> maintainer ack, and without any kind of hint in the subject.
> 
>     a4659053 x86/hwmon: fix initialization of coretemp

All 3 x86 maintainers were Cc'd, none commented. And you know fairly
well why the patch went through the hwmon tree. So please stop the
finger-pointing. It's unfortunate that it happened, but it did, and we
try to fix it now, period.

> Reported-by: Jean Delvare <khali@linux-fr.org>
> Link: http://lkml.kernel.org/r/4FE34BCB.5050305@linux.intel.com
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: <stable@vger.kernel.org> v2.6.36..v3.4

No Signed-off-by?

Not sure why you want this to go to stable trees?

> ---
>  arch/x86/include/asm/cpufeature.h |    2 +-
>  arch/x86/kernel/cpu/scattered.c   |    2 +-
>  drivers/hwmon/coretemp.c          |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

-- 
Jean Delvare
